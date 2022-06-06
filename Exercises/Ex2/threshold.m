function outputBlock = threshold(r,inputBlock)
%THRESHOLD Summary of this function goes here
%   Detailed explanation goes here
    current_threshold = sum(sum(abs(inputBlock))) / (size(inputBlock,1) * size(inputBlock,2)) * ((1 - r)/0.5);
    inputBlock(abs(inputBlock) < current_threshold) = 0;
    outputBlock = inputBlock;

end

