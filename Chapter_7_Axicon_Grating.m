%Grating+Axicon
%Define parameters
N=500;%%Define size of the matrix
Angle1=1;%Define angle of axicon
Angle2=1;%Define angle of grating
V=0.5;%%Visibility controller
lambda=0.632*1e-6;%Define wavelength 

%Create sampled space 
    del=1*1e-6;%sampling
    x=-N/2:N/2-1;
    y=-N/2:N/2-1;
    [X,Y]=meshgrid(x*del,y*del); 
    r=sqrt(X.^2+Y.^2);
    A=V*exp(1i*(r/lambda)*tand(Angle1)*2*pi);
    B=V*exp(1i*(Y/lambda)*tand(Angle2)*2*pi);
    D=A+B;%Interference of the object and reference wave

%%Intensity profile
    I=abs(D).*abs(D);
    I1=im2bw(I);
    Grating_axicon=exp(1i*pi*I1);
    Grating_axicon(r>100)=0;
    E=fftshift(fft2(Grating_axicon));
    I2=(abs(E).*abs(E));
    colormap(gray);%%Display result
    imagesc(I2);

