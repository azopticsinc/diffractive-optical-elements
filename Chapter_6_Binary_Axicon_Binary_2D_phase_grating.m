%Multifunctional DOE – Blazed FZP and 2-d grating
clear;%Clear all memory

%Define grating and FZP parameters
N=500;%Define Matrix size
f=10000;
lambda=0.632;
Pr=50;
Px=25;
Py=25;
FFr=0.5;
FFy=0.5;
FFx=0.5;
A1=zeros(N,N);%Define the matrices assigning ones to all pixels
A2=zeros(N,N);
A3=zeros(N,N);

%Grating and Axicon construction and multiplexing
    x=1:N;
    y=1:N;
    [X,Y]=meshgrid(x,y);
    r=sqrt((X-N/2).*(X-N/2)+(Y-N/2).*(Y-N/2));
    A1(rem(r,Pr)<Pr*FFr)=1;
    A2(rem(Y,Py)<Py*FFy)=1;
    A3(rem(X,Px)<Px*FFx)=1;
    A4=pi*xor(A1,xor(A2,A3));
    B=exp(1i*A4);
    B(r>150)=0;

%Observation of diffraction pattern
C=fftshift(fft2(B));
D=abs(C).*abs(C);
colormap(gray)
imagesc(D)
