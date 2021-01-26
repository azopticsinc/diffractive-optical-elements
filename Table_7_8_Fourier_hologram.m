%Fourier Hologram
% Load the object and create the object and reference matrices
N=500;%Define the size of the matrix
A=imread('Image location');%Loading the image          
A=double(A);
A=A(1:N,1:N);
A=imresize(A,[N,N]);
B=zeros(N,N);%Dirac delta function
B(250,250)=100;

%Calculate the far field diffraction patterns of the object and reference
    A1=fftshift(fft2(A));%Calculate the diffraction pattern for the object 
    I1=abs(A1).*abs(A1);
    B1=fftshift(fft2(B));%Calculate the diffraction pattern for the reference
    I2=abs(B1).*abs(B1);

%Create the hologram by interfering the far field diffracted fields of object and %reference
    D1=A1+B1; 
    I3=abs(D1).*abs(D1);

%Filtering
I4=(I3-I1);%Filtering of autocorrelation term

%Hologram reconstruction
D2=fftshift(fft2(I4));
I5=abs(D2).*abs(D2);
