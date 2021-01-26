%%Circular FZP%%
clear; %Clear all memory

% Defining Grating Parameters
N=500; %Define Matrix size
M=32;
r1=zeros(M);
A=zeros(N,N);
r=zeros(N,N);
f=3000;
lambda=0.632;

% Constructing the FZP
for n=1:M; %Calculate the width of the grating lines
      r1(n)=sqrt(n*f*lambda);
end
for n=1:2:M;
      for p=1:N;
            for q=1:N;
                  r(p,q)=sqrt((p-N/2)*(p-N/2)+(q-N/2)*(q-N/2));
                  if r(p,q) > r1(n) && r(p,q) < r1(n+1);
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