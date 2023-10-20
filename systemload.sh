#!/bin/bash

# apt install procps
get_cpu_usage() {
    local cpu_usage=$(top -b -n 1 | grep "Cpu(s)" | awk '{print $2}')
    echo $cpu_usage
}

get_memory_usage() {
    local total_memory=$(free -m | awk 'NR==2 {print $2}')
    local used_memory=$(free -m | awk 'NR==2 {print $3}')
    local memory_usage=$(awk "BEGIN {print ($used_memory / $total_memory) * 100}")
    echo $memory_usage
}

calculate_performance_score() {
    local cpu_weight=70  # Adjust the weight for CPU usage.
    local memory_weight=30  # Adjust the weight for memory usage.
    
    local cpu_usage=$(get_cpu_usage)
    local memory_usage=$(get_memory_usage)
    
    local performance_score=$(awk "BEGIN {print (($cpu_usage * $cpu_weight + $memory_usage * $memory_weight) / ($cpu_weight + $memory_weight))}")
    local rounded_score=$(printf "%.0f" "$performance_score")

    echo $rounded_score
}

performance_score=$(calculate_performance_score)
echo $performance_score
