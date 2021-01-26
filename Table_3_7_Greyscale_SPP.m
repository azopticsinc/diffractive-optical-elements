%Greyscale SPP
clear; %Clear all memory

%Defining SPP parameters
N=500; % Matrix size
L=1;% Topological charge number

%Constructing the SPP
    x=1:N;
    y=1:N;
    [X,Y]=meshgrid(x,y);
    theta=atan2((X-N/2),(Y-N/2));
    r=sqrt((X-N/2).*(X-N/2)+(Y-N/2).*(Y-N/2));
    A1=exp(1i*L*(theta));
    A1(r>30)=0;

%Observation of the far-field pattern 
E=fftshift(fft2(A1)); %Calculate the Fourier transform and rearrange terms
I=abs(E).*abs(E);
colormap(gray)
imagesc(I)
