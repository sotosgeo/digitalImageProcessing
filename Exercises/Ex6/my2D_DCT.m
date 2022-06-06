 function dct2D = my2D_DCT(inputImage)
%MY2D_DCT Calculates 2D-DCT of image using 1D-DCT

  image = double(inputImage);
  N = size(image,1);
  M = size(image,2);
  A=my1D_DCT(N,M);
  
  dct2D =A*image*A.';
end

