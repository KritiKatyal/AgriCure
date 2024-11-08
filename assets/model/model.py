# Importing required libraries and setting environment
import os
os.environ['KMP_DUPLICATE_LIB_OK'] = 'TRUE'
from ultralytics import YOLO
import matplotlib.pyplot as plt

# Load YOLOv8 model (change path if using a custom model)
model = YOLO("C:\\Users\\kkrit\\OneDrive\\Documents\\flutter\\agri_cure\\assets\\model\\yolov8n.pt")

# Predicting on a new image
def predict(image_path):
    # Run prediction using the YOLOv8 model
    results = model.predict(source=image_path, save=True)

    # Extract prediction details
    # Extract prediction details
    predictions = []
    for result in results:
            boxes = result.boxes.xyxy.tolist()  # Bounding boxes
            scores = result.boxes.conf.tolist()   # Confidence scores
            classes = result.names                 # Class names
            
            print(f"Boxes: {boxes}")
            print(f"Scores: {scores}")
            
            for box, score in zip(boxes, scores):
                print(f"Box: {box}, Score: {score}")
                if score > 0.3:  # Adjust threshold as necessary
                    if len(box) > 5:  # Ensure there are enough elements
                        predictions.append({
                            'bbox': box[:4],  # Only include the bounding box coordinates
                            'confidence': score,
                            'class': classes[int(box[5])] if len(classes) > int(box[5]) else "Unknown"  # Safe access
                        })

    return predictions


# Example usage:
image_path = "C:\\Users\\kkrit\\OneDrive\\Documents\\flutter\\agri_cure\\assets\\images\\leaf1.jpeg"
predictions = predict(image_path)
print(predictions)
