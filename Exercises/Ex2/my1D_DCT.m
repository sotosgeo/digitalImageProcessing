function dct_1d= my1D_DCT(m,n)
%MYDCT Calculates 1D-DCT of matrix
    %N = length(inputMatrix);

%     [cc,rr] = meshgrid(0:n-1, 0:m-1); 
%     dct_1d = sqrt(2 / n) * cos(pi * (2*cc + 1) .* rr / (2 * n)); 
%     dct_1d(1,:) = dct_1d(1,:) / sqrt(2); 


    c(1:m,1) = sqrt(2)/sqrt(m);
    c(1) = c(1) / sqrt(2);
    range = (0:m-1);
    dct_1d = c.*cos(range(:)*pi*(2*range+1)/(2*m));

end

