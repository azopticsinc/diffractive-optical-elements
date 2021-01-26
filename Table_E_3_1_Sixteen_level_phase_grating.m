%%16-level 1D grating
%Clear all memory
clear;

%Define grating paramters
N=500;%Define Matrix size
P=100;%Define the period of the grating
AF=ones(P,N);%Define the size of fundamental building block of grating
g=16;%Define phase levels
delphase=2*pi/g;

%Construct the fundamental unit of 16-level phase grating
for n1=1:g;
   for p=1:P;
      for q=1:N;
          if p > (n1-1)*P/g && p <= (n1)*P/g ;
             AF(p,q)=exp(1i*n1*delphase);
          end
      end
   end
end

%Construct the full grating using repmat 
A=repmat(AF,5,1);

%Observation of diffraction pattern
AD=fftshift(fft2(A));
IN=(abs(AD)/(N*N)).*(abs(AD)/(N*N));
figure
colormap(gray);
imagesc(angle(A))
figure
colormap(gray);
imagesc(IN);