%%Blazed axicon
clear;%Clear all memory
%Define axicon parameters
N=500; % Matrix size
P=100; % Grating period 
A=ones(N,N); % Set up matrix, assigning 1’s to all pixels

%Constructing the blazed axicon
    x=1:N;
    y=1:N;
    [X,Y]=meshgrid(x,y);
    r=sqrt((X-N/2).*(X-N/2)+(Y-N/2).*(Y-N/2)); 
    A=exp(1i*(rem(r,P))*(2*pi)/P);
    A(r>N/2)=0;  

%Observation of the diffraction pattern
E=fftshift(fft2(A)); %fftshift to re-order the terms to the natural order
I=abs(E).*abs(E);
figure(1)
colormap(gray); 
imagesc(angle(A))          
figure(2)
colormap(gray);
imagesc(I);

