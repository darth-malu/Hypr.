#!/bin/dash

#waybar can call either:
# temp
# fan_speed
# frequency

raw_gpu_temp () {
    #returns millidegree (1000)
    cat /sys/class/drm/card1/device/hwmon/hwmon1/temp1_input 
}

celcius_gpu_temp () {
    local temp

    temp="$(raw_gpu_temp)"
    echo -n "$(( temp/1000 ))"
}

raw_gpu_fan () {
    #returns number eg 700 - rpm
    cat /sys/class/drm/card1/device/hwmon/hwmon1/fan1_input 
}

gpu_busy () {
    cat /sys/class/drm/card1/device/gpu_busy_percent
}

raw_gpu_frequency () {
    #returns number eg 700 - rpm
    # list with current *
    #cat /sys/class/drm/card1/device/pp_dpm_mclk | grep "*"
    grep -oE "\s+[0-9]*.*\*" < /sys/class/drm/card1/device/pp_dpm_sclk | tr -cd "[:alnum:]" 
    #outputs [:digit:]Mhz eg 600Mhz
}

raw_cpu_frequency () {
    local frequency_hz
    local frequency_ghz

    #2cpu , 1gpu, 0- nvme
    frequency_hz="$(cat /sys/class/hwmon/hwmon1/freq1_input)"
    frequency_ghz=$(echo "scale=2; $frequency_hz / 100000000" | bc)

    #outputs raw Ghz eg. just 3.5
    echo -n "$frequency_ghz"
}

raw_nvme_temp () {
    local nvme_temp
    local temp

    #get temp in mC
    nvme_temp="$(cat /sys/class/hwmon/hwmon0/temp1_input)"

    #convert to C
    temp=$(echo "scale=2; $nvme_temp / 1000" | bc)
    #outputs temp .0f
    printf "%.0f\n" "$temp"
}

proc_cpu () {
awk -F': ' '/cpu MHz/ { sum += $2; count++ } END { if (count > 0) printf "%.2f\n", (sum / count) / 1000 }' /proc/cpuinfo
}

device_picker () {
    #set -x
    case $1 in
        "gpu_temp")
            celcius_gpu_temp
            ;;
        "cpu_temp")
            return
            ;;
        "cpu_freq")
            #raw_cpu_frequency
            proc_cpu
            ;;
        "gpu_busy")
            gpu_busy
            ;;
        "gpu_freq")
            raw_gpu_frequency
            ;;
        "gpu_fans")
            raw_gpu_fan
            ;;
        "nvme_temp")
            raw_nvme_temp
            ;;
    esac
}

device_picker "$1"
