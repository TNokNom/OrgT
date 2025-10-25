import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import math
import argparse
import os


# -----------------------------
# Utility & propagation models
# -----------------------------
def centroid_position(users):
    return np.mean(users, axis=0)


def weighted_centroid_position(users, weights):
    w = np.array(weights)
    return np.sum(users * w[:, None], axis=0) / np.sum(w)


def fspl_db(distance_m, freq_hz=2.4e9):
    # Free-space path loss in dB (distance in meters)
    if distance_m < 1e-3:
        distance_m = 1e-3
    d_km = distance_m / 1000.0
    f_mhz = freq_hz / 1e6
    return 20.0 * np.log10(d_km) + 20.0 * np.log10(f_mhz) + 32.44


def rx_power_dbm(tx_power_dbm, gain_tx_db, gain_rx_db, distance_m, freq_hz=2.4e9):
    pl = fspl_db(distance_m, freq_hz)
    return tx_power_dbm + gain_tx_db + gain_rx_db - pl


def snr_db_from_rx(rx_dbm, noise_floor_dbm=-100.0):
    return rx_dbm - noise_floor_dbm


def shannon_throughput_mbps(bw_hz, snr_db):
    snr_linear = 10.0 ** (snr_db / 10.0)
    capacity_bps = bw_hz * np.log2(1.0 + snr_linear)
    return capacity_bps / 1e6


# -----------------------------
# Scenario generation
# -----------------------------
def generate_outdoor_users(
    n_users=10, area_center=(0.0, 0.0), area_radius=150.0, seed=1
):
    rng = np.random.RandomState(seed)
    theta = rng.rand(n_users) * 2 * np.pi
    r = area_radius * np.sqrt(rng.rand(n_users))
    xs = area_center[0] + r * np.cos(theta)
    ys = area_center[1] + r * np.sin(theta)
    return np.vstack([xs, ys]).T


def generate_indoor_users(n_users=6, room_size=(12.0, 9.0), seed=2):
    rng = np.random.RandomState(seed)
    xs = rng.rand(n_users) * room_size[0]
    ys = rng.rand(n_users) * room_size[1]
    return np.vstack([xs, ys]).T


# -----------------------------
# Pipeline
# -----------------------------
def run_pipeline(
    n_outdoor=10,
    n_indoor=6,
    room_size=(12, 9),
    area_radius=150,
    building_offset=(50, 30),
):
    outdoor = generate_outdoor_users(
        n_outdoor, area_center=(0, 0), area_radius=area_radius
    )
    indoor = generate_indoor_users(n_indoor, room_size=room_size)
    indoor_world = indoor + np.array(building_offset)
    users = np.vstack([outdoor, indoor_world])
    user_types = ["outdoor"] * len(outdoor) + ["indoor"] * len(indoor_world)

    uav_initial = np.array([0.0, 0.0])
    uav_centroid = centroid_position(users)
    weights = np.array([1.0 if t == "outdoor" else 2.0 for t in user_types])
    uav_weighted = weighted_centroid_position(users, weights)

    tx_power_dbm = 20.0  # 100 mW
    gain_tx_db = 2.0
    gain_rx_db = 2.0
    noise_floor_dbm = -100.0
    bw_hz = 1e6

    records = []
    for i, (pos, utype) in enumerate(zip(users, user_types)):
        d_init = np.linalg.norm(uav_initial - pos)
        d_cent = np.linalg.norm(uav_centroid - pos)
        d_w = np.linalg.norm(uav_weighted - pos)
        rx_init = rx_power_dbm(tx_power_dbm, gain_tx_db, gain_rx_db, d_init)
        rx_cent = rx_power_dbm(tx_power_dbm, gain_tx_db, gain_rx_db, d_cent)
        rx_w = rx_power_dbm(tx_power_dbm, gain_tx_db, gain_rx_db, d_w)
        snr_init = snr_db_from_rx(rx_init, noise_floor_dbm)
        snr_cent = snr_db_from_rx(rx_cent, noise_floor_dbm)
        snr_w = snr_db_from_rx(rx_w, noise_floor_dbm)
        th_init = shannon_throughput_mbps(bw_hz, snr_init)
        th_cent = shannon_throughput_mbps(bw_hz, snr_cent)
        th_w = shannon_throughput_mbps(bw_hz, snr_w)
        records.append(
            {
                "user_id": i,
                "type": utype,
                "x": float(pos[0]),
                "y": float(pos[1]),
                "dist_init_m": float(d_init),
                "dist_centroid_m": float(d_cent),
                "dist_weighted_m": float(d_w),
                "rx_init_dbm": float(rx_init),
                "rx_centroid_dbm": float(rx_cent),
                "rx_weighted_dbm": float(rx_w),
                "snr_init_db": float(snr_init),
                "snr_centroid_db": float(snr_cent),
                "snr_weighted_db": float(snr_w),
                "th_init_mbps": float(th_init),
                "th_centroid_mbps": float(th_cent),
                "th_weighted_mbps": float(th_w),
            }
        )

    df = pd.DataFrame(records)
    meta = {
        "uav_initial": uav_initial.tolist(),
        "uav_centroid": uav_centroid.tolist(),
        "uav_weighted": uav_weighted.tolist(),
        "building_offset": list(building_offset),
    }
    return df, meta, outdoor, indoor_world


