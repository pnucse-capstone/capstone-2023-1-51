import os

import numpy as np
import tensorflow as tf
from keras.models import Model
import cv2


def grad_cam(input_model, image, layer_name):
    # Get the model's prediction for the input image
    prediction = input_model.predict(image)

    # Extract the target layer's output tensor
    target_layer = input_model.get_layer(layer_name)
    gradient_model = Model(inputs=input_model.inputs, outputs=target_layer.output)

    # Calculate the gradient of the predicted class with respect to the target layer's output
    with tf.GradientTape() as tape:
        last_conv_layer_output = gradient_model(image)
        tape.watch(last_conv_layer_output)
        target_class_output = last_conv_layer_output[0, :, :, 0]

    gradients = tape.gradient(target_class_output, last_conv_layer_output)

    # Calculate the global average of the gradients
    pooled_gradients = tf.reduce_mean(gradients, axis=(0, 1, 2))

    # Multiply each channel by the gradient importance and take the mean of the resulting values
    last_conv_layer_output = last_conv_layer_output[0]
    heatmap = tf.reduce_mean(last_conv_layer_output * pooled_gradients, axis=-1)

    # Normalize the heatmap
    heatmap = np.maximum(heatmap, 0) / np.max(heatmap)
    # Resize the heatmap to the input image's dimensions
    heatmap = cv2.resize(heatmap, (image.shape[2], image.shape[1]))
    heatmap_list = heatmap.copy()
    return prediction, heatmap_list


def get_vulnerability_location(image_path, model):
    # Load and preprocess your input image (reshape to (1, height, width, channels))
    input_image = cv2.imread(image_path)
    input_image = cv2.resize(input_image, (10000, 1))
    input_image = input_image / 255.0  # Normalize pixel values

    predict, heatmap_list = grad_cam(model, np.expand_dims(input_image, axis=0),
                                     layer_name='conv2d_10')

    return predict, np.where(heatmap_list == heatmap_list.max())[1]
