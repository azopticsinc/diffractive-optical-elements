%Fresnel Hologram
%Load object and create the object and reference matrices
N=500;% Define the matrix size
B=ones(N,N);%Reference wave
A=imread('Image location');%Loading the image          
A=double(A);%Convert symbolic object to numeric object
A=A(1:N,1:N);
A=A/max(max(A));%Normalizing the matrix

%Sampling
    del=1;%
    x=-N/2:N/2-1;
    y=-N/2:N/2-1;
    [X,Y]=meshgrid(x*del,y*del); 

%Calculate the Fresnel diffraction pattern of the object
    A1=A.*exp(-1i*(pi/N)*(X.^2+Y.^2));
    A2=fftshift(fft2(fftshift(A1)));
    A3=A2.*exp(1i*(pi/N)*(X.^2+Y.^2));

%Create interference between the object and reference waves
    H1=B+A3;%Interference pattern
    
%Filtering
    I1=abs(A3).*abs(A3);
    I2=abs(H1).*abs(H1);
    H2=I2-I1;%Filtering
    H2=H2/max(max(H2));%Normalizing the hologram

%Reconstruct the hologram
    H3=H2.*exp(-1i*(pi/N)*(X.^2+Y.^2));
    H4=fftshift(fft2(fftshift(H3)));
    H5=H4.*exp(1i*(pi/N)*(X.^2+Y.^2));
    H6=(abs(H5).*abs(H5));
    H7=rot90(H6,2);
    
%Display reconstructed image
colormap(gray)
imagesc(H7)
