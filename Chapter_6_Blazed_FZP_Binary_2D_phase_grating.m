%Multifunctional DOE – Blazed FZP and 2-d grating
clear;%Clear all memory

%Define grating and FZP parameters
N=500;%Define Matrix size
f=10000;
lambda=0.632;
P=100;
FFy=0.5;
FFx=0.5;
A1=zeros(N,N);%Define the matrices assigning ones to all pixels
A2=zeros(N,N);
A3=zeros(N,N);

%Grating and FZP construction and multiplexing
    x=1:N;
    y=1:N;
    [X,Y]=meshgrid(x,y);
    r=sqrt((X-N/2).*(X-N/2)+(Y-N/2).*(Y-N/2));
    A1=(f-sqrt(f*f+r.*r))*(2*pi)/(0.632);
    A1=rem(A1,2*pi);
    A2(rem(Y,P)<P*FFy)=pi;
    A3(rem(X,P)<P*FFx)=pi;
    A4=pi*xor(A2,A3);
    A=rem(A1+A4,2*pi);
    B=exp(1i*A);

%Observation of DOE
colormap(gray)
imagesc(angle(B))