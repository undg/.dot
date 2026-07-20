#!/usr/bin/env python3

import csv
import os
import platform
import signal
from datetime import datetime, time, timedelta
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


def build_display_day_range(timestamps):
    first_day_start = datetime.combine(timestamps[0].date(), time.min)
    if timestamps[-1].month == 12:
        display_end = datetime(timestamps[-1].year + 1, 1, 1)
    else:
        display_end = datetime(timestamps[-1].year, timestamps[-1].month + 1, 1)

    day_boundaries = []
    current = first_day_start
    while current <= display_end:
        day_boundaries.append(current)
        current += timedelta(days=1)

    return first_day_start, display_end, day_boundaries


def add_day_start_points(timestamps, usage):
    """Add a midnight point for every day covered by the data.

    The point carries the last known value from the preceding day. If there
    are no observations for a day, that value is carried forward to the next
    day as well.
    """
    plot_timestamps = []
    plot_usage = []
    next_day = timestamps[0].date() + timedelta(days=1)
    last_value = usage[0]

    for timestamp, value in zip(timestamps, usage):
        while next_day <= timestamp.date():
            plot_timestamps.append(datetime.combine(next_day, time.min))
            plot_usage.append(last_value)
            next_day += timedelta(days=1)

        plot_timestamps.append(timestamp)
        plot_usage.append(value)
        last_value = value

    return plot_timestamps, plot_usage


def build_daily_usage_stats(timestamps, usage):
    previous_daily_usage = [None] * len(timestamps)
    current_daily_usage = [None] * len(timestamps)
    is_new_day = [False] * len(timestamps)

    day_ranges = []
    day_start = 0

    for index in range(1, len(timestamps) + 1):
        if index == len(timestamps) or timestamps[index].date() != timestamps[day_start].date():
            day_end = index - 1
            day_baseline = usage[day_start - 1] if day_start > 0 else None
            day_total = usage[day_end] - day_baseline if day_baseline is not None else None
            day_ranges.append((day_start, day_end, day_baseline, day_total))
            day_start = index

    for day_index, (day_start, day_end, day_baseline, _) in enumerate(day_ranges):
        previous_day_total = day_ranges[day_index - 1][3] if day_index > 0 else None

        for index in range(day_start, day_end + 1):
            if day_baseline is not None:
                current_daily_usage[index] = usage[index] - day_baseline
            previous_daily_usage[index] = previous_day_total
            is_new_day[index] = index == day_start and day_index > 0

    return previous_daily_usage, current_daily_usage, is_new_day


def main():
    timestamps, usage, entitlement = load_rows(CSV_PATH)
    if not timestamps:
        raise SystemExit(f"No data in {CSV_PATH}")

    x_positions, plot_usage = add_day_start_points(timestamps, usage)
    previous_daily_usage, current_daily_usage, is_new_day = build_daily_usage_stats(
        x_positions, plot_usage
    )
    display_start, display_end, day_boundaries = build_display_day_range(timestamps)

    fig, ax = plt.subplots(figsize=(14, 7))
    (usage_line,) = ax.plot(
        x_positions,
        plot_usage,
        color="blue",
        linewidth=2,
        marker="o",
        markersize=4,
        label="usage",
    )
    ax.plot(timestamps, entitlement, color="red", linewidth=2, label="entitlement")

    ax.set_title("Coopilot stats")
    ax.set_ylabel("Value")
    ax.grid(True, axis="y", alpha=0.3)
    ax.legend()

    for boundary in day_boundaries[1:-1]:
        ax.axvline(boundary, color="grey", linewidth=1, alpha=0.5)

    ax.set_xlim(display_start, display_end)
    ax.set_xticks(day_boundaries[:-1])
    ax.set_xticklabels(
        [boundary.strftime("%Y-%m-%d") for boundary in day_boundaries[:-1]],
        rotation=90,
        fontsize=8,
    )

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
        tooltip.xy = (x_positions[index], plot_usage[index])

        previous_usage = plot_usage[index - 1] if index > 0 else None
        task_usage = plot_usage[index] - previous_usage if previous_usage is not None else None

        tooltip_lines = [
            x_positions[index].strftime('%Y-%m-%d %H:%M:%S'),
            f"usage: {plot_usage[index]:.0f}",
        ]
        if previous_usage is not None:
            tooltip_lines.append(f"prev usage: {previous_usage:.0f}")
            tooltip_lines.append(f"task usage: {task_usage:+.0f}")
        else:
            tooltip_lines.append("prev usage: n/a")
            tooltip_lines.append("task usage: n/a")

        if is_new_day[index]:
            previous_day_total = previous_daily_usage[index]
            current_day_total = current_daily_usage[index]
            tooltip_lines.append(
                f"prev daily usage: {previous_day_total:.0f}"
                if previous_day_total is not None
                else "prev daily usage: n/a"
            )
            tooltip_lines.append(
                f"current daily usage: {current_day_total:.0f}"
                if current_day_total is not None
                else "current daily usage: n/a"
            )

        tooltip.set_text("\n".join(tooltip_lines))
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
