%program to generate Talbot images of amplitude grating 
%Output of this file is very dependent on values of r0, P, N, w 
clear all

%constants
lambda=600e-9; %in m
k=2*pi/lambda;

% Defining Grating Parameters
N=2000; %Define Matrix size
P=75; %Define the period of the grating in pixels
FF=0.25; %Define fill factor   
period=P*1e-6; %period in distance units
A=ones(1,N); %Define a Matrix by assigning 1 to all pixels

% Constructing the Grating
    q=1:N; 
    A(rem(q,P)<P*FF)=0; 
    A=repmat(A,N,1); %replicate the row to create a 2-d grating
% Create a window around the grating of pixel width w
    w=500;
    A(1:w,:)=0;
    A(N-w:N,:)=0;
    A(:,1:w)=0;
    A(:,N-w:N)=0;

% Talbot Distance
    zT=(2*period^2)/lambda;%Talbot distance

%Creating sampled space
    r0=(N/P)*period/2;  %radius of input beam
    step=2*r0/(N-1);
    index=-r0:step:r0;  %regular spaced points 
    [XH,YH] = meshgrid(index,index);   %creates grid of points with limits given by index

%run this program at various distances
    dist=[zT/ 4 zT/ 2 zT];
    [m,n]=size(dist);
for count = 1:n
    z=dist(count);
    z0=z/zT; %distance in terms of Talbot distance
    a=num2str(z0); %used to label figures
    %Observing the grating output in the near-field
    E=(A.*exp((1i*k/(2*z))*(XH.^2+YH.^2)))/(lambda*z);
    E=fftshift(fft2(E));
    I=(abs(E)/(N*N)).*(abs(E)/(N*N)); % Calculating intensity
    figure(count)
    colormap(gray)
    imagesc(I);
end
