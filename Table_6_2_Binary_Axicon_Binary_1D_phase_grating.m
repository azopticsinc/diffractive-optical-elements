%Multifunctional DOE – CG and 1-d grating
clear; %Clear all memory
% Defining Grating Parameters
N=500; %Define Matrix sizes
A1=zeros(N,N); %Define Matrices by assigning 1 to all pixels
A2=zeros(N,N);
P1=50;%Define the period of the binary axicon grating
P2=25;%Defind the period of the 1-d grating
FFr=0.5;%Define fill factor for radial periodicity
FFy=0.5;%Define fill factor for periodicity along y-direction

% Constructing the grating
    x=1:N;
    y=1:N;
    [X,Y]=meshgrid(x,y);
    r=sqrt((X-N/2).*(X-N/2)+(Y-N/2).*(Y-N/2));
    A1(rem(r,P1)<P1*FFr)=1; 
    A2(rem(Y,P2)<P2*FFy)=1;
    A3=exp(1i*pi*xor(A1,A2)); 
    A3(r>150)=0;
    
%Observing the grating output in the far-field
E=fftshift(fft2(A3));
I=abs(E).*abs(E);
figure(1)
colormap(gray)
imagesc(angle(A3))
figure(2)
colormap(gray)
imagesc(I)