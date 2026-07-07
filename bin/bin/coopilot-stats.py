#!/usr/bin/env python3

import csv
from datetime import datetime
from pathlib import Path

import matplotlib.pyplot as plt


CSV_PATH = Path.home() / "Library/Logs/coopilot-stats.csv"


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
    ax.plot(x_positions, usage, color="blue", linewidth=2, label="usage")
    ax.plot(x_positions, entitlement, color="red", linewidth=2, label="entitlement")

    ax.set_title("Coopilot stats")
    ax.set_ylabel("Value")
    ax.grid(True, axis="y", alpha=0.3)
    ax.legend()

    ax.set_xticks(x_positions)
    ax.set_xticklabels(build_tick_labels(timestamps), rotation=90, fontsize=8)

    plt.tight_layout()
    plt.show()


if __name__ == "__main__":
    main()
