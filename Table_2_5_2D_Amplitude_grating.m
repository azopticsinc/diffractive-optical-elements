%%2D Amplitude grating%%
clear; %Clear all memory

% Defining Grating Parameters
N=500; %Define Matrix size
A=zeros(N,N); %Define a Matrix by assigning 0 to all pixels
Px=100; Py=100; %Define the period of the grating
FFx=0.5; FFy=0.5; %Define fill factor 

% Constructing the Grating
for p=1:N; %Scan pixel by pixel using for loops and construct grating using ‘rem’
      for q=1:N; 
             if rem(q,Px)<Px*FFx && rem(p,Py)<Py*FFy; 
                 A(p,q)=1;
             end
      end
end

%Observing the grating output in the far-field
E=fftshift(fft2(A)); %fftshift is used to re-order the terms in their natural order
IN=(abs(E)/(N*N)).*(abs(E)/(N*N));      % Calculating intensity
figure(1)
colormap(gray); 
imagesc((A))          
figure(2)
colormap(gray);
imagesc(IN);