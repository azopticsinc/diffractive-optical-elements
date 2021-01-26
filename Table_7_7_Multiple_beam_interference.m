%%Multiple beam interference
%Define parameters
N=500;%%Define size of the matrix
Angle=1;%Define angle of the second plane wave
V=0.25;%%Visibility controller
lambda=0.632*1e-6;%Define wavelength

%Sampling
    del=1*1e-6;%sampling
    x=-N/2:N/2-1;
    y=-N/2:N/2-1;
    [X,Y]=meshgrid(x*del,y*del); 

 %Simulate interference
    A=V*exp(1i*(Y/lambda)*tand(Angle)*2*pi);
    B=V*exp(1i*(X/lambda)*tand(-Angle)*2*pi);
    C=V*exp(1i*(X/lambda)*tand(Angle)*2*pi);
    D=V*exp(1i*(Y/lambda)*tand(-Angle)*2*pi);
    I=A+B+C+D;%Interference of the object and reference wave 
 
%%Intensity profile
    I1=abs(I).*abs(I); 

%Observation of the HOE
colormap(gray)
imagesc(I1)
