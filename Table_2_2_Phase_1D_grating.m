%%1D Phase grating%%
clear; %Clear all memory

% Defining Grating Parameters
N=500; %Define Matrix size
A=ones(1,N); %Define a Matrix by assigning 1 to all pixels
P=100; %Define the period of the grating
FF=0.5; %Define fill factor 

% Constructing the Grating
for q=1:N; %Scan pixel by pixel 
       if rem(q,P)<P*FF; %Use remainder function 'rem' to construct the grating
           A(1,q)=exp(1i*pi);
       end
end
A=repmat(A,N,1); %replicate the row to create a 2-d grating

%Observing the grating output in the far-field
E=fftshift(fft2(A)); %fftshift is used to re-order the terms in their natural order
IN=(abs(E)/(N*N)).*(abs(E)/(N*N));      % Calculating intensity
figure(1)
colormap(gray); 
imagesc(angle(A))          
figure(2)
colormap(gray);
imagesc(IN);
