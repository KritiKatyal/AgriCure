# AgriCure
# Plant Disease Detection App

## Overview

This repository contains the code and resources for an Android application designed to detect plant diseases using a multi-layered approach powered by YOLOv8. The application leverages three machine learning models to ensure accurate and efficient image processing:

1. **General Object Rejection Model:** Filters out images containing non-plant objects, such as humans, vehicles, or other unrelated elements.
2. **Plant Detection Model:** Identifies whether the input image contains a plant or if it is an invalid test case, such as a green screen or an unrelated object.
3. **Precision Plant Validation Model:** Confirms the presence of a plant and ensures that only high-confidence images (precision above 75%) proceed to disease detection.

The final output identifies plant diseases, aiding farmers in diagnosing issues efficiently.

---

## Key Features

- **Multi-layered Validation:** Ensures only relevant plant images are processed, improving accuracy.
- **Disease Detection:** Provides disease insights for the validated plant images.
- **Efficient Implementation:** Optimized using YOLOv8 for real-time performance.
- **Cross-Platform Compatibility:** Available as a lightweight Android application for use in resource-constrained environments.

---

## Technologies Used

- **YOLOv8:** Advanced object detection model for high precision and speed.
- **Programming Languages:**
  - Dart (64.3%)
  - C++ (15.2%)
  - CMake (11.9%)
  - Python (5.2%)
  - Swift (1.6%)
  - C (0.9%)
  - Other (0.9%)

---

## Dataset

The app is based on two different reserach datasets involving bitter gourd and tomato leaves.

Details of Tomato leaves dataset: 
- Nutrient Deficiencies: Potassium(K), Nitrogen(N), and Nitrogen-Potassium(N_K) 
- Healthy leaves for reference

Initial dataset: 356 images,
Augmented dataset: 2,025 images

Details of Bitter gourd leaves dataset:
- Diseases: Downy Mildew, Leaf Spot, Jassid
- Nutrient Deficiencies: Potassium(K), Magnesium(Mg), Nitrogen(N), and their combinations(K mg, N mg, N k)
- Healthy leaves for reference

Initial dataset: 947 images,
Augmented dataset: 2,430 images

---

## Model Architecture

### General Object Rejection Model
- Filters out non-plant objects.
- Ensures the pipeline processes only images with potential plant content.

### Plant Detection Model
- Detects plants while rejecting unrelated objects or test cases (e.g., green screens).
- Acts as a secondary filter for enhanced validation.

### Precision Plant Validation Model
- Validates plant images passing prior tests.
- Applies a strict precision threshold (>75%) to eliminate low-confidence cases.

### Disease Detection Model
- Identifies diseases in the final validated plant images.
- Leverages YOLOv8 for high accuracy and low false positives.

---

## Performance Metrics
Tomato results:
- **Mean Average Precision (mAP):** 92.7% at IoU=0.50
- **Precision:** 89.1%
- **Recall:** 83.1%
- **F1 Score:** 89.5%

Bitter gourd results:
- **Mean Average Precision (mAP):** 92.9% at IoU=0.50
- **Precision:** 89.6%
- **Recall:** 86.6%
- **F1 Score:** 91.66%

---

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/KritiKatyal/AgriCure.git
   ```
2. Install dependencies as specified in the `pubspec.yaml` file.
3. Build the Android application using the provided source code.

---

## Usage

1. Launch the application on your Android device.
2. Upload an image through the interface.
3. Receive results:
   - If non-plant content is detected, the image is rejected.
   - If the image passes all layers, the app provides disease analysis.

---

## Requirements
The application is built with a minimum SDK version of 23, which corresponds to Android 6.0 (Marshmallow) and above. Therefore, the minimum specifications to run the app are:

OS version: Android 6.0 or higher

CPU: ARM-based processor (32-bit or 64-bit), ~1 GHz or above

RAM: Minimum 2 GB (4 GB recommended for smoother performance)

Storage: At least 8 GB internal storage (16 GB recommended)

Display: 3.5–4.0 inch screen or larger, minimum 480×800 px resolution

Supported Architectures: armeabi-v7a, arm64-v8a, x86

## Contributing

We welcome contributions! Please create a pull request or open an issue for any suggestions or bug reports.

---

## Contact

For queries, reach out to the developers:
- Kriti Katyal: kritikatyal06@gmail.com
- Sumit Kumar: sumitkumar59378@gmail.com / nehra59378@gmail.com
- Varun Kumar: varunkumar5257@gmail.com

---

## Acknowledgments
This application is based on the following researches:

- **Research Paper:** "A hybrid approach of nutrition deficiency detection in the tomato leaf using the yolov8 deep learning model and a layered augmentation scheme"
- **Research Paper:** "Layered Augmentation-Enhanced YOLOv8 for Disease and Nutrient Deficiency Detection in Bitter Gourd Leaves."
---

## License



