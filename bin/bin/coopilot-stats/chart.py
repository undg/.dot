#!/usr/bin/env python3

import csv
import os
import platform
import signal
from datetime import datetime
from pathlib import Path

import matplotlib.pyplot as plt

if platform.system() == "Darwin":
    CSV_PATH = Path.home() / "Library/Logs/coopilot-stats.csv"
else:
    state_home = Path(os.environ.get("XDG_STATE_HOME", Path.home() / ".local/state"))
    CSV_PATH = state_home / "coopilot-stats/coopilot-stats.csv"


def load_rows(path: Path):
    timestamps = []
    usage = []
    entitlement = []

    with path.open(newline="") as csv_file:
        reader = csv.DictReader(csv_file)
        for row in reader:
            timestamps.append(
                datetime.strptime(f"{row['date']} {row['time']}", "%Y-%m-%d %H:%M:%S")
            )
            usage.append(float(row["usage"]))
            entitlement.append(float(row["entitlement"]))

    return timestamps, usage, entitlement


def build_tick_labels(timestamps):
    labels = []
    previous_date = None

    for stamp in timestamps:
        current_date = stamp.date()
        if current_date != previous_date:
            labels.append(stamp.strftime("%Y-%m-%d"))
        else:
            labels.append(stamp.strftime("%H:%M"))
        previous_date = current_date

    return labels


def main():
    timestamps, usage, entitlement = load_rows(CSV_PATH)
    if not timestamps:
        raise SystemExit(f"No data in {CSV_PATH}")

    x_positions = list(range(len(timestamps)))

    fig, ax = plt.subplots(figsize=(14, 7))
    (usage_line,) = ax.plot(
        x_positions,
        usage,
        color="blue",
        linewidth=2,
        marker="o",
        markersize=4,
        label="usage",
    )
    ax.plot(x_positions, entitlement, color="red", linewidth=2, label="entitlement")

    ax.set_title("Coopilot stats")
    ax.set_ylabel("Value")
    ax.grid(True, axis="y", alpha=0.3)
    ax.legend()

    ax.set_xticks(x_positions)
    ax.set_xticklabels(build_tick_labels(timestamps), rotation=90, fontsize=8)

    tooltip = ax.annotate(
        "",
        xy=(0, 0),
        xytext=(10, 10),
        textcoords="offset points",
        bbox={"boxstyle": "round", "fc": "white", "alpha": 0.9},
    )
    tooltip.set_visible(False)

    def on_move(event):
        if event.inaxes != ax:
            if tooltip.get_visible():
                tooltip.set_visible(False)
                fig.canvas.draw_idle()
            return

        contains, details = usage_line.contains(event)
        if not contains:
            if tooltip.get_visible():
                tooltip.set_visible(False)
                fig.canvas.draw_idle()
            return

        index = details["ind"][0]
        tooltip.xy = (x_positions[index], usage[index])
        tooltip.set_text(
            f"{timestamps[index].strftime('%Y-%m-%d %H:%M:%S')}\nusage: {usage[index]:.0f}"
        )
        tooltip.set_visible(True)
        fig.canvas.draw_idle()

    def on_key(event):
        if event.key in {"enter", "escape", "esc", "q"}:
            plt.close(fig)

    previous_sigint_handler = signal.getsignal(signal.SIGINT)

    def handle_sigint(signum, frame):
        plt.close(fig)

    fig.canvas.mpl_connect("motion_notify_event", on_move)
    fig.canvas.mpl_connect("key_press_event", on_key)
    signal.signal(signal.SIGINT, handle_sigint)

    plt.tight_layout()
    try:
        plt.show()
    finally:
        signal.signal(signal.SIGINT, previous_sigint_handler)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        pass
