%% Blazed axilens
clear; % Clear all memory

% Define axilens parameters
% All lengths in microns
N=500; % Matrix size
f0=5000;%  focal length
delf=1000;%  focal depth
R=1000;%  radius of the element
lambda=0.632;%  wavelength 

%Constructing the axilens
    x=1:N;
    y=1:N;
    [X,Y]=meshgrid(x,y);
    r=sqrt((X-N/2).*(X-N/2)+(Y-N/2).*(Y-N/2));
    f=f0+(delf/R)*r; % Focal length equation
    A=(f-sqrt(f.*f+r.*r))*(2*pi)/(0.632);
    B=exp(1i*rem(A,2*pi));
    B(r>N/2)=0;

         
%Observation of phase of axilens
colormap(gray);
imagesc(angle(B));

