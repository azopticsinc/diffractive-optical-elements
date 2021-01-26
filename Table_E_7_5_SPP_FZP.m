%CGHOE for generation and focusing of a helical wavefront
%Define parameters
N=500;
L=5;
V=0.5;%%Visibility controller
lambda=0.632*1e-6;%Define wavelength
f=0.005;%Define wavelength

%Sampling
    del=1*1e-6;%
    x=-N/2:N/2-1;
    y=-N/2:N/2-1;
    [X,Y]=meshgrid(x*del,y*del);
    R=sqrt(X.^2+Y.^2);

%Interference
    B=V*exp(1i*((2*pi)/lambda)*(f-sqrt(f*f-R.*R)));
    A=V*exp(1i*L*(atan2(X,Y)));
    D=A+B;%Interference of the object and reference wave
    I=abs(D).*abs(D);
    colormap(gray)
    imagesc(I)

%Binarize
    I1=im2bw(I);%Binarize the matrix
    SPP_FZP=exp(1i*pi*I1);%Generate the FZP
