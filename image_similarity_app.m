function image_similarity_app()
    clc
    close
    net = googlenet;
    featureLayer = 'pool5-7x7_s1';
    inputSize = net.Layers(1).InputSize(1:2);%set my deeplearning model and get its input size for images
    data=load("databaseFeatures.mat","databaseFeatures","LandFiles");%get my vetctors from mat file for faster app
    databaseFeatures=data.databaseFeatures;
    LandFiles=data.LandFiles;

    monsize=get(0,'ScreenSize');%got my monitor size for accurate figure size
    figx=monsize(3)*3/4;
    figy=monsize(4)*3/4;

    %set all my visiual buttons/labels/titles/images
    fig = uifigure('Name', 'Image Similarity Finder', 'Position', [200 150 figx figy]);
    uilabel(fig, 'Text', 'Image Similarity Finder', ...
        'FontSize', 18, 'HorizontalAlignment', 'center', ...
        'Position', [figx/2-150 figy-40 300 50]);

    uibutton(fig, 'Text', 'Select Image', ...
        'Position', [200 150 200 75],'Fontsize',20, 'ButtonPushedFcn', @(btn, event) selectImage());

    uilabel(fig, 'Text', 'Selected Image:', ...
        'FontSize', 20, 'Position', [200 510 240 30]);
    class1=uilabel(fig, "Text", sprintf("Class:"), ...
            "Position",[200 20 200 60] , "FontSize", 18);%set the class blank for a new image

    selectedImageUI = uiimage(fig, 'Position', [200 250 250 250]);

    uibutton(fig, 'Text', 'Cosine Sim', ...
        'Position', [540 95 160 30],'FontSize',17,'ButtonPushedFcn', @(btn, event) showSimilarImages('cosine')); 
    uibutton(fig, 'Text', 'Euclid Sim', ...
        'Position', [540 65 160 30],'FontSize',17,'ButtonPushedFcn', @(btn, event) showSimilarImages('euclid'));
    uibutton(fig, 'Text', 'Manhattan Sim', ...
        'Position', [540 35 160 30],'FontSize',17,'ButtonPushedFcn', @(btn, event) showSimilarImages('manhattan'));
        
    for i = 1:4
        resultImages(i) = uiimage(fig, 'Position', [500 (figy-150 - (i-1)*120) 200 110]); 
    end

    selectedImagePath='';
    

    function selectImage()% defined my func
        [file, path] = uigetfile({'*.jpeg;*.jpg;*.png', 'Images (*.jpeg, *.jpg, *.png)'});
        
        if isequal(file, 0)%check if the file is empty
            return;  
        end
        
        selectedImagePath = imread([path file]);%reads the file path
        selectedImageUI.ImageSource = selectedImagePath;  % shows the selected image
        class1.Text="Class:";
    end
    
    function showSimilarImages(sim)%defined my func
        if isempty(selectedImagePath)%checked if it is empty
            uialert(fig, 'Please select an image first!', 'Error');
            return;
        end

        % getting the attributes/vectors for selected image
        resizedSelected = imresize(selectedImagePath, inputSize);
        selectedclass=classify(net,resizedSelected);
        selectedFeature = activations(net, resizedSelected, featureLayer, 'OutputAs', 'rows');        
        % using the method for image similarity
        photoNumber = length(LandFiles.Files);
        Similarities = zeros(photoNumber, 1);
        if strcmp(sim,'cosine')
            for n = 1:photoNumber
                %calculated cosine similarity
                Similarities(n) = dot(selectedFeature, databaseFeatures(n,:)) / ...
                    (norm(selectedFeature) * norm(databaseFeatures(n, :)));
            end
            [~, sortedIndices] = sort(Similarities, 'descend');
            top4Indices = sortedIndices(2:5);%started from 2 because first one will be the same photo
        end
        if strcmp(sim, 'euclid')
            %calculting euclid distance
            for n = 1:photoNumber
                Similarities(n) = sqrt(sum((selectedFeature - databaseFeatures(n,:)).^2));
            end
            [~, sortedIndices] = sort(Similarities, 'ascend');
            top4Indices = sortedIndices(2:5);
        end

        if strcmp(sim, 'manhattan')
            for n = 1:photoNumber
                % Calculating manhattan distance
                Similarities(n) = sum(abs(selectedFeature - databaseFeatures(n,:)));
            end

            % En küçük Manhattan mesafelerine göre sıralama
            [~, sortedIndices] = sort(Similarities, 'ascend');
            top4Indices = sortedIndices(2:5); % En küçük 4 mesafeyi al
        end

        %showing the four of the most similar images and their classes for
        %extra information
        similarclasses=strings(1,4);
        for j = 1:4
            mostSimilarImagePath = LandFiles.Files{top4Indices(j)};
            mostSimilarImage=imread(mostSimilarImagePath);
            resizedmostsimilarImage=imresize(mostSimilarImage,[224 224]);
            similarclasses(j)=classify(net,resizedmostsimilarImage);
            resultImages(j).ImageSource = mostSimilarImage;  % Görselleri ekrana koy
            
            uilabel(fig, "Text", sprintf("Class %d: %s", j, (similarclasses(j))), ...
            "Position",[800 (figy-150 - (j-1)*120) 200 70] , "FontSize", 18);    
        end
        %shows the class of the selected image
        class1.Text=sprintf("Class:%s",selectedclass);

    end
end
