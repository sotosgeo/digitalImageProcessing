%% Exercise 4 - Shape Description

leaf = imread("leaf.jpg");

%convert leaf to grayscale
I = rgb2gray(leaf);

%B = fourierShapeDescriptor(imread("BinaryBall.tif"),100);
binarized_leaf = imbinarize(I);
imshowpair(I,binarized_leaf,'montage')

%Find boundaries
Bound_leaf = bwboundaries(binarized_leaf);



[B,L] = bwboundaries(binarized_leaf,'noholes');
imshow(label2rgb(L, @jet, [.5 .5 .5]))
hold on
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'w', 'LineWidth', 2)
end