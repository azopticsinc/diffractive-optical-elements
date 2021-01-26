%Fresnel diffraction of binary axicon% 
clear; %Clear all memory

% Defining the parameters
N=500;% Define the matrix size
lambda=0.633*10^-6;%Define wavelength in meters
z=0.025;%Propagation distance = 25mm and 50 m
P=10^-4;%Radius of aperture = 0.1 mm
wsamp=10*lambda;%sampling period or width
%Creating sampled space
    x=1:N;
    y=1:N;
    [X,Y]=meshgrid(x,y);%Sampling
    Rsamp=sqrt((X-N/2).^2+(Y-N/2).^2).*wsamp;%Define sampled radius

%Constructing the DOE
    A=ones(N,N);%Define matrix by assigning ones to all pixels
    A(rem(Rsamp,P) < P/2)=exp(1i*pi);

%Calculating the Fresnel diffraction pattern
    PPF=exp(1i*pi/(lambda*z).*Rsamp.*Rsamp); %Calculate the parabolic phase factor
    A1=A.*PPF; %Multiply the circular aperture function with the parabolic phase factor
    E=abs(fftshift(fft2(fftshift(A1)))); %Calculate Fourier Transform
    colormap(gray)
    imagesc(E)

