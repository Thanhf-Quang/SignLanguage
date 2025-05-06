from pose_extractor import extract_poses_from_video, extract_poses_from_gif
from pose_comparator import compare_poses

def process_and_compare(video_path, gif_url):
    """
    Nhận vào video và GIF mẫu, trích xuất pose và tính điểm tương đồng.
    """
    print(f"[INFO] Extracting poses from video: {video_path}")
    user_poses = extract_poses_from_video(video_path)

    print(f"[INFO] Extracting poses from gif: {gif_url}")
    reference_poses = extract_poses_from_gif(gif_url)

    print(f"[INFO] Comparing poses...")
    score = compare_poses(user_poses, reference_poses)

    print(f"[RESULT] Similarity score: {score:.2f}")
    return score
