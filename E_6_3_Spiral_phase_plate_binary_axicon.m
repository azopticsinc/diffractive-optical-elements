%Spiral phase plate + axicon
%Clear all memory
clear;
%Define Matrix size
N=500;
%Define Matrices by assigning 0 or 1 to all elements
A1=zeros(N,N);
A2=ones(N,N);
r=zeros(N,N);
%Define focal length and wavelength (in micrometers)
P=10;
M=(N/P)*0.5;
L=10;
r1=zeros(M,M);
%Calculate the widths of the grating lines
for n=1:M;
    r1(n)=n*P;
end
%Scan element by element using two for loops 
%Define pixels within grating lines with pi
for n=1:2:M;
for p=1:N;
    for q=1:N;
        r(p,q)=sqrt((p-N/2)*(p-N/2)+(q-N/2)*(q-N/2));
        if r(p,q)<100;
        if r(p,q) > r1(n) && r(p,q) < r1(n+1);
        A1(p,q)=exp(1i*L*(atan2((q-N/2),(p-N/2))));
        end
        end
    end
end
end
%Observing the diffraction pattern
E=fftshift(fft2(A1));
I=abs(E).*abs(E);
colormap(gray)
imagesc(I)
