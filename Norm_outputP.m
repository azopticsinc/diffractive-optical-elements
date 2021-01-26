function Norm_outputP(x, N)
% This function generates the output intensity pattern with intensity normalized for phase DOEs
% function arguments (required when calling the function) are 
% DOE amplitude  (x) and matrix size (N) 

E=fftshift(fft2(x)); %fftshift is used to re-order the terms in their natural order
IN=(abs(E)/(N*N)).*(abs(E)/(N*N));      % Calculating intensity
figure (1)
colormap(gray); %colormap(gray) is used to display greyscale image
imagesc(angle(x));% imagesc is used to display a high constrast image
figure (2)
colormap(gray); 
imagesc(IN);
