%% Image retrieval from database
close all; clear;
unzip("DataBase.zip");
%% Representing Images as Histograms

imgDatabase = imageDatastore("DataBase");
testImages = imageDatastore("test");
histDB = zeros(length(imgDatabase.Files),256);

% Saving image database as image histograms
for i = 1:length(imgDatabase.Files)
    currImg = readimage(imgDatabase,i);

    %Convert to grayscale
    currImg = rgb2gray(currImg);

    %Calculate histogram
    [currCounts,currBins] = imhist(currImg);
    histDB(i,:) = transpose(currCounts);

end

%For each image in the test file, calculate its histogram and
%check if it matches any histograms in the database.
matchedImageIndexPairs = zeros(length(testImages.Files),2);
successes = zeros(1,10);
for testIndex = 1:length(testImages.Files)
    closestDistance = Inf;
    currImg = readimage(testImages,testIndex);

    %Convert to grayscale
    currImg = rgb2gray(currImg);


    %Calculate histogram
    [currCounts,currBins] = imhist(currImg);
    %For each histogram in the database, find the closest ones index
    
    for dBIndex = 1:size(histDB,1)
        %Calculate difference between histogram counts using immse with
        %MSE as the metric
        currentDistance = immse(histDB(dBIndex,:),transpose(currCounts));
        if (currentDistance < closestDistance)
            closestDistance = currentDistance;
            matchedImageIndexPairs(testIndex,:) = [testIndex dBIndex];
        end
    end

    %Check if retrieval was successful
   
    [testImg,~] = readimage(testImages,testIndex);
    [retrievedImg,~] = readimage(imgDatabase,matchedImageIndexPairs(testIndex,2));
    successes(testIndex) = isequal(testImg,retrievedImg);
end

%Plotting test images and retrieved images
succPercentage = sum(successes) / length(successes);
f3 = figure;
for i = 1:10
    [testImg,~] = readimage(testImages,i);
    [retrievedImg,~] = readimage(imgDatabase,matchedImageIndexPairs(i,2));
    subplot(10,1,i), imshowpair(testImg,retrievedImg,'montage')
end
sgtitle("Test Image - Retrieved Image using histogram");
%% Representing Images using DCT

dctDB_r_0_1 = zeros(length(imgDatabase.Files),100,100); % 10 % of coefficients kept
dctDB_r_0_5 = zeros(length(imgDatabase.Files),100,100); % 50 % of coefficients kept
dctDB_r_0_0 = zeros(length(imgDatabase.Files),100,100); % all coefficients kept

windowSize = [32 32];
r_values = [0.1 0.5 0];

% Saving image database as dct transforms
for dBIndex = 1:length(imgDatabase.Files)

    %Current Image
    currImg = readimage(imgDatabase,dBIndex);
    currImg = rgb2gray(currImg);
    
    %Implementing 2D-DCT with 1D-DCT 
    for r = r_values
        Q = dct(double(currImg),[],1);
        R = dct(Q,[],2);
        X = R(:);
        
        %Keeping only values above the threshhold
        current_threshold = sum(abs(X)) / (size(currImg,1) * size(currImg,2)) * ((1 - r)/0.5);
        R(abs(R) < current_threshold) = 0;
   
        if (r == 0.1)
            dctDB_r_0_1(dBIndex,:,:) = R;
        
        elseif (r == 0.5)
            dctDB_r_0_5(dBIndex,:,:) = R;
        
        else 
            dctDB_r_0_0(dBIndex,:,:) = R;
        end
    end

end


% For each test image, find its DCT transform with different coefficient
% percentage and try to find its match in the database
matchedImageIndexPairs_r_0_1 = zeros(length(testImages.Files),2);
matchedImageIndexPairs_r_0_5 = zeros(length(testImages.Files),2);
matchedImageIndexPairs_r_0_0 = zeros(length(testImages.Files),2);

successesDCT_r_0_1 = zeros(1,10);
successesDCT_r_0_5 = zeros(1,10);
successesDCT_r_0_0 = zeros(1,10);

testImageDCT_r_0_1 = zeros(100,100);
testImageDCT_r_0_5 = zeros(100,100);
testImageDCT_r_0_0 = zeros(100,100);

