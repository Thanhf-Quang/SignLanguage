from flask import Flask, request, jsonify
import os
from analyze_video import process_and_compare

app = Flask(__name__)

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
