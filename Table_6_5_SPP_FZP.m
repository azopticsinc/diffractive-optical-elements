%Multifunctional DOE – Blazed circular grating and blazed 1-d grating
clear; %Clear all memory
%Define grating parameters
N=500; %Define Matrix size
M=32; %Define number of zones
A1=zeros(N,N); %Define Matrices by assigning 0 or 1 to all elements
r1=zeros(M,M);
r=zeros(N,N);
f=3000; %Define focal length and wavelength (in micrometers)
lambda=0.633;
L=1;%Define topological charge
% Construction of the spiral FZP
for n=1:M; %Calculate the widths of the zones
    r1(n)=sqrt(n*f*lambda);
end
for n=1:2:M; %Scan element by element using two for loops 
     for p=1:N;
          for q=1:N;
               r(p,q)=sqrt((p-N/2)*(p-N/2)+(q-N/2)*(q-N/2));
                   if r(p,q) > r1(n) && r(p,q) < r1(n+1);
                      A1(p,q)=exp(1i*L*(atan2((q-N/2),(p-N/2))));
                   end
          end
    end
end

%Observation of the DOE
colormap(gray)
imagesc(angle(A1))