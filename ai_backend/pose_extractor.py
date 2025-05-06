import cv2
import mediapipe as mp
import imageio

mp_pose = mp.solutions.pose
pose_estimator = mp_pose.Pose(static_image_mode=False, min_detection_confidence=0.5)

def extract_poses_from_video(video_path):
    cap = cv2.VideoCapture(video_path)
    poses = []

    while cap.isOpened():
        ret, frame = cap.read()
        if not ret:
            break

        rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        results = pose_estimator.process(rgb)

        if results.pose_landmarks:
            landmarks = [(lm.x, lm.y) for lm in results.pose_landmarks.landmark]
            poses.append(landmarks)

    cap.release()
    return poses

def extract_poses_from_gif(gif_url):
    gif = imageio.mimread(gif_url)
    poses = []

    for frame in gif:
        bgr = cv2.cvtColor(frame, cv2.COLOR_RGB2BGR)
        rgb = cv2.cvtColor(bgr, cv2.COLOR_BGR2RGB)
        results = pose_estimator.process(rgb)

        if results.pose_landmarks:
            landmarks = [(lm.x, lm.y) for lm in results.pose_landmarks.landmark]
            poses.append(landmarks)

    return poses
