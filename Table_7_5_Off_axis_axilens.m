%Off axis axilens
%Define parameters
N=500;%%Define size of the matrix
Angle=1;%Define angle of the second plane wave
V=0.5;%%Visibility controller
lambda=0.632*1e-6;%Define wavelength 
L=3;
f0=0.01;
delf=0.003;

%Create sampled space 
    del=1*1e-6;%sampling
    x=-N/2:N/2-1;
    y=-N/2:N/2-1;
    [X,Y]=meshgrid(x*del,y*del); 
    f=f0+delf*sqrt(X.^2+Y.^2);

%Simulate interference
    A=V*exp(1i*((2*pi)/lambda)*(f-sqrt(f.*f-(X.^2+Y.^2))));
    B=V*exp(1i*(2*pi/lambda)*tand(Angle)*Y);
    D=A+B;%Interference of the object and reference wave

%Far field diffraction pattern
    I=abs(D).*abs(D);
    I1=im2bw(I);
    Off_axilens=exp(1i*pi*I1);
    Off_axilens(r>100*1e-6)=0;
    E=fftshift(fft2(Off_axilens));
    I2=(abs(E).*abs(E));
    
%%Display result
colormap(gray);
imagesc(I2);
