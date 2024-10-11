import re
import math

section_pattern = re.compile(r'^(\d+)cpu time: \d+ real time: (\d+)')
entries = {}

with open('swindle.txt', 'r') as file:
    for line in file:
        match = section_pattern.search(line)
        if match:
            iters = int(match.group(1))
            real_time = int(match.group(2))

            if iters not in entries:
                entries[iters] = []

            entries[iters].append(real_time)

def calculate_average(times):
    return sum(times) / len(times) if times else 0

def calculate_std_dev(times, avg):
    variance = sum((x - avg) ** 2 for x in times) / len(times)
    return math.sqrt(variance)

print("swindle_results = [")
for iters, real_times in entries.items():
    avg_real_time = calculate_average(real_times)
    std_dev_real_time = calculate_std_dev(real_times, avg_real_time)

    print(f'({avg_real_time}, {std_dev_real_time}),')
print("]")
