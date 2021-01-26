%%4-level 1D FZP
clear;%Clear all memory

%Define the FZP parameters
N=500;%Define Matrix size
f=10000;%Define the focal length in ?m
lambda=0.632;%Define the wavelength in ?m
C=ones(N,N);
g=4;

%Constructing the negative FZP
x=1:N;
y=1:N;
[X,Y]=meshgrid(x,y);
r=sqrt((X-N/2).*(X-N/2)+(Y-N/2).*(Y-N/2));
A=(f+sqrt(f*f+r.*r))*(2*pi)/(0.632);
B=rem(A,2*pi);
B1=exp(1i*B);
B(r>N/2)=0;
for p=1:N;%Construct the 4-level FZP
    for q=1:N;  
        for n=1:g;
            if B(p,q)> (n-1)*pi/2 && B(p,q) <= n*pi/2;
               C(p,q)=exp(1i*n*pi/2);
            end
        end
    end 
end

%Observation of phase profile 
colormap(gray)
imagesc(angle(C))