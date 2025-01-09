#!/usr/bin/env python3
import argparse
import json
import os
import signal
import sys
import termios
import tty
import webbrowser
from datetime import datetime
from io import StringIO
from unittest.mock import MagicMock, patch

import requests
from openai import OpenAI


def get_args():
    parser = argparse.ArgumentParser(description="DALL-E image generator")
    parser.add_argument(
        "prompt", nargs="?", help="Image prompt (if not provided, will read from stdin)"
    )
    parser.add_argument(
        "-p", "--portrait", action="store_true", help="Portrait mode (1024x1792)"
    )
    parser.add_argument(
        "-l", "--landscape", action="store_true", help="Landscape mode (1792x1024)"
    )
    parser.add_argument("--hd", action="store_true", help="HD quality")
    parser.add_argument("-n", "--natural",
                        action="store_true", help="Natural style")
    parser.add_argument("--verbose", action="store_true", help="verbose")
    return parser.parse_args()


def get_prompt():
    args = sys.argv[1:]
    filtered = [arg for arg in args if not arg.startswith("-")]

    if filtered[0]:
        return filtered[0]
    return sys.stdin.read().strip()


def get_default_filename():
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    return f"dalle_{timestamp}"


def test_get_default_filename():
    assert get_default_filename().startswith("dalle_")


def save_files(url, params):
    default_name = get_default_filename()
    filename = input(f"Save as ({default_name}): ").strip()
    filename = filename if filename else default_name

    # Save image
    img_path = f"{filename}.png"
    response = requests.get(url)
    if response.status_code == 200:
        with open(img_path, "wb") as f:
            f.write(response.content)

        # Save metadata
        meta_path = f"{filename}.json"
        with open(meta_path, "w") as f:
            json.dump(params, f, indent=2)

        print(
            f"Saved:\n  Image: {os.path.abspath(img_path)}\n  Meta: {os.path.abspath(meta_path)}"
        )
        return True

    print("Failed to save files")
    return False


def get_char():
    # get file descriptor, keeb input stream
    fd = sys.stdin.fileno()
    old_settings = termios.tcgetattr(fd)
    try:
        tty.setraw(fd)
        ch = sys.stdin.read(1)
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
    return ch


def test_get_char():
    char = "a"
    # Create fake terminal settings to return from tcgetattr
    mock_termios = MagicMock()
    # Create fake keyboard
    mock_stdin = StringIO(char)

    def mock_fileno():
        return 0

    mock_stdin.fileno = mock_fileno

    def mock_read(num):
        return char

    mock_stdin.read = mock_read

    # Use all mocks
    with patch("sys.stdin", mock_stdin), patch(
        "termios.tcgetattr", return_value=mock_termios
    ), patch("termios.tcsetattr"), patch("tty.setraw"):

        assert get_char() == char


def generate_image(prompt, args):
    if args.verbose:
        print("Open OpenAi client")

    client = OpenAI()

    size = "1024x1024"
    if args.portrait:
        size = "1024x1792"
    elif args.landscape:
        size = "1792x1024"

    params = {
        "model": "dall-e-3",
        "prompt": prompt,
        "size": size,
        "quality": "hd" if args.hd else "standard",
        "style": "natural" if args.natural else "vivid",
        "n": 1,
    }

    response = client.images.generate(**params)
    return response.data[0].url, params


def show_actions(url, params):
    while True:
        print(
            "What do with image? [o]pen/[s]ave/[p]rint/[q]uit: ", end="", flush=True)
        action = get_char().lower()
        print(action)

        if action == "o":
            webbrowser.open(url)
        elif action == "p":
            print(url)
        elif action == "s":
            save_files(url, params)
        elif action == "q":
            break


def signal_handler(sig, frame):
    print("\nGrug say goodbye!")
    sys.exit(0)


def main():
    signal.signal(signal.SIGINT, signal_handler)

    args = get_args()
    if args.verbose:
        print("args", args)

    prompt = get_prompt()

    if not prompt:
        print("Missing prompt", file=sys.stderr)

    if args.verbose:
        print("prompt", prompt)

    url, params = generate_image(prompt, args)
    if args.verbose:
        print("url", url)
        print("params", params)

    show_actions(url, params)


if __name__ == "__main__":
    main()
