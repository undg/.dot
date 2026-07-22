#!/usr/bin/env python3
# pyright: reportUnknownMemberType=false

import csv
import os
import platform
import signal
from collections.abc import Sequence
from typing import cast
from datetime import datetime, time, timedelta
from pathlib import Path
from types import FrameType

import matplotlib.dates as mdates
import matplotlib.patheffects as patheffects
import matplotlib.pyplot as plt
from matplotlib.backend_bases import KeyEvent, MouseEvent
from matplotlib.lines import Line2D
from matplotlib.text import Annotation

AI_CREDIT_USD = 0.01

if platform.system() == "Darwin":
    csv_path = Path.home() / "Library/Logs/coopilot-stats.csv"
else:
    state_home = Path(os.environ.get("XDG_STATE_HOME", Path.home() / ".local/state"))
    csv_path = state_home / "coopilot-stats/coopilot-stats.csv"


def load_rows(path: Path) -> tuple[list[datetime], list[float], list[float]]:
    timestamps: list[datetime] = []
    usage: list[float] = []
    entitlement: list[float] = []

    with path.open(newline="") as csv_file:
        reader = csv.DictReader(csv_file)
        for row in reader:
            timestamps.append(
                datetime.strptime(f"{row['date']} {row['time']}", "%Y-%m-%d %H:%M:%S")
            )
            usage.append(float(row["usage"]) * AI_CREDIT_USD)
            entitlement.append(float(row["entitlement"]) * AI_CREDIT_USD)

    return timestamps, usage, entitlement


def build_display_day_range(
    timestamps: Sequence[datetime],
) -> tuple[datetime, datetime, list[datetime]]:
    first_day_start = datetime.combine(timestamps[0].date(), time.min)
    if timestamps[-1].month == 12:
        display_end = datetime(timestamps[-1].year + 1, 1, 1)
    else:
        display_end = datetime(timestamps[-1].year, timestamps[-1].month + 1, 1)

    day_boundaries: list[datetime] = []
    current = first_day_start
    while current <= display_end:
        day_boundaries.append(current)
        current += timedelta(days=1)

    return first_day_start, display_end, day_boundaries


def add_day_start_points(
    timestamps: Sequence[datetime], usage: Sequence[float]
) -> tuple[list[datetime], list[float], list[bool]]:
    """Add a midnight point for every day covered by the data.

    The point carries the last known value from the preceding day. If there
    are no observations for a day, that value is carried forward to the next
    day as well.
    """
    plot_timestamps: list[datetime] = []
    plot_usage: list[float] = []
    is_day_start: list[bool] = []
    next_day = timestamps[0].date() + timedelta(days=1)
    last_value = usage[0]

    for timestamp, value in zip(timestamps, usage):
        while next_day <= timestamp.date():
            plot_timestamps.append(datetime.combine(next_day, time.min))
            plot_usage.append(last_value)
            is_day_start.append(True)
            next_day += timedelta(days=1)

        plot_timestamps.append(timestamp)
        plot_usage.append(value)
        is_day_start.append(False)
        last_value = value

    return plot_timestamps, plot_usage, is_day_start


def build_daily_usage_stats(
    timestamps: Sequence[datetime],
    usage: Sequence[float],
    is_day_start: Sequence[bool] | None = None,
) -> tuple[list[float | None], list[float | None], list[bool]]:
    previous_daily_usage: list[float | None] = [None] * len(timestamps)
    current_daily_usage: list[float | None] = [None] * len(timestamps)
    is_new_day = [False] * len(timestamps)

    day_ranges: list[tuple[int, int, float | None, float | None]] = []
    day_start = 0

    for index in range(1, len(timestamps) + 1):
        if (
            index == len(timestamps)
            or timestamps[index].date() != timestamps[day_start].date()
        ):
            day_end = index - 1
            day_baseline = usage[day_start - 1] if day_start > 0 else None
            first_real_point = day_start
            if is_day_start is not None:
                while first_real_point <= day_end and is_day_start[first_real_point]:
                    first_real_point += 1
            if (
                day_baseline is not None
                and first_real_point <= day_end
                and usage[first_real_point] < day_baseline
            ):
                day_baseline = 0
            day_total = (
                usage[day_end] - day_baseline if day_baseline is not None else None
            )
            day_ranges.append((day_start, day_end, day_baseline, day_total))
            day_start = index

    for day_index, (day_start, day_end, day_baseline, _) in enumerate(day_ranges):
        previous_day_total = day_ranges[day_index - 1][3] if day_index > 0 else None
        first_real_point = day_start

        if is_day_start is not None:
            while first_real_point <= day_end and is_day_start[first_real_point]:
                first_real_point += 1

        if day_baseline is not None:
            current_daily_usage[day_start] = day_ranges[day_index][3]

        for index in range(day_start, day_end + 1):
            previous_daily_usage[index] = previous_day_total
            is_new_day[index] = index == day_start and day_index > 0

    return previous_daily_usage, current_daily_usage, is_new_day


def date_number(value: datetime) -> float:
    return cast(float, mdates.date2num(value))


def date_numbers(values: Sequence[datetime]) -> list[float]:
    return [date_number(value) for value in values]


