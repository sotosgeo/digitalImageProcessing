%% create the matrix
shapes=3;

switch shapes
    case 1
        m=zeros(22);
        m(4:19,4)=1;m(4:19,19)=1;
        m(4,5:19)=1;m(19,5:19)=1;
    case 2
        m=zeros(41);
        m(5,18:24)=1;
        m(5:19,18)=1; m(5:19,24)=1; m(19:25,5)=1;
        m(19,5:18)=1;m(19,24:37)=1; m(19:25,37)=1;
        m(25,5:18)=1;m(25,24:37)=1;
        m(25:39,18)=1; m(25:39,24)=1;
        m(39,18:24)=1;
    case  3
        m=zeros(30);
         m(10,14:20)=1;
         m(10:22,14)=1;
          m(16,14:20)=1;
end

figure(1),imagesc(m);length(find(m))
%% make fft transform                       

[border_fft,border_restored]=make_fft_sec(m,10);
figure(2),imagesc(border_restored);