for testIndex = 1:length(testImages.Files)
    %For each image in the test database
    currImg = readimage(testImages,testIndex);

    %Convert to grayscale
    currImg = rgb2gray(currImg);

    %Find DCT for different r_values
    for r = r_values
        Q = dct(double(currImg),[],1);
        R = dct(Q,[],2);
        X = R(:);
        
        %Keeping only values above the threshhold
        current_threshold = sum(abs(X)) / (size(currImg,1) * size(currImg,2)) * ((1 - r)/0.5);
        R(abs(R) < current_threshold) = 0;
        if (r == 0.1)
           testImageDCT_r_0_1 = R;
        
        elseif (r == 0.5)
           testImageDCT_r_0_5 = R;
        
        else 
           testImageDCT_r_0_0 = R;
        end
    end

    %After we have calculated the DCT for different r, parse the img database
    %and find the closest match for each test image
    closestDistance_0_1 = Inf;
    closestDistance_0_5 = Inf;
    closestDistance_0_0 = Inf;
    for dBIndex = 1:length(imgDatabase.Files)
        
        %First for r = 0.1
        currentDistance = immse(testImageDCT_r_0_1,squeeze(dctDB_r_0_1(dBIndex,:,:)));
        if (currentDistance < closestDistance_0_1)
            closestDistance_0_1 = currentDistance;
            matchedImageIndexPairs_r_0_1(testIndex,:) = [testIndex dBIndex];
        end

        %Then for r = 0.5
        currentDistance = immse(testImageDCT_r_0_5,squeeze(dctDB_r_0_5(dBIndex,:,:)));
        if (currentDistance < closestDistance_0_5)
            closestDistance_0_5 = currentDistance;
            matchedImageIndexPairs_r_0_5(testIndex,:) = [testIndex dBIndex];
        end


        %Finally r = 0 (100% of coeffs kept
        currentDistance = immse(testImageDCT_r_0_0,squeeze(dctDB_r_0_0(dBIndex,:,:)));
        if (currentDistance < closestDistance_0_0)
            closestDistance_0_0 = currentDistance;
            matchedImageIndexPairs_r_0_0(testIndex,:) = [testIndex dBIndex];
        end
    end  
end


%Find success percentage for each r
for i = 1:10
    [testImg,~] = readimage(testImages,i);


    %r = 0.1
    [retrievedImg1,~] = readimage(imgDatabase,matchedImageIndexPairs_r_0_1(i,2));
    successesDCT_r_0_1(i) = isequal(testImg,retrievedImg1);


    %r = 0.5
    [retrievedImg2,~] = readimage(imgDatabase,matchedImageIndexPairs_r_0_5(i,2));
    successesDCT_r_0_5(i) = isequal(testImg,retrievedImg2);

    %r = 0 (100% coeffs)
    [retrievedImg3,~] = readimage(imgDatabase,matchedImageIndexPairs_r_0_0(i,2));
    successesDCT_r_0_0(i) = isequal(testImg,retrievedImg3);
    
    
    
    
end

f4 = figure;
for i = 1:10
    [testImg,~] = readimage(testImages,i);
    [retrievedImg,~] = readimage(imgDatabase,matchedImageIndexPairs_r_0_1(i,2));
    subplot(10,1,i), imshowpair(testImg,retrievedImg,'montage')
end
sgtitle("Test Image - Retrieved Image using DCT - 10% of coeffs");

f5 = figure;
for i = 1:10
    [testImg,~] = readimage(testImages,i);
    [retrievedImg,~] = readimage(imgDatabase,matchedImageIndexPairs_r_0_5(i,2));
    subplot(10,1,i), imshowpair(testImg,retrievedImg,'montage')
end
sgtitle("Test Image - Retrieved Image using DCT - 50% of coeffs");

f6 = figure;
for i = 1:10
    [testImg,~] = readimage(testImages,i);
    [retrievedImg,~] = readimage(imgDatabase,matchedImageIndexPairs_r_0_0(i,2));
    subplot(10,1,i), imshowpair(testImg,retrievedImg,'montage')
end
sgtitle("Test Image - Retrieved Image using DCT - 100% of coeffs");