def main() -> None:
    timestamps, usage, entitlement = load_rows(csv_path)
    if not timestamps:
        raise SystemExit(f"No data in {csv_path}")

    x_positions, plot_usage, is_day_start = add_day_start_points(timestamps, usage)
    previous_daily_usage, current_daily_usage, is_new_day = build_daily_usage_stats(
        x_positions, plot_usage, is_day_start
    )
    display_start, display_end, day_boundaries = build_display_day_range(timestamps)

    fig, ax = plt.subplots(figsize=(14, 7))
    usage_line: Line2D
    (usage_line,) = ax.plot(
        date_numbers(x_positions),
        plot_usage,
        color="blue",
        linewidth=2,
        marker="o",
        markersize=4,
        label="usage (USD)",
    )
    _ = ax.plot(
        date_numbers(timestamps),
        entitlement,
        color="red",
        linewidth=2,
        label="entitlement (USD)",
    )

    day_start_positions = [
        (timestamp, value)
        for timestamp, value, day_start in zip(x_positions, plot_usage, is_day_start)
        if day_start
    ]
    if day_start_positions:
        day_start_timestamps, day_start_usage = zip(*day_start_positions)
        _ = ax.scatter(
            date_numbers(day_start_timestamps),
            day_start_usage,
            color="orange",
            edgecolors="black",
            linewidths=0.8,
            s=55,
            zorder=3,
            label="day start",
        )

    _ = ax.set_title("Coopilot stats (1 AI credit = $0.01 USD)")
    _ = ax.set_ylabel("USD")
    ax.grid(True, axis="y", alpha=0.3)
    _ = ax.legend()

    for boundary in day_boundaries[1:-1]:
        _ = ax.axvline(date_number(boundary), color="grey", linewidth=1, alpha=0.5)

    _ = ax.set_xlim(date_number(display_start), date_number(display_end))
    _ = ax.set_xticks(date_numbers(day_boundaries[:-1]))
    _ = ax.set_xticklabels(
        [boundary.strftime("%Y-%m-%d") for boundary in day_boundaries[:-1]],
        rotation=90,
        fontsize=8,
    )

    for index, daily_usage in enumerate(current_daily_usage):
        if daily_usage is not None:
            _ = ax.annotate(
                f"${daily_usage:.3f}",
                xy=(x_positions[index], plot_usage[index]),
                xytext=(-6, 12),
                textcoords="offset points",
                rotation=90,
                color="orange",
                path_effects=[patheffects.withStroke(linewidth=1, foreground="black")],
                ha="left",
                va="bottom",
                fontsize=8,
            )

    tooltip: Annotation = ax.annotate(
        "",
        xy=(0, 0),
        xytext=(10, 10),
        textcoords="offset points",
        bbox={"boxstyle": "round", "fc": "white", "alpha": 0.9},
    )
    tooltip.set_visible(False)

    def on_move(event: MouseEvent) -> None:
        if event.inaxes != ax:
            if tooltip.get_visible():
                tooltip.set_visible(False)
                fig.canvas.draw_idle()
            return

        contains, details = cast(
            tuple[bool, dict[str, list[int]]], usage_line.contains(event)
        )
        if not contains:
            if tooltip.get_visible():
                tooltip.set_visible(False)
                fig.canvas.draw_idle()
            return

        index: int = details["ind"][0]
        tooltip.xy = (date_number(x_positions[index]), plot_usage[index])

        tooltip_lines: list[str] = [
            x_positions[index].strftime("%Y-%m-%d %H:%M:%S"),
            f"usage: ${plot_usage[index]:.3f}",
        ]

        if not is_day_start[index]:
            previous_real_index = index - 1
            while previous_real_index >= 0 and is_day_start[previous_real_index]:
                previous_real_index -= 1

            if previous_real_index >= 0:
                task_usage = plot_usage[index] - plot_usage[previous_real_index]
                tooltip_lines.append(
                    f"task usage: ${task_usage:+.3f}"
                    if task_usage >= 0
                    else "task usage: n/a (usage reset)"
                )
            else:
                tooltip_lines.append("task usage: n/a")

        if is_new_day[index]:
            previous_day_total = previous_daily_usage[index]
            current_day_total = current_daily_usage[index]
            tooltip_lines.append(
                f"prev daily usage: ${previous_day_total:.3f}"
                if previous_day_total is not None
                else "prev daily usage: n/a"
            )
            tooltip_lines.append(
                f"current daily usage: ${current_day_total:.3f}"
                if current_day_total is not None
                else "current daily usage: n/a"
            )

        tooltip.set_text("\n".join(tooltip_lines))
        tooltip.set_visible(True)
        fig.canvas.draw_idle()

    def on_key(event: KeyEvent) -> None:
        if event.key in {"enter", "escape", "esc", "q"}:
            plt.close(fig)

    previous_sigint_handler = signal.getsignal(signal.SIGINT)

    def handle_sigint(signum: int, frame: FrameType | None) -> None:
        del signum, frame
        plt.close(fig)

    _ = fig.canvas.mpl_connect("motion_notify_event", on_move)
    _ = fig.canvas.mpl_connect("key_press_event", on_key)
    _ = signal.signal(signal.SIGINT, handle_sigint)

    plt.tight_layout()
    try:
        plt.show()
    finally:
        _ = signal.signal(signal.SIGINT, previous_sigint_handler)


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        pass
