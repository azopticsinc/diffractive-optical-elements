%%Elliptical FZP%%
clear; %Clear all memory

%Define parameters
N=500; %Define Matrix sizes
M=25;%Define the number of grating lines
A=ones(N,N);%Define Matrices by assigning zeros to all pixels
rx=zeros(M,M);
r=zeros(N,N);
fx=3000; %Define focal lengths (in micrometers)
fy=4500; 
lambda=0.633; %Define wavelength (in micrometers)

%Construct the FZP
for n=1:M; %Calculate the width of the grating lines
      rx(n)=sqrt((n-1)*fx*lambda);
end
for n=1:2:M;%Construct elliptical FZP
      for p=1:N;
            for q=1:N;
                   r(p,q)=sqrt(((p-N/2)*(p-N/2))*(fx/fy)+((q-N/2)*(q-N/2)));
                    if r(p,q) > rx(n) && r(p,q) < rx(n+1);
                       A(p,q)=exp(1i*pi);
                    end
             end
       end
end

%Observing the grating output in the far-field
E=fftshift(fft2(A)); %fftshift is used to re-order the terms in their natural order
IN=(abs(E)/(N*N)).*(abs(E)/(N*N));      % Calculating intensity
figure(1)
colormap(gray); 
imagesc(angle(A))          
figure(2)
colormap(gray);
imagesc(IN);