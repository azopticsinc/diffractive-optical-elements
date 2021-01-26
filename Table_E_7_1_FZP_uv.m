%%Fresnel zone plate uv
%Define parameters
N=500;%%Define size of the matrix
V=0.5;%%Visibility controller
lambda=0.632*1e-6;%Define wavelength 

%Create sampled space 
    del=1*1e-6;%sampling
    x=-N/2:N/2-1;
    y=-N/2:N/2-1;
    [X,Y]=meshgrid(x*del,y*del); 
    r=sqrt(X.^2+Y.^2);
    u=0.01; %Focal length of 1 cm
    v=0.02;

%Simulate interference
    A=V*exp(1i*((2*pi)/lambda)*(u-sqrt(u*u-r.*r)));
    B=V*exp(1i*((2*pi)/lambda)*(-v+sqrt(v*v-r.*r)));
    D=A+B;%Interference of the object and reference wave
    I=abs(D).*abs(D);
    figure (2)
    colormap gray
    imagesc(I)

%%Construct FZP
    I1=im2bw(I);%Binarize the matrix
    FZP_uv=exp(1i*pi*I1);%Generate the FZP
