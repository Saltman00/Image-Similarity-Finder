net = googlenet;
featureLayer = 'pool5-7x7_s1';
inputSize = net.Layers(1).InputSize(1:2);
    
LandFolder = 'C:\Users\ahepg\OneDrive\Masaüstü\projecg\land\landscape Images\color';
LandFiles = imageDatastore(LandFolder, 'FileExtensions', {'.jpg'});
auds = augmentedImageDatastore(inputSize, LandFiles, "ColorPreprocessing", "gray2rgb");
databaseFeatures = activations(net, auds, featureLayer, 'OutputAs', 'rows');
    

save('databaseFeatures.mat', 'databaseFeatures', 'LandFiles');
disp('Database features saved to databaseFeatures.mat');

