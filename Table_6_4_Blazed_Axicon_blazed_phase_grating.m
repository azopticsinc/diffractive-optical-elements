%Multifunctional DOE – Blazed circular grating and blazed 1-d grating
clear% Clear all memory

%Define grating parameters
N=500;%Define Matrix size
Pr=25;
Px=10;

%Blazed axicon and grating construction
    x=1:N;%Sampling
    y=1:N;
    [X,Y]=meshgrid(x,y);
    r=sqrt((X-N/2).*(X-N/2)+(Y-N/2).*(Y-N/2));
    P1=rem(r,Pr); %Construction of blazed axicon
    A1=(P1/Pr)*2*pi;
    P2=rem(X,Px);%Construction of blazed 1-d grating
    A2=(P2/Px)*2*pi;
    A=rem(A1+A2,2*pi); %Modulo-2pi phase addition of the two phase profiles
    B=exp(1i*A);
    B(r>150)=0;

%Observation of diffraction pattern
E=(fftshift(fft2(B)));
I=abs(E).*abs(E);
colormap(gray)
imagesc(I)
