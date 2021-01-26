%%Greyscale ring lens
clear;%Clear all memory

%Define lens parameters
N=500;%Define Matrix size
f=2000;%Define the focal length in um
r0=100;%Define radius of ring in um
lambda=0.632;%Define the wavelength in um

%Constructing the lens
    x=1:N;
    y=1:N;
    [X,Y]=meshgrid(x,y);
    r=sqrt((X-N/2).*(X-N/2)+(Y-N/2).*(Y-N/2));
    A=(f-sqrt(f*f+(r-r0).*(r-r0)))*(2*pi)/(0.632);
    B=rem(A,2*pi);
    B1=exp(1i*B);

%Observation of phase profile
colormap(gray)
imagesc(B)
