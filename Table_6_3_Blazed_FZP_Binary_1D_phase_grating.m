%Multifunctional DOE – Blazed FZP and 1-d grating
clear;%Clear all memory

%Define grating and FZP parameters
N=500;%Define Matrix size
f=10000;
lambda=0.632;
P=200;
FFy=0.5;
A1=zeros(N,N);%Define the matrices assigning ones to all pixels
A2=zeros(N,N);
A3=zeros(N,N);

%Grating and FZP construction
    x=1:N;
    y=1:N;
    [X,Y]=meshgrid(x,y);
    r=sqrt((X-N/2).*(X-N/2)+(Y-N/2).*(Y-N/2));
    A1=(f-sqrt(f*f+r.*r))*(2*pi)/(0.632);
    A2(rem(Y,P)<P*FFy)=pi;
    A=rem(A1+A2,2*pi);
    B1=exp(1i*A1);
    B2=exp(1i*A2);
    B3=exp(1i*A);

%Observation of the DOE
colormap(gray)
imagesc(angle(B3))