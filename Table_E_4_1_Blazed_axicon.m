%Fresnel diffraction of blazed axicon% 
clear; %Clear all memory

% Defining the parameters
N=500;% Define the matrix size
lambda=0.633*10^-6;%Define wavelength in meters
z=50;%Propagation distance = 50 m
P=10^-4;%Period of axicon = 0.1 mm
wsamp=10*lambda;%sampling period or width

%Sampling the space
    x=1:N;
    y=1:N;
    [X,Y]=meshgrid(x,y);%Sampling
    Rsamp=sqrt((X-N/2).^2+(Y-N/2).^2).*wsamp;%Define sampled radius

%Constructing the DOE
    A=exp(1i*(rem(Rsamp,P))*(2*pi)/P);
    A(Rsamp>N/2*wsamp)=0;     

% Calculating the Fresnel diffraction
    PPF=exp(1i*pi/(lambda*z).*Rsamp.*Rsamp); %Calculate the parabolic phase factor
    A1=A.*PPF; %Multiply the circular aperture function with the parabolic phase factor
    E=abs(fftshift(fft2(fftshift(A1)))); %Calculate Fourier Transform

%Observation of diffraction pattern
    colormap(gray)
    imagesc(E)