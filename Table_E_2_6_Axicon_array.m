%Axicon array
clear; %Clear all memory

%Define parameters
N1=100; %Define matrix sizes
N2=500;
ratio=N2/N1;
A1=zeros(N1,N1); %Define a Matrix by assigning 0 to all elements
r=zeros(N1,N1);
P=10; %Define the period of the axicon

%Construct the axicon array
for p=1:N1; %Generate the fundamental building block – single axicon
      for q=1:N1;
             r(p,q)=sqrt((p-N1/2)*(p-N1/2)+(q-N1/2)*(q-N1/2));
             if r(p,q)<N1/2;
                if rem(r(p,q),P)<P/2;
                   A1(p,q)=1;
                end
            end
      end
end
A2=repmat(A1,ratio); %Generate the full grating

%Observing the grating output in the far-field
E=fftshift(fft2(A2)); %fftshift is used to re-order the terms in their natural order
IN=(abs(E)/(N2*N2)).*(abs(E)/(N2*N2));      % Calculating intensity
figure(1)
colormap(gray); 
imagesc((A2))          
figure(2)
colormap(gray);
imagesc(IN);