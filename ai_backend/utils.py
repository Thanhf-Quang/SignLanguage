import math

def calculate_pose_distance(pose1, pose2):
    if len(pose1) != len(pose2):
        return 1.0

    total = 0
    for (x1, y1), (x2, y2) in zip(pose1, pose2):
        total += math.sqrt((x1 - x2)**2 + (y1 - y2)**2)

    return total / len(pose1)