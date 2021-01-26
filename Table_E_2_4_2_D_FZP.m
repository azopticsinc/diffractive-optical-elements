%%2-d FZP%%
clear; %Clear all memory

%Define parameters
N=500; %Define Matrix sizes
M=50;%Define the number of grating lines
A1=zeros(N,N);%Define Matrices by assigning zeros to all pixels
A2=zeros(N,N);
x=zeros(M,M);
y=zeros(M,M);
fx=3000; %Define focal lengths (in micrometers)
fy=6000; 
lambda=0.633; %Define wavelength (in micrometers)

%Consgruting the grating
for n=1:M; %Calculate the width of the grating lines
      x(n)=sqrt(n*fx*lambda);
      y(n)=sqrt(n*fx*lambda);
end
for n=1:2:M;
      for p=1:N;
            for q=1:N;
                   if abs(q-N/2) > x(n) && abs(q-N/2) < x(n+1);
                    A1(p,q)=1;
                   end
                   if abs(p-N/2) > y(n) && abs(p-N/2) < y(n+1);
                    A2(p,q)=1;                   
                   end
            end
      end
end
A3=exp(1i*pi*xor(A1,A2));

%Observing the grating output in the far-field
E=fftshift(fft2(A3)); %fftshift is used to re-order the terms in their natural order
IN=(abs(E)/(N*N)).*(abs(E)/(N*N));      % Calculating intensity
figure(1)
colormap(gray); 
imagesc(angle(A3))          
figure(2)
colormap(gray);
imagesc(IN);
