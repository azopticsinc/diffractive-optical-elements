%Fresnel diffraction of DOE
clear; %Clear all memory

% Defining the parameters
N=500;% Define the matrix size                                                                            
lambda=0.633*10^-6;%Define wavelength in meters                                                               
z=10*1e-3;%Propagation distance         
del=1*1e-6;%sampling period or width

%Sampling the space
    x=-N/2:N/2-1;                                                                                                                                           
    y=-N/2:N/2-1;                                                                               
    [X,Y]=meshgrid(x*del,y*del);%Sampling                                                      
    R=sqrt(X.^2+Y.^2);%Define sampled radius

%Constructing the DOE
    A=exp(1i*(X+250*1e-6).^3*2*pi*5*10^11);

%Calculating the Fresnel diffraction
    PPF=exp(1i*pi/(lambda*z)*R.*R); %Calculate the parabolic phase factor                       
    A1=A.*PPF; %Multiply the circular aperture function with the parabolic phase factor               
    E=abs(fftshift(fft2(fftshift(A1)))); %Calculate Fourier Transform   
    E=E/max(max(E));
    figure (1)
    imagesc(E);
    figure (2)
    plot(E(N/2,:)/(max(max(E(N/2,:)))))
