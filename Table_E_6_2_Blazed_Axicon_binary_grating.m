%%Multifunctional DOE- Blazed axicon and binary grating
clear;%Clear all memory
%Define grating parameters
N=500;%Define Matrix size
Pr=51;
Px=7;
FFx=0.5;
A2=zeros(N,N);%Define the matrices assigning ones to all pixels

%Construction of blazed axicon and binary grating
    x=1:N;
    y=1:N;
    [X,Y]=meshgrid(x,y);
    r=sqrt((X-N/2).*(X-N/2)+(Y-N/2).*(Y-N/2));
    P1=rem(r,Pr);
    A1=(P1/Pr)*2*pi;
    A2(rem(X,Px)<Px*FFx)=pi;
    A=exp(1i*rem(A1+A2,2*pi));

%Observation of the DOE
colormap(gray)
imagesc(angle(A))
