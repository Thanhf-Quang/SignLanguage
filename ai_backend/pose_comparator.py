from utils import calculate_pose_distance

def compare_poses(user_poses, ref_poses):
    if not user_poses or not ref_poses:
        return 0.0

    total_distance = 0
    count = min(len(user_poses), len(ref_poses))

    for i in range(count):
        total_distance += calculate_pose_distance(user_poses[i], ref_poses[i])

    avg_distance = total_distance / count
    score = max(0.0, 1.0 - avg_distance)
    return round(score, 2)