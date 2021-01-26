%Accelerating beams
%Define parameters
N=500;%%Define size of the matrix
Angle=0.1;%Define angle of the second plane wave
V=0.5;%%Visibility controller
lambda=0.632*1e-6;%Define wavelength 

%Create sampled space 
    del=1*1e-6;%sampling
    x=-N/2:N/2-1;
    y=-N/2:N/2-1;
    [X,Y]=meshgrid(x*del,y*del); 
    r=sqrt(X.^2+Y.^2);
    A=V*exp(1i*(r/lambda)*tand(Angle)*2*pi);
    B=V*exp(1i*(10*sqrt(Y/del+N/2)+10*sqrt(X/del+N/2)));
    D=A+B;%Interference of the object and reference wave

%%Intensity profile
    I=abs(D).*abs(D);
    I1=im2bw(I);
    AB=exp(1i*pi*I1);
% AB(r>100*del)=0;
    E=fftshift(fft2(AB));
    I2=(abs(E).*abs(E));
    
%%Display result 
colormap(gray);
imagesc(I2);

