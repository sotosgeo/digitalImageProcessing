function [border_fft,border_restored,xx,yy] = make_fft_sec(image_edged,ncoef)

border_fft=zeros(size(image_edged));border_restored=zeros(size(image_edged));
[a,b]=size(image_edged);

% find border
 f=find(image_edged);
 lenf=length(f);

 
  [new_indeces]=find_close_indeces(image_edged);
  ii=new_indeces(:,1);jj=new_indeces(:,2);
 border_cmplx=ii+j*jj;

   border_fft =fftshift(fft(border_cmplx));
   
   if mod(lenf,2) % odd
	lenf = lenf-1;
   end
    rc = fix(lenf/2)+1;  


p1=[ (rc+1):(rc+1+ncoef-1)];
p2=[ (rc-1):-1:(rc-1-ncoef+1)];



border_ifft=zeros(1,lenf);
for ind=1:(ncoef)
    mfreq_vec=zeros(1,lenf);
   mfreq_vec(p1(ind))=border_fft(p1(ind));
    mfreq_vec(p2(ind))=border_fft(p2(ind));
    
    border_ifft = border_ifft+(ifft(ifftshift(mfreq_vec)));
end

%add dc
 mfreq_vec=zeros(1,lenf);
 mfreq_vec(rc)=border_fft(rc);
 border_ifft = border_ifft+(ifft(ifftshift(mfreq_vec)));


border_restored = zeros(size(image_edged));
xx=real(border_ifft);yy=imag(border_ifft);


yyt=round(yy);xxt=round(xx);

if(length(xxt)==0)
    return ;
end

hind=sub2ind(size(border_restored),yyt,xxt);
border_restored(round(hind))=1;

figure(4),plot((xx),yy,'ro');