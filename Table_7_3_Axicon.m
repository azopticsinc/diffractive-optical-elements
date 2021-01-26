%Diffractive axicon
%Define parameters
N=500;%%Define size of the matrix
Angle=1;%Define angle of the second plane wave
V=0.5;%%Visibility controller
lambda=0.632*1e-6;%Define wavelength 

%Create sampled space 
    del=1*1e-6;%sampling
    x=-N/2:N/2-1;
    y=-N/2:N/2-1;
    [X,Y]=meshgrid(x*del,y*del); 

%Simulate interference
    A=V* exp(1i*(sqrt(X.^2+Y.^2)/lambda)*tand(Angle)*2*pi);
    B=V*exp(1i*2*pi);
    D=A+B;%Interference of the object and reference wave
    I=abs(D).*abs(D);
    figure (2)
    colormap gray
    imagesc(I)

%%Construct FZP
    I1=im2bw(I);%Binarize the matrix
    Grating=exp(1i*pi*I1);%Generate the Axicon

%Observation of the HOE
colormap(gray)
imagesc(angle(Grating))