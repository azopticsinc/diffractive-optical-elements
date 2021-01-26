%%Diffractive axicon%%
clear; %Clear all memory

% Defining Grating Parameters
N=500; %Define Matrix sizes
A=ones(N,N); %Define Matrices by assigning 1 to all pixels
P=50;%Define the period of the grating
FFr=0.5;%Define fill factor for radial periodicity

% Constructing the grating
    x=1:N;
    y=1:N;
    del=5;
    [X,Y]=meshgrid(x*del,y*del);
    r=sqrt((X-N/2*del).*(X-N/2*del)+(Y-N/2*del).*(Y-N/2*del));
    A(rem(r,P)<P/2)=exp(1i*pi); 
    A(r>N/2-2)=0;  

%Observing the grating output in the far-field
E=fftshift(fft2(A));
IN=(abs(E)/(N*N)).*(abs(E)/(N*N));
figure(1)
colormap(gray); 
imagesc(angle(A))          
figure(2)
colormap(gray);
imagesc(IN);
