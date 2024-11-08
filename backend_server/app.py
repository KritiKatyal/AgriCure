import os
from flask import Flask, request, jsonify, url_for
from ultralytics import YOLO
from PIL import Image, ImageDraw
from inference_sdk import InferenceHTTPClient
from flask_cors import CORS

# Initialize the Flask app
app = Flask(__name__)
CORS(app)  # Allow cross-origin requests

# Models for plant detection and disease classification
plant_detection_model = YOLO("plant.pt")
bittergourd_model = YOLO("bittergourd.pt")  # Bittergourd disease detection
tomato_model = YOLO("tomato.pt")            # Tomato disease detection

# API Client for non-plant image detection (keep the key secret in production)
CLIENT = InferenceHTTPClient(
    api_url="https://detect.roboflow.com",
    api_key=os.getenv("ROBOFLOW_API_KEY", "dttS8LABTLUaOCBCO2Ch")  # Use env var for security
)

# Bitter Gourd categories
bitter_gourd_diseases = {
    'DM': 'Downy Mildew (Disease)',
    'LS': 'Leaf Spot (Disease)',
    'JAS': 'Jassid (Insect)',
    'K': 'Potassium Deficiency (Nutritional)',
    'K Mg': 'Potassium and Magnesium Deficiency (Nutritional)',
    'N': 'Nitrogen Deficiency (Nutritional)',
    'N K': 'Nitrogen and Potassium Deficiency (Nutritional)',
    'N Mg': 'Nitrogen and Magnesium Deficiency (Nutritional)',
    'Healthy': 'Healthy'
}

# Tomato categories
tomato_diseases = {
    'LM': 'Leaf Miner (Insect)',
    'MIT': 'Mite (Insect)',
    'JAS MIT': 'Jassid and Mite (Insect)',
    'K': 'Potassium Deficiency (Nutritional)',
    'N': 'Nitrogen Deficiency (Nutritional)',
    'N K': 'Nitrogen and Potassium Deficiency (Nutritional)',
    'Healthy': 'Healthy'
}

# Predict route for Bittergourd or Tomato plants
@app.route('/predict/<plant>', methods=['POST'])
def predict(plant):
    if 'file' not in request.files:
        return jsonify({'error': 'No file uploaded'}), 400
    
    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': 'No selected file'}), 400

    try:
        uploads_dir = os.path.join("static", "uploads")
        os.makedirs(uploads_dir, exist_ok=True)

        img = Image.open(file)
        img_path = os.path.join(uploads_dir, file.filename)
        img.save(img_path)

        ### Step 1: Use the InferenceHTTPClient API to check if the image is a plant ###
        # try:
        #     result = CLIENT.infer(img_path, model_id="obstacle-detection-yeuzf/5")
        #     api_predictions = result.get('predictions', [])

        #     if not api_predictions:
        #         print("No predictions from the API. Proceeding with plant detection.")
        #     else:
        #         api_class = api_predictions[0].get('class', '')
        #         if api_class not in ['tree', 'leaf', 'plant']:
        #             return jsonify({
        #                 'error': f"The image contains a {api_class}. This app works only for plant images."
        #             }), 400
            
        # except Exception as api_error:
        #     # Log API error and continue with disease detection
        #     print(f"API Error: {api_error}. Proceeding with plant detection.")

        ### Step 2: Proceed with plant disease detection models ###
        if plant == 'bittergourd':
            detection_model = bittergourd_model
            plant_diseases = bitter_gourd_diseases
            confidence_threshold = 0.90  # Higher confidence for Bitter Gourd
        elif plant == 'tomato':
            detection_model = tomato_model
            plant_diseases = tomato_diseases
            confidence_threshold = 0.70 # Lower confidence for Tomato
        else:
            return jsonify({'error': 'Invalid plant selection'}), 400

        # Run the model predictions
        results = detection_model.predict(source=img)
        predictions = []
        draw = ImageDraw.Draw(img)

        has_valid_prediction = False

        # Log the raw results
        # print(f"Raw results: {results}")  # Debug log



        for result in results:
            for box in result.boxes:
                class_name = result.names[box.cls[0].item()]
                confidence = round(box.conf[0].item(), 2)
                bbox = [round(coord, 2) for coord in box.xyxy[0].tolist()]

                # Log the individual predictions
                print(f"Detected: {class_name}, Confidence: {confidence}, BBox: {bbox}")  # Debug log

                if confidence >= confidence_threshold:
                    predictions.append({
                        'class': class_name,
                        'confidence': confidence,
                        'box': bbox
                    })
                    has_valid_prediction = True

                    # Draw the bounding box on the image
                    draw.rectangle(bbox, outline="red", width=3)
                    draw.text((bbox[0], bbox[1]), f"{class_name} {confidence}", fill="red")



        # Log predictions before returning
        print(f"Predictions: {predictions}")  # Log predictions for debugging


        # Save the result image with bounding boxes
        img_filename = f"detected_{file.filename}"
        img_path = os.path.join(uploads_dir, img_filename)
        img.save(img_path)

        if has_valid_prediction:
            return jsonify({
                'predictions': predictions,
                'image_url': url_for('static', filename=f"uploads/{img_filename}", _external=True),
                'message': "Predictions successful."
    })
        else:
            return jsonify({'predictions': [], 'message': "No valid predictions found."})

    except Exception as e:
        return jsonify({'error': f"Error processing image: {str(e)}"}), 500

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=True)
