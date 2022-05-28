function idct2D = my2D_IDCT(inputImage)
%MY2D_IDCT 

  image = double(inputImage);
  N = length(image);
  A=my1D_DCT(N);
  
  idct2D =A\image/A.';
end

