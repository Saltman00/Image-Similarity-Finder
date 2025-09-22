# Image Similarity Finder

## Overview

The **Image Similarity Finder** is a MATLAB application that allows users to find similar images from a database based on selected similarity metrics, such as Cosine Similarity, Euclidean Distance, and Manhattan Distance. The application uses a pre-trained GoogLeNet deep learning model to extract image features and compares these features to the ones stored in a database.

## Features

- **Image Selection**: Users can select an image from their file system.
- **Similarity Metrics**: The app supports three similarity metrics:
  - **Cosine Similarity**: Measures the cosine of the angle between the feature vectors.
  - **Euclidean Distance**: Measures the "straight line" distance between feature vectors.
  - **Manhattan Distance**: Measures the sum of absolute differences between feature vectors.
- **Top 4 Similar Images**: The app returns and displays the top 4 most similar images from the database, excluding the selected image.
- **Deep Learning**: Uses the GoogLeNet pre-trained model to extract image features.
- **Real-Time Visual Feedback**: Displays the selected image, its class, and the most similar images with their classes.

## Requirements

- **MATLAB**: Ensure that MATLAB is installed with necessary toolboxes.
- **GoogLeNet**: This app utilizes the GoogLeNet model, which is available in the MATLAB Deep Learning Toolbox.
- **MATLAB UI**: This app uses MATLAB's `uifigure`, `uibutton`, and other UI components.

## Setup

1. Download or clone this repository to your local machine.
2. Ensure that your MATLAB environment has the required toolboxes, especially the Deep Learning Toolbox.
3. Make sure you have a folder containing the images you want to compare. This project assumes that you have a folder of landscape images for the database.
4. Run the script to load the database and display the UI.

### Load Database

You can load your image database using the `imageDatastore` function as follows:

```matlab
LandFolder = 'C:\path\to\your\images';  % Set path to your image folder
LandFiles = imageDatastore(LandFolder, 'FileExtensions', {'.jpg', '.png'});
auds = augmentedImageDatastore(inputSize, LandFiles, "ColorPreprocessing", "gray2rgb");
databaseFeatures = activations(net, auds, featureLayer, 'OutputAs', 'rows');
save('databaseFeatures.mat', 'databaseFeatures', 'LandFiles');

This will load your images, process them using GoogLeNet, and save the features for later use in databaseFeatures.mat.

Usage

Run the image_similarity_app.m script to launch the GUI.

Select an Image: Click the "Select Image" button to choose an image from your file system.

Choose a Similarity Metric: After selecting an image, choose one of the similarity metrics (Cosine, Euclidean, or Manhattan) to find the most similar images from the database.

View Results: The app will display the top 4 most similar images based on the selected metric, along with their classes.

Files

image_similarity_app.m: Main script for the GUI application.

databaseFeatures.mat: Contains the pre-computed feature vectors for the image database.

databaseFeatures.m: Script to load and preprocess the image database.

Assets/: Folder containing the screenshots and other assets used by the app.

License

This project is licensed under the MIT License - see the LICENSE
 file for details.

Acknowledgments

This project uses the GoogLeNet
 pre-trained model available in MATLAB.

Thanks to the developers of MATLAB and the Deep Learning Toolbox for providing powerful tools to implement this project.