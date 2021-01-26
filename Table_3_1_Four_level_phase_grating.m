%% 4-level 1D grating
clear  %Clear all memory

% Defining grating parameters
N=500; % Matrix size
P=100; % Grating period 
A1=ones(P,N); % Size of fundamental building block of grating
g=4; % Number of phase levels
delphase= 2*pi/g;  %Phase step size

% Constructing one n-level section of the phase grating
sub =round(P/g)-1; 
for count = 1:g;
     A1((count -1)*sub+1:count*sub,:)=exp(1i*(count-1)*delphase);
end

%Constructing the full grating
A2=repmat(A1,N/P,1); 

%Observation of the diffraction pattern
E=fftshift(fft2(A2)); %fftshift to re-order the terms to the natural order
IN=(abs(E)/(N*N)).*(abs(E)/(N*N)); %Normalize the intensity values
figure(1)
colormap(gray); 
imagesc(angle(A2))          
figure(2)
colormap(gray);
imagesc(IN);
