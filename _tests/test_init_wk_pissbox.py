"""Run with: python3 -m unittest discover -s _tests -v."""

import os
from pathlib import Path
import subprocess
import tempfile
import tomllib
import unittest


SCRIPT = Path(__file__).resolve().parents[1] / "bin" / "bin" / "init-wk-pissbox"


class InitWkPissboxTest(unittest.TestCase):
    def setUp(self):
        self.storage = tempfile.TemporaryDirectory()
        self.addCleanup(self.storage.cleanup)
        self.root = Path(self.storage.name) / "project with spaces"
        self.root.mkdir()
        self.git("init", "-q")

    def git(self, *args, cwd=None):
        return subprocess.run(
            ["git", *args], cwd=cwd or self.root,
            check=True, text=True, capture_output=True,
        ).stdout.strip()

    def run_init(self, *args, cwd=None, success=True):
        result = subprocess.run(
            [str(SCRIPT), *args], cwd=cwd or self.root,
            text=True, capture_output=True,
        )
        if success:
            self.assertEqual(result.returncode, 0, result.stderr)
        else:
            self.assertNotEqual(result.returncode, 0, result.stdout)
        return result

    def configs(self):
        return {
            name: (self.root / name).read_bytes()
            for name in (".wk.toml", ".pissbox.toml", ".wk/.pissbox.toml")
        }

    def commit(self):
        self.git("-c", "user.name=Test", "-c", "user.email=test@example.invalid",
                 "-c", "core.hooksPath=/dev/null", "commit", "--allow-empty", "-qm", "Initial")

    def test_creates_valid_configs_and_local_ignore_then_reruns_without_writes(self):
        self.run_init()
        configs = self.configs()
        root_config = tomllib.loads(configs[".pissbox.toml"].decode())
        worktree_config = tomllib.loads(configs[".wk/.pissbox.toml"].decode())
        self.assertEqual(root_config, {"workspaces": [], "setup": []})
        self.assertEqual(worktree_config, {"workspaces": ["../.."], "setup": []})
        self.assertTrue(tomllib.loads(configs[".wk.toml"].decode())["teardown"])
        self.assertFalse((self.root / ".gitignore").exists())
        self.git("check-ignore", ".wk/.pissbox.toml")
        self.assertIn("?? .wk.toml", self.git("status", "--short"))
        paths = [self.root / name for name in configs] + [self.root / ".git/info/exclude"]
        before = [(path.read_bytes(), path.stat().st_mtime_ns) for path in paths]
        self.run_init()
        self.assertEqual(before, [(path.read_bytes(), path.stat().st_mtime_ns) for path in paths])

    def test_conflicts_abort_before_any_write(self):
        for name in (".wk.toml", ".pissbox.toml", ".wk/.pissbox.toml"):
            with self.subTest(name=name):
                project = self.root / name.replace("/", "-")
                project.mkdir()
                self.git("init", "-q", cwd=project)
                conflict = project / name
                conflict.parent.mkdir(parents=True, exist_ok=True)
                conflict.write_text("custom config\n")
                exclude = project / ".git/info/exclude"
                before = exclude.read_bytes()
                result = self.run_init(cwd=project, success=False)
                self.assertIn("Conflict", result.stderr)
                self.assertEqual(conflict.read_text(), "custom config\n")
                self.assertEqual(exclude.read_bytes(), before)
                for other in (".wk.toml", ".pissbox.toml", ".wk/.pissbox.toml"):
                    if other != name:
                        self.assertFalse((project / other).exists())

    def test_broken_config_symlink_and_symlinked_wk_are_preserved(self):
        link = self.root / ".wk.toml"
        link.symlink_to("missing")
        self.run_init(success=False)
        self.assertEqual(os.readlink(link), "missing")
        self.assertFalse((self.root / ".pissbox.toml").exists())
        link.unlink()
        (self.root / ".wk").symlink_to(self.root, target_is_directory=True)
        self.run_init(success=False)
        self.assertFalse((self.root / ".wk.toml").exists())

    def test_fills_missing_configs_and_handles_exclude_without_final_newline(self):
        self.run_init()
        expected = self.configs()
        (self.root / ".pissbox.toml").unlink()
        exclude = self.root / ".git/info/exclude"
        exclude.write_text("custom-rule")
        self.run_init()
        self.assertEqual(self.configs(), expected)
        self.assertEqual(exclude.read_text(), "custom-rule\n/.wk/\n")
        self.git("check-ignore", ".wk/.pissbox.toml")

    def test_real_worktree_setup_is_repeat_safe_and_preserves_existing_files(self):
        self.run_init()
        self.commit()
        worktree = self.root / ".wk/task"
        self.git("worktree", "add", "-qb", "task", str(worktree))
        setup = tomllib.loads((self.root / ".wk.toml").read_text())["setup"]
        for _ in range(2):
            for step in setup:
                subprocess.run(["sh", "-c", step], cwd=worktree, check=True)
        self.assertEqual(os.readlink(worktree / ".pissbox.toml"), "../.pissbox.toml")
        self.assertEqual(os.readlink(worktree / ".wk.toml"), "../../.wk.toml")
        self.assertEqual((worktree / ".pissbox.toml").resolve(), self.root / ".wk/.pissbox.toml")
        self.run_init(cwd=worktree, success=False)
        (worktree / ".wk.toml").unlink()
        (worktree / ".wk.toml").write_text("tracked config\n")
        (worktree / ".pissbox.toml").unlink()
        (worktree / ".pissbox.toml").symlink_to("missing")
        for step in setup:
            subprocess.run(["sh", "-c", step], cwd=worktree, check=True)
        self.assertEqual((worktree / ".wk.toml").read_text(), "tracked config\n")
        self.assertEqual(os.readlink(worktree / ".pissbox.toml"), "missing")

    def test_supports_bare_repository_and_redirect_wrapper(self):
        bare = self.root / "bare.git"
        self.git("init", "--bare", "-q", str(bare))
        self.run_init(cwd=bare)
        self.assertTrue((bare / ".wk/.pissbox.toml").is_file())
        wrapper = self.root / "wrapper"
        wrapper.mkdir()
        self.git("init", "--bare", "-q", str(wrapper / ".bare"))
        (wrapper / ".git").write_text("gitdir: ./.bare\n")
        self.run_init(cwd=wrapper)
        self.assertTrue((wrapper / ".wk.toml").is_file())
        self.assertIn("/.wk/", (wrapper / ".bare/info/exclude").read_text())
        self.run_init(cwd=wrapper / ".bare", success=False)

    def test_rejects_subdirectories_nonrepositories_and_unknown_arguments(self):
        nested = self.root / "nested"
        nested.mkdir()
        self.run_init(cwd=nested, success=False)
        self.run_init(cwd=self.root.parent, success=False)
        self.run_init("--force", success=False)
        self.assertFalse((self.root / ".wk.toml").exists())
        self.assertFalse((nested / ".wk.toml").exists())

    def test_help_needs_no_repository(self):
        for option in ("-h", "--help"):
            self.assertIn("Usage:", self.run_init(option, cwd=self.root.parent).stdout)


if __name__ == "__main__":
    unittest.main()
