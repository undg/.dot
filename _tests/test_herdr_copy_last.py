import os
import subprocess
import tempfile
import unittest
from pathlib import Path

SCRIPT = Path(__file__).resolve().parents[1] / "bin" / "bin" / "herdr-copy-last"


class CopyLastTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.screen = self.root / "screen"
        self.clipboard = self.root / "clipboard"
        self.args = self.root / "args"
        self.notification = self.root / "notification"
        self.screen.write_text("", encoding="utf-8")
        self.clipboard.write_text("keep existing clipboard", encoding="utf-8")
        for name, body in {
            "herdr": 'if [ "$1" = notification ]; then\n'
            '  printf "%s\\n" "$@" > "$TEST_NOTIFICATION"\n'
            '  exit "${TEST_NOTIFICATION_EXIT:-0}"\n'
            'fi\n'
            'printf "%s\\n" "$@" > "$TEST_ARGS"\n'
            'cat "$TEST_SCREEN"\nexit "${TEST_READ_EXIT:-0}"\n',
            "pbcopy": 'if [ "${TEST_COPY_EXIT:-0}" != 0 ]; then exit "$TEST_COPY_EXIT"; fi\n'
            'cat > "$TEST_CLIPBOARD"\n',
        }.items():
            stub = self.root / name
            stub.write_text("#!/bin/sh\n" + body, encoding="utf-8")
            stub.chmod(0o755)
        self.env = os.environ.copy()
        for name in ("HERDR_BIN_PATH", "HERDR_ACTIVE_PANE_ID", "HERDR_PANE_ID"):
            self.env.pop(name, None)
        self.env.update(
            PATH=f"{self.root}:{self.env['PATH']}",
            HERDR_ACTIVE_PANE_ID="w1:p2",
            TEST_SCREEN=str(self.screen),
            TEST_CLIPBOARD=str(self.clipboard),
            TEST_ARGS=str(self.args),
            TEST_NOTIFICATION=str(self.notification),
        )

    def run_script(self, *args):
        return subprocess.run(
            ["bash", str(SCRIPT), *args],
            env=self.env,
            capture_output=True,
            text=True,
        )

    def test_copies_latest_block_including_prompt_header_and_blank_lines(self):
        for icon in ("", "🐧", "arch", "ubuntu", "termux"):
            with self.subTest(icon=icon):
                self.screen.write_text(
                    "startup text\n❯ old-command\nold output\n"
                    f"{icon} ~/Research\n"
                    "  ❯ printf hello\nhello\n\n"
                    f"{icon} ~/Research\n❯       battery 100%\n",
                    encoding="utf-8",
                )
                result = self.run_script()
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(
                    self.clipboard.read_text(encoding="utf-8"),
                    f"  ❯ printf hello\nhello\n\n{icon} ~/Research\n",
                )
        self.assertEqual(
            self.args.read_text().splitlines(),
            [
                "pane",
                "read",
                "w1:p2",
                "--source",
                "recent-unwrapped",
                "--lines",
                "1000",
            ],
        )

    def test_successful_copy_shows_silent_notification(self):
        self.screen.write_text("❯ command\noutput\n❯\n", encoding="utf-8")
        result = self.run_script()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(self.clipboard.read_text(), "❯ command\noutput\n")
        self.assertEqual(
            self.notification.read_text().splitlines(),
            ["notification", "show", "Last command output copied", "--sound", "none"],
        )
        self.assertEqual(result.stdout, "")

    def test_failed_copy_does_not_notify(self):
        self.screen.write_text("❯ command\noutput\n❯\n", encoding="utf-8")
        self.env["TEST_COPY_EXIT"] = "1"
        result = self.run_script()
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(self.notification.exists())
        self.assertEqual(self.clipboard.read_text(), "keep existing clipboard")

    def test_notification_failure_does_not_fail_successful_copy(self):
        self.screen.write_text("❯ command\noutput\n❯\n", encoding="utf-8")
        self.env["TEST_NOTIFICATION_EXIT"] = "1"
        result = self.run_script()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(self.clipboard.read_text(), "❯ command\noutput\n")
        self.assertIn("Output copied, but the Herdr notification failed.", result.stderr)

    def test_ignores_arrows_inside_output_and_accepts_bare_idle_prompt(self):
        self.screen.write_text(
            "❯ command\na ❯ b\n❯not-a-prompt\n❯\n",
            encoding="utf-8",
        )
        result = self.run_script()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(
            self.clipboard.read_text(encoding="utf-8"),
            "❯ command\na ❯ b\n❯not-a-prompt\n",
        )

    def test_missing_boundary_leaves_clipboard_unchanged(self):
        self.screen.write_text("truncated output\n❯\n", encoding="utf-8")
        result = self.run_script()
        self.assertNotEqual(result.returncode, 0)
        self.assertIn("Could not find two", result.stderr)
        self.assertFalse(self.notification.exists())
        self.assertEqual(self.clipboard.read_text(), "keep existing clipboard")

    def test_failed_read_leaves_clipboard_unchanged_even_with_valid_text(self):
        self.screen.write_text("❯ command\noutput\n❯\n", encoding="utf-8")
        self.env["TEST_READ_EXIT"] = "1"
        result = self.run_script()
        self.assertNotEqual(result.returncode, 0)
        self.assertFalse(self.notification.exists())
        self.assertEqual(self.clipboard.read_text(), "keep existing clipboard")

    def test_pane_environment_and_binary_override(self):
        self.env.pop("HERDR_ACTIVE_PANE_ID")
        self.env["HERDR_PANE_ID"] = "w2:p3"
        self.env["HERDR_BIN_PATH"] = str(self.root / "herdr")
        self.screen.write_text("❯ command\noutput\n❯\n", encoding="utf-8")
        result = self.run_script()
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertEqual(self.args.read_text().splitlines()[2], "w2:p3")

    def test_help_needs_no_pane_and_unknown_arguments_fail(self):
        self.env.pop("HERDR_ACTIVE_PANE_ID")
        for flag in ("-h", "--help"):
            result = self.run_script(flag)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertIn("Usage:", result.stdout)
        self.assertEqual(self.run_script("--unknown").returncode, 2)
        self.assertIn("No Herdr pane", self.run_script().stderr)
        self.assertFalse(self.args.exists())


if __name__ == "__main__":
    unittest.main()
