#!/system/bin/sh
# Clarity Kernel Tweaks And Parameters

# Allows us to get init-rc-like style
write() { echo "$2" > "$1"; }

# Only apply this when boot is completed
if [[ $(getprop sys.boot_completed) -eq 1 ]]; then

# SchedTune Permissions
for group in background foreground rt top-app; do
         chmod 0644 /dev/stune/$group/*
    done

# CPU Values
write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 0
write /sys/devices/system/cpu/cpufreq/schedutil/up_rate_limit_us 4500
write /sys/devices/system/cpu/cpufreq/schedutil/down_rate_limit_us 200
write /sys/devices/system/cpu/cpufreq/schedutil/iowait_boost_enable 1

# CAF CPU Boost Value
write /sys/module/cpu_boost/parameters/input_boost_freq "0:0"
write /sys/module/cpu_boost/parameters/input_boost_freq "1:0"
write /sys/module/cpu_boost/parameters/input_boost_freq "2:0"
write /sys/module/cpu_boost/parameters/input_boost_freq "3:0"
write /sys/module/cpu_boost/parameters/input_boost_freq "4:0"
write /sys/module/cpu_boost/parameters/input_boost_freq "5:0"
write /sys/module/cpu_boost/parameters/input_boost_freq "6:0"
write /sys/module/cpu_boost/parameters/input_boost_freq "7:0"

# Power Efficient Workqueue
chmod 0644 /sys/module/workqueue/parameters/power_efficient
write /sys/module/workqueue/parameters/power_efficient Y

# GPU Values
write /sys/class/kgsl/kgsl-3d0/devfreq/governor "msm-adreno-tz"
write /sys/class/kgsl/kgsl-3d0/max_gpuclk 650000000
write /sys/class/kgsl/kgsl-3d0/devfreq/max_freq 650000000
write /sys/class/kgsl/kgsl-3d0/devfreq/min_freq 133330000

# Switch to CFQ I/O scheduler
write /sys/block/mmcblk0/queue/scheduler cfq
write /sys/block/mmcblk1/queue/scheduler cfq

# Battery
write /sys/kernel/fast_charge/force_fast_charge 0
write /sys/class/power_supply/battery/allow_hvdcp3 0

# Disable slice_idle on supported block devices
for block in mmcblk0 mmcblk1 dm-0 dm-1 sda; do
    write /sys/block/$block/queue/iosched/slice_idle 0
done

# Set read ahead to 128 kb for internal & 512kb for storage
write /sys/block/mmcblk0/queue/read_ahead_kb 128
write /sys/block/mmcblk1/queue/read_ahead_kb 512

# Low Memory Killer
write /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk 0
write /sys/module/process_reclaim/parameters/enable_process_reclaim 0
write /sys/module/lowmemorykiller/parameters/debug_level 0

# Misc Audio Optimizations
write /sys/module/snd_soc_wcd9330/parameters/high_perf_mode 0
write /sys/module/snd_soc_wcd9335/parameters/huwifi_mode 0
write /sys/module/snd_soc_wcd9335/parameters/low_distort_amp 0
write /sys/module/snd_soc_wcd9xxx/parameters/impedance_detect_en 0

fi
