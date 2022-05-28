function dct2D = my2D_DCT(inputImage)
%MY2D_DCT Calculates 2D-DCT of image using 1D-DCT

  image = double(inputImage);
  N = length(image);
  A=my1D_DCT(N);
  
  dct2D =A*image*A.';
end

