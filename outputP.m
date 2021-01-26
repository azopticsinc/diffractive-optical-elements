function outputP(x)
% This function generates the output intensity pattern for phase structures
%  DOE amplitude is the only function argument 

E=fftshift(fft2(x));
    I=abs(E).*abs(E);
    figure(1)
    colormap(gray)
    imagesc(angle(x))
    figure(2)
    colormap(gray)
    imagesc(I)
end
