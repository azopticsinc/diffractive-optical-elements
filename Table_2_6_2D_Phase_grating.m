% Version 1
%%Checkerboard phase grating%%
clear; %Clear all memory

% Defining Grating Parameters
N=500; %Define Matrix size
A1=zeros(N,N); %Define Matrices by assigning 0 to all pixels
A2= zeros (N,N);
A= zeros (N,N);
Px=100; %Define the periods of the gratings
Py=100;
FFx=0.5; %Define fill factors
FFy=0.5; 

% Constructing the grating
for p=1:N;
      for q=1:N;
             if rem(q,Px)<Px*FFx;
                   A1(p,q)=1;
             end
             if rem(p,Py)<Py*FFy;
	               A2(p,q)=1;
	         end
       end
end
A=exp(1i*pi*xor(A1,A2));%% XOR operation between A1 and A2

%Observing the grating output in the far-field
E=fftshift(fft2(A)); %fftshift is used to re-order the terms in their natural order
IN=(abs(E)/(N*N)).*(abs(E)/(N*N));      % Calculating intensity
figure(1)
colormap(gray); 
imagesc(angle(A))          
figure(2)
colormap(gray);
imagesc(IN);

