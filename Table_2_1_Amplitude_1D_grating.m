%%1D Amplitude grating%%
clear %Clear all memory

% Defining Grating Parameters
	N=500; %Define Matrix size
	A=zeros(1,N); %Define a row Matrix by assigning 0 to all pixels
	P=100; %Define the period of the grating
	FF=0.5; %Define fill factor 

% Constructing the Grating
for q=1:N; 
       if rem(q,P)<P*FF ; %Use remainder function 'rem' to construct the grating
           A(1,q)=1;
       end
end
A=repmat(A,N,1); %replicate the row to create a 2-d grating

% Alternative code for constructing the grating
    O=ones(N,FF*P);
    Z=zeros(N, P-FF*P);
    unit=[O Z];
    A=repmat(unit,1,N/P); %replicate to create a 1-d grating

%Observing the grating output in the far-field
	E=fftshift(fft2(A)); %fftshift is used to re-order the terms in their natural order
	IN=(abs(E)/(N*N)).*(abs(E)/(N*N));      % Calculating intensity
	figure (1)
	colormap(gray); %colormap(gray) is used to display greyscale image
	imagesc(A);% imagesc is used to display a high constrast image
figure (2)
colormap(gray); 
imagesc(IN);
