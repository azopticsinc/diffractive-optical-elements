%% 4-level axicon
 clear; %Clear all memory

%Defining axicon parameters
N=480; % Matrix size
A=zeros(N,N); 
P=80; % Grating period
g=16; %Define the number of phase levels in each period
w=P/g; %Define the width of each phase levels
delphase=2*pi/g;
%Constructing the 8-level axicon
    x=1:N;
    y=1:N;
    [X,Y]=meshgrid(x,y);
    r=sqrt((X-N/2).*(X-N/2)+(Y-N/2).*(Y-N/2)); 
for n=1:g;
    A(rem(r+(n-2)*w,P)<P/g)=exp(1i*(w-(n))*delphase);
end

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

