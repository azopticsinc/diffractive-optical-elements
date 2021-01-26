%%1-d FZP%%
clear; %Clear all memory

%Defining FZP parameters
N=500; %Define Matrix sizes
M=50;%Define the number of grating lines
A=ones(N,N); %Define Matrices by assigning 1 to all pixels
x=zeros(M,M);
f=3000;%Define the focal length of FZP in micrometers
lambda=0.633;%Define wavelength in micrometers

% Constructing the FZP
for n=1:M;
    x(n)=sqrt(n*f*lambda);
end
for n=1:2:M;
    for q=1:N;
        if abs(q-N/2) > x(n) && abs(q-N/2) < x(n+1);
           A(:,q)=exp(1i*pi);
        end
    end
end

%Observing the FZP and farfield patern
E=fftshift(fft2(A)); %fftshift is used to re-order the terms in their natural order
IN=(abs(E)/(N*N)).*(abs(E)/(N*N));      % Calculating intensity
figure(1)
colormap(gray); 
imagesc(angle(A))          
figure(2)
colormap(gray);
imagesc(IN);