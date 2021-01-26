%%Blazed 1D grating
clear; %Clear all memory

% Defining grating parameters
N=500; % Matrix size
P=100; % Grating period
A1=ones(P,N); % Size of fundamental building block of grating

% Constructing the fundamental block of the blazed grating
for p=1:P; 
    A1(p,:)=exp(1i*(p/P)*2*pi);
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

