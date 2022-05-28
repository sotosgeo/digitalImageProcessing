function dct_1d= my1D_DCT(inputMatrix)
%MYDCT Calculates 1D-DCT of matrix
    N = size(inputMatrix);
    c(1:N,1) = sqrt(2/N);
    c(1) = c(1) / sqrt(2);
    range = (0:N-1);
    dct_1d = c.*cos(range(:)*pi(2*range+1)/(2*N));

end

