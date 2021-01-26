% Version 2: Checker pattern created without loops 

%%Checkerboard phase grating%%
clear; %Clear all memory

% Defining Grating Parameters
N=500; %Define Matrix size
Px=100; %Define the periods of the gratings
Py=100;
FFx=0.5; %Define fill factors
FFy=0.5; 

%Define one unit of the grating
    O=ones(FFy*Py , FFx*Px)*exp(1i*pi);
    Z=ones(FFy*Py , Px-FFx*Px);
    O1=ones(FFy*Py , Px-FFx*Px)*exp(1i*pi);
    Z1=ones(FFy*Py , FFx*Px);
    unit=[Z O; O1 Z1];
    s=size(unit);

%Constructing the entire grating
A=repmat(unit,N/s(1),N/s(2)); %replicate to create a 2-d grating

%Observing the grating output in the far-field
E=fftshift(fft2(A)); %fftshift is used to re-order the terms in their natural order
IN=(abs(E)/(N*N)).*(abs(E)/(N*N));      % Calculating intensity
figure(1)
colormap(gray); 
imagesc(angle(A))          
figure(2)
colormap(gray);
imagesc(IN);