function outputA(x)
% This function generates the output intensity pattern for amplitude structures
%  DOE amplitude is the only function argument 

E=fftshift(fft2(x));
    I=abs(E).*abs(E);
    figure(1)
    colormap(gray)
    imagesc(x)
    figure(2)
    colormap(gray)
    imagesc(I)
end
