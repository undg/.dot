import itertools
import platform
import sys
import threading
import time
from random import randint


def slow_print(text, delay=0.03):
    for c in text:
        sys.stdout.write(c)
        sys.stdout.flush()
        time.sleep(delay)


def spinner():
    spinner = itertools.cycle(['|', '/', '-', '\\'])
    while True:
        sys.stdout.write(next(spinner))
        sys.stdout.flush()
        sys.stdout.write('\b')
        time.sleep(0.1)


def blue_screen():
    blue = """
    A problem has been detected and Windows has been shut down to prevent damage to your computer.

    CRITICAL_PROCESS_DIED

    If this is the first time you've seen this stop error screen,
    restart your computer. If this screen appears again, follow
    these steps:

    Check if you paid for WinRAR license...
    """  # noqa: E501

    if randint(1, 5) == 1:  # 20% chance of BSOD
        print("\033[94m")  # Blue color
        slow_print(blue)
        sys.exit(1)


def windows_experience():
    print(
        "\n🪟 Windows User Experience™ Activated!"
    )

    spinner_thread = threading.Thread(target=spinner)
    spinner_thread.daemon = True
    spinner_thread.start()

    messages = [
        "Checking for viruses...",
        "Scanning registry...",
        "Updating Windows Defender...",
        "Installing mandatory updates...",
        "Restarting required services...",
        "Checking Microsoft Store connection...",
        "Validating licenses...",
        "Preparing to prepare...",
        "Almost ready to start preparing...",
        "Configuring configurations...",
        "Would you like to set Edge as default? (Y/Y)",
        "Cortana is feeling lonely...",
        "Installing candy crush...",
        "Downloading Edge promotional material...",
        "Creating restore point (just kidding)...",
    ]

    for msg in messages:
        blue_screen()  # Maybe BSOD?
        time.sleep(randint(1, 3))
        print(f"\n{msg}")
        if randint(1, 4) == 1:
            print("Error! Retrying...")
            time.sleep(2)

    print("\n⚠️ Your PC needs to restart to continue...")
    time.sleep(2)
    return False


def mac_experience():
    slow_print("🔍 Checking credit card validity...\n")
    time.sleep(1)
    slow_print("💰 Calculating Apple tax...\n")
    time.sleep(1)

    price = randint(99, 999)
    slow_print(f"""
🍎 MAC USER DETECTED---------
Premium Feature Paywall:
- Basic CLI access: ${price}
- Yearly renewal: ${price*2}
- Notarization fee: ${price/2}
- Tim Cook tip: ${price/4}
------------------------
Total: ${price*4}

Please contact Apple Support to proceed...
    """)
    return False


def check_platform():
    system = platform.system()
    if system == "Windows":
        return windows_experience()
    elif system == "Darwin":
        return mac_experience()
    else:
        print("🐧 Chad Linux user detected. Proceeding immediately.")
        print("⚡ No bloatware, no spyware, just freedom!")
        return True


def main():
    if not check_platform():
        slow_print("Exiting... Please install Linux!\n")
        sys.exit(1)
    print("App running in based OS!")


if __name__ == "__main__":
    main()


