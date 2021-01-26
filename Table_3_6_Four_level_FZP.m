%% 4-level FZP
clear;%Clear all memory

%Define FZP parameters
N=500; % Matrix size
f=10000; % Focal length in microns
lambda=0.632;% Wavelength in microns
g=4; % Number of phase levels
delphase=(2*pi)/g;
% Set up matrices, assigning 0’s or 1’s to all pixels
C=ones(N,N);

%Constructing the FZP
x=1:N;
y=1:N;
[X,Y]=meshgrid(x,y);
r=sqrt((X-N/2).*(X-N/2)+(Y-N/2).*(Y-N/2));
A=(f-sqrt(f*f+r.*r))*(2*pi)/(0.632);
B=rem(A,2*pi);
B(r>N/2)=0;
for p=1:N;%Construct the n-level FZP
    for q=1:N;  
        for n1=1:g;
            if B(p,q)> (-2*pi+(n1-1)*delphase) && B(p,q) <= (-3*pi/2+(n1-1)*delphase);
               C(p,q)=exp(1i*(-2*pi+(n1-1)*pi/2));
            end
        end
    end 
end

%Observing the phase profile
colormap(gray)
imagesc(angle(C))