from flask import Flask, request, jsonify
import cv2
import mediapipe as mp
import numpy as np
import pickle
import os
from analyze_video import process_and_compare

app = Flask(__name__)

model_dict = pickle.load(open('./model.p', 'rb'))
model = model_dict['model']
labels_dict = {0: 'A', 1: 'B', 2: 'C', 3: 'D', 4: 'E', 5: 'F', 6: 'G', 7: 'H', 8: 'I', 9: 'J', 10: 'K', 11: 'L', 12: 'M', 13: 'N', 14: 'O', 15: 'P', 16: 'Q', 17: 'R', 18: 'S', 19: 'T', 20: 'U', 21: 'V', 22: 'W', 23: 'X', 24: 'Y', 25: 'Z', 26: 'Space'}

# MediaPipe
mp_hands = mp.solutions.hands
hands = mp_hands.Hands(static_image_mode=True, min_detection_confidence=0.3)

@app.route('/predict', methods=['POST'])
def predict():
    if 'image' not in request.files:
        return jsonify({'error': 'Không có hình ảnh nào'}), 400

    file = request.files['image']
    img_array = np.frombuffer(file.read(), np.uint8)
    frame = cv2.imdecode(img_array, cv2.IMREAD_COLOR)

    H, W, _ = frame.shape
    frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    results = hands.process(frame_rgb)

    if results.multi_hand_landmarks:
        hand_landmarks = results.multi_hand_landmarks[0]

        data_aux, x_, y_ = [], [], []

        for lm in hand_landmarks.landmark:
            x_.append(lm.x)
            y_.append(lm.y)

        for lm in hand_landmarks.landmark:
            data_aux.append(lm.x - min(x_))
            data_aux.append(lm.y - min(y_))

        prediction = model.predict([np.asarray(data_aux)])
        predicted_character = labels_dict[int(prediction[0])]

        return jsonify(predicted_character)

    return jsonify("No hand detection!"), 200  # Trả về chuỗi rỗng nếu không nhận diện được

@app.route('/analyze', methods=['POST'])
def analyze():
    if 'video' not in request.files or 'gif_url' not in request.form:
        return jsonify({'error': 'Missing data'}), 400

    video = request.files['video']
    gif_url = request.form['gif_url']

    # Tạo thư mục temp nếu chưa có
    os.makedirs('temp', exist_ok=True)

    save_path = os.path.join("temp", video.filename)
    video.save(save_path)

    # Gọi hàm xử lý AI
    score = process_and_compare(save_path, gif_url)

    return jsonify({'score': round(score, 2)})

if __name__ == '__main__':
    app.run(host="0.0.0.0", port=5000, debug=True)
