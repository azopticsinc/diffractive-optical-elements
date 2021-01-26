%%1D amplitude sinusoidal grating%%
clear; %Clear all memory

% Defining Grating Parameters
N=500; %Define Matrix size
P=100; %Define the period of the grating
FF=0.5; %Define fill factor 

% Constructing the Grating
    q=1:N;
    A=(1+sin(rem(q,P)*(2*pi)/P))/2;
    A=repmat(A,N,1);%replicate the row to create a 2-d grating

%Observing the grating output in the far-field
E=fftshift(fft2(A)); %fftshift is used to re-order the terms in their natural order
IN=(abs(E)/(N*N)).*(abs(E)/(N*N));      % Calculating intensity
figure(1)
colormap(gray); 
imagesc((A))          
figure(2)
colormap(gray);
imagesc(IN);