# -----------------------------
# Plotting & main
# -----------------------------
def plot_and_save(df, meta, outdoor_pts, indoor_pts, out_dir="outputs"):
    os.makedirs(out_dir, exist_ok=True)
    # Positions
    plt.figure(figsize=(8, 6))
    plt.scatter(outdoor_pts[:, 0], outdoor_pts[:, 1], label="outdoor users")
    plt.scatter(indoor_pts[:, 0], indoor_pts[:, 1], marker="s", label="indoor users")
    plt.scatter(
        meta["uav_initial"][0],
        meta["uav_initial"][1],
        marker="x",
        s=100,
        label="uav initial",
    )
    plt.scatter(
        meta["uav_centroid"][0],
        meta["uav_centroid"][1],
        marker="^",
        s=100,
        label="uav centroid",
    )
    plt.scatter(
        meta["uav_weighted"][0],
        meta["uav_weighted"][1],
        marker="o",
        s=100,
        label="uav weighted",
    )
    plt.xlabel("X (m)")
    plt.ylabel("Y (m)")
    plt.title("User positions and UAV placements")
    plt.legend()
    plt.grid(True)
    pos_path = os.path.join(out_dir, "positions_plot.png")
    plt.savefig(pos_path, bbox_inches="tight")
    plt.close()

    # Throughput bar
    avg_init = df["th_init_mbps"].mean()
    avg_centroid = df["th_centroid_mbps"].mean()
    avg_weighted = df["th_weighted_mbps"].mean()
    plt.figure(figsize=(6, 4))
    plt.bar([0, 1, 2], [avg_init, avg_centroid, avg_weighted])
    plt.xticks([0, 1, 2], ["Initial", "Centroid", "Weighted"])
    plt.ylabel("Avg throughput (Mbps)")
    plt.title("Average throughput per placement strategy")
    plt.grid(axis="y")
    th_path = os.path.join(out_dir, "throughput_plot.png")
    plt.savefig(th_path, bbox_inches="tight")
    plt.close()
    return pos_path, th_path


def main():
    df, meta, outdoor, indoor_world = run_pipeline(
        n_outdoor=12,
        n_indoor=8,
        room_size=(12, 9),
        area_radius=160,
        building_offset=(50, 30),
    )
    print("UAV positions:", meta)
    print(
        "Avg throughputs (Mbps): init={:.2f}, centroid={:.2f}, weighted={:.2f}".format(
            df["th_init_mbps"].mean(),
            df["th_centroid_mbps"].mean(),
            df["th_weighted_mbps"].mean(),
        )
    )
    pos_path, th_path = plot_and_save(
        df, meta, outdoor, indoor_world, out_dir="outputs"
    )
    print("Saved plots:", pos_path, th_path)
    df.to_csv("outputs/uav_link_estimates.csv", index=False)
    print("Saved CSV: outputs/uav_link_estimates.csv")


if __name__ == "__main__":
    main()
