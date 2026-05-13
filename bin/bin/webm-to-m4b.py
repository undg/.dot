#!/usr/bin/env python3
import argparse
import os
import re
import subprocess
import sys
import tempfile
from dataclasses import dataclass, field
from pathlib import Path


@dataclass
class Args:
    file: Path
    chapters: Path
    output_dir: Path = Path(".")
    author: str = ""
    title: str = ""
    narrator: str = ""
    genre: str = ""
    no_cover: bool = False


def parse_chapters(filepath):
    chapters = []
    with open(filepath, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            match = re.match(r"^(\d+):(\d+):(\d+)\s+(.+)$", line)
            if match:
                h, m, s, title = (
                    int(match.group(1)),
                    int(match.group(2)),
                    int(match.group(3)),
                    match.group(4),
                )
            else:
                parts = line.split(None, 1)
                timestamp = parts[0].split(":")
                h, m, s = int(timestamp[0]), int(timestamp[1]), int(timestamp[2])
                title = parts[1] if len(parts) > 1 else ""
            chapters.append((h, m, s, title))
    return chapters


def chapters_to_ffmpeg_metadata(chapters, duration_ms):
    lines = [";FFMETADATA1"]
    for i, (h, m, s, title) in enumerate(chapters):
        start_ms = (h * 3600 + m * 60 + s) * 1000
        end_ms = (
            duration_ms
            if i == len(chapters) - 1
            else (
                (
                    chapters[i + 1][0] * 3600
                    + chapters[i + 1][1] * 60
                    + chapters[i + 1][2]
                )
                * 1000
            )
        )
        lines.append("[CHAPTER]")
        lines.append("TIMEBASE=1/1000")
        lines.append(f"START={start_ms}")
        lines.append(f"END={end_ms}")
        lines.append(f"title={title}")
    return "\n".join(lines)


def parse_filename(filepath):
    stem = Path(filepath).stem
    stem = re.sub(r"\s*\[[^\]]+\]$", "", stem)
    parts = re.split(r"\s*[|]\s*", stem)
    author, title = "", ""
    narrator = ""
    genre = ""
    if len(parts) >= 1:
        author_title = parts[0]
        match = re.match(r"^(.+?)\s+-\s+(.+)$", author_title)
        if match:
            author = match.group(1).strip()
            title = match.group(2).strip()
    if len(parts) >= 3:
        narrator_part = parts[2].strip()
        m = re.match(r"^Czyta\s+(.+)$", narrator_part)
        if m:
            narrator = m.group(1).strip()
    if len(parts) >= 2:
        genre = parts[1].strip()
    return author, title, narrator, genre


def get_duration(webm_path):
    cmd = [
        "ffprobe",
        "-v",
        "error",
        "-show_entries",
        "format=duration",
        "-of",
        "default=noprint_wrappers=1:nokey=1",
        str(webm_path),
    ]
    result = subprocess.run(cmd, capture_output=True, text=True)
    return float(result.stdout.strip())


def extract_cover(webm_path, output_dir):
    jpg_path = Path(output_dir) / "cover.jpg"
    cmd = [
        "ffmpeg",
        "-y",
        "-i",
        str(webm_path),
        "-an",
        "-vf",
        "scale=600:-1",
        "-q:v",
        "2",
        str(jpg_path),
    ]
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        cmd = [
            "ffmpeg",
            "-y",
            "-i",
            str(webm_path),
            "-an",
            "-frames:v",
            "1",
            str(jpg_path),
        ]
        subprocess.run(cmd, capture_output=True, text=True)
    return jpg_path.exists()


def convert_to_m4b(webm_path, output_path, metadata, chapters_file):
    duration = get_duration(webm_path)
    duration_ms = int(duration * 1000)
    chapters_data = parse_chapters(chapters_file)
    chapter_metadata = chapters_to_ffmpeg_metadata(chapters_data, duration_ms)
    with tempfile.NamedTemporaryFile(
        mode="w", suffix=".txt", encoding="utf-8", delete=False
    ) as f:
        f.write(chapter_metadata)
        chapter_tmp = f.name
    cmd = [
        "ffmpeg",
        "-y",
        "-i",
        str(webm_path),
        "-i",
        chapter_tmp,
        "-map_metadata",
        "1",
        "-vn",
        "-codec:a",
        "aac",
        "-b:a",
        "128k",
        "-metadata",
        f"title={metadata['title']}",
        "-metadata",
        f"artist={metadata['artist']}",
        "-metadata",
        f"album_artist={metadata['artist']}",
        "-metadata",
        f"composer={metadata['narrator']}",
        "-metadata",
        f"genre={metadata['genre']}",
        "-metadata",
        f"comment={metadata['comment']}",
        str(output_path),
    ]
    result = subprocess.run(cmd, capture_output=True, text=True)
    os.unlink(chapter_tmp)
    if result.returncode != 0:
        print(f"FFmpeg error: {result.stderr}", file=sys.stderr)
        sys.exit(1)


def main():
    parser = argparse.ArgumentParser(
        description="Convert webm to m4b with chapters for audiobookshelf"
    )
    parser.add_argument("--file", "-f", required=True, help="Path to webm file")
    parser.add_argument(
        "--chapters", "-c", required=True, help="Path to chapters.txt file"
    )
    parser.add_argument("--output-dir", "-o", default=".", help="Output directory")
    parser.add_argument("--author", "-a", help="Override author")
    parser.add_argument("--title", "-t", help="Override title")
    parser.add_argument("--narrator", "-n", help="Override narrator")
    parser.add_argument("--genre", "-g", help="Override genre")
    parser.add_argument("--no-cover", action="store_true", help="Skip cover extraction")
    args = parser.parse_args()
    webm_path = Path(args.file)
    chapters_path = Path(args.chapters)
    output_dir = Path(args.output_dir)
    if not webm_path.exists():
        print(f"Webm file not found: {webm_path}", file=sys.stderr)
        sys.exit(1)
    if not chapters_path.exists():
        print(f"Chapters file not found: {chapters_path}", file=sys.stderr)
        sys.exit(1)
    output_dir.mkdir(parents=True, exist_ok=True)
    author, title, narrator, genre = parse_filename(webm_path)
    if args.author:
        author = args.author
    if args.title:
        title = args.title
    if args.narrator:
        narrator = args.narrator
    if args.genre:
        genre = args.genre
    if not author or not title:
        print(
            "Could not parse author/title from filename. Use --author and --title to override.",
            file=sys.stderr,
        )
        sys.exit(1)
    safe_author = re.sub(r'[<>:"/\\|?*]', "_", author)
    safe_title = re.sub(r'[<>:"/\\|?*]', "_", title)
    output_name = f"{safe_author} - {safe_title}.m4b"
    output_path = output_dir / output_name
    metadata = {
        "title": title,
        "artist": author,
        "narrator": narrator,
        "genre": genre,
        "comment": "Audiobookshelf ready",
    }
    print(f"Converting {webm_path.name} -> {output_path}")
    convert_to_m4b(webm_path, output_path, metadata, chapters_path)
    if not args.no_cover:
        extract_cover(webm_path, output_dir)
    print(f"Done: {output_path}")


if __name__ == "__main__":
    main()
