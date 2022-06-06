%% Exercise 1 - Filtering at frequency domain
clear,close all;

moon = imread("moon.jpg");



%Transforming into grayscale

gray_moon = rgb2gray(moon);

freq = zeros(256,1);
L = 0:255;

%Cumulative Distribution Function calculation for histogram equalization

[height, width] = size(gray_moon);

%Find frequency of each intensity and pdf
for i = 1:height
    for j = 1:width
        for k = 1:256
            if gray_moon(i,j) == L(k)
                freq(k) = freq(k) + 1;         
            end
        end
    end
end

pdf = freq / (height*width);
%Find cdf
cdf = cumsum(pdf);


%Histogram Equalization
eq_hist = round(cdf * 255);
equalized_image = zeros(height,width);

%Mapping new gray level
for i = 1:height
    for j = 1:width
        equalized_image(i,j) = eq_hist(gray_moon(i,j)+1);
    end
end

%Final image
final_image = uint8(equalized_image);


[final_counts, final_bins] = imhist(final_image);
final_cdf = cumsum(final_counts/(height*width));







f1 = figure("Name","Histogram Equalization");
f1.Position = [100 100 900 900];


subplot(3,2,1);
imshow(moon);
axis on
title("Original Image")

subplot(3,2,2);
imshow(final_image);
axis on
title("Equalized Image")


subplot(3,2,3);
imhist(gray_moon);
title("Histogram of original image")


subplot(3,2,4);
imhist(final_image);
title("Histogram of equalized image")


subplot(3,2,5);
plot((0:255)/255,cdf)
title("CDF of original image")

subplot(3,2,6);
plot((0:255)/255,final_cdf)
title("CDF of final image")






%%
%DFT

%Moving the 0 frequency point at the center with fftshift

shifted_moon = fftshift(final_image);
figure("Name","Shifting the 0,0 point");
imshow(shifted_moon);
axis on
title("Shifted image to 0,0");


% Calculating the 2D-FFT with 1D-FFT of each row first and then each 
% column
FFT_of_moon = fft(fft(shifted_moon,[],1),[],2);

%Plot the 2D-FFT 

figure("Name","Amplitude component of 2D-FFT");
subplot(1,2,1);
imshow(mat2gray(log(1+abs(fftshift(FFT_of_moon)))));
axis on
title("Logarithmic Scale")


subplot(1,2,2);
imshow(mat2gray(abs(fftshift(FFT_of_moon))));
title("Linear Scale")
axis on
sgtitle("Amplitude component of 2D-FFT")



%% Filtering with a Gaussian LPF


% Cut-off Freq
f_cut = 30;

P = round(height/2);
Q = round(width/2);

% Defining the filter kernel
H = zeros(height,width);
for i = 1:height
    for j = 1:width
        D = (i - P).^2 + (j-Q).^2;
        H(i,j) = exp(-D/2/f_cut^2);
    end
end

%Applying the filter

filteredImage = H .* fftshift(FFT_of_moon);


%Applying IDFT
final_image=ifft(ifft(fftshift(filteredImage),[],1),[],2);

%Shifting back
final_image = fftshift(final_image);

figure("Name","Filtering with a Gaussian LPF");

subplot(1,3,1)
imshow(gray_moon);
axis on
title("Original Image");

subplot(1,3,2)
imshow(H);
axis on
title("H(u,v)");

subplot(1,3,3)
imshow(uint8(abs(final_image)));
axis on
title("Filtered Image");
sgtitle("Filtering with a Gaussian LPF");

