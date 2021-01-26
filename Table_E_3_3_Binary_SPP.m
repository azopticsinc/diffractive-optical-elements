%Binary SPP with L=5
clear;

%Defining the SPP parameters
N=500;%Define the matrix size
L=5;%Define the topological charge number
A3=zeros(N,N);

%Constructing the SPP
    x=1:N;
    y=1:N;
    [X,Y]=meshgrid(x,y);
    theta=atan2((X-N/2),(Y-N/2));
    r=sqrt((X-N/2).*(X-N/2)+(Y-N/2).*(Y-N/2));
    A1=L*(theta+pi);
    A2=rem(A1,2*pi);
for p=1:N;%Construct the SPP using atan2 function and binarize
    for q=1:N;
        if rem(A2(p,q),2*pi)<=pi;
            A3(p,q)=exp(1i*pi);
        else
            A3(p,q)=exp(1i*0);
        end
    end
end
A3(r>30)=0;

%Observation of far field pattern
E=fftshift(fft2(A3));%Calculate the fourier transform and rearrange terms
I=abs(E).*abs(E);
colormap(gray)
imagesc(I)
