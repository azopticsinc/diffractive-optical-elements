% Blazed FZP
clear; %Clear all memory

% Defining FZP parameters
N=500; % Matrix size
f=10000; % focal length in microns
lambda=0.632; % Wavelength in microns

% Constructing the blazed FZP
    x=1:N;
    y=1:N;
    [X,Y]=meshgrid(x,y);
    r=sqrt((X-N/2).*(X-N/2)+(Y-N/2).*(Y-N/2));
    A=exp(1i*(f-sqrt(f*f+r.*r))*(2*pi)/(0.632));
    A(r>N/2)=0;

%Observing the phase profile
colormap(gray)
imagesc(angle(A))