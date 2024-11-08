import onnx
from onnx_tf.backend import prepare
import tensorflow as tf

# Step 1: Load the ONNX model
onnx_model_path = 'C:/Users/kkrit/OneDrive/Desktop/firebaseapp/backend_server/plant.onnx'  # Update this with your ONNX model path
onnx_model = onnx.load(onnx_model_path)

# Step 2: Convert ONNX model to TensorFlow model
tf_rep = prepare(onnx_model)

# Step 3: Save the TensorFlow model (optional, for verification)
tf_model_path = 'backend_server/plant_saved_model'  # Updated path for saved_model format
tf_rep.export_graph(tf_model_path)

# Step 4: Convert the TensorFlow model to TFLite with TF Select enabled
converter = tf.lite.TFLiteConverter.from_saved_model(tf_model_path)
converter.target_spec.supported_ops = [
    tf.lite.OpsSet.TFLITE_BUILTINS,  # Default TFLite operations
    tf.lite.OpsSet.SELECT_TF_OPS     # Enable TF Select for unsupported ops
]

# Step 5: Convert the model
tflite_model = converter.convert()

# Step 6: Save the TFLite model
tflite_model_path = 'backend_server/plant.tflite'  # Update this path as needed
with open(tflite_model_path, 'wb') as f:
    f.write(tflite_model)

print(f'TFLite model saved to: {tflite_model_path}')
