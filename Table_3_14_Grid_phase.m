% This program calculates the phase over a grid
%loads uniformly spaced x and y coordinates  
%calculates coefficients using Matlab fit 
 
clear all 
close all
 
load phase_circle  %contains regularly spaced grid points
 
choice = input('Enter 1 to generate fit coefficients in matlab and 2 to upload coefficients from other programme: ');
 
if choice == 1
    ft = fittype('poly55');
    dataFit = fit([xh1,yh1],psi1, ft);
    coeff1=coeffvalues(dataFit);
    coeffN=coeffnames(ft);
    R=confint(dataFit);
 
    c=size(coeff1);
    psi1=0;
 
    for count=1:c(2)
    
        coeffI=coeffN(count);
        coeffI=coeffI{:};
        m=str2double(coeffI(2));
        n=str2double(coeffI(3));
        psi1=psi1+coeff1(count).*(XH1.^m).*(YH1.^n);
    
    end
    
elseif choice ==2
    
    %coefficients obtained with  R=1, sigma=0.8 and I=J=20, S=2 from a data handling software such as excel
    %SQUARE
    a0  =   0.106394007
    a1  =   -0.836150168
    a2  =   0.020604165
    a3  =   17.61722947
    a4  =   15.83427723
    a5  =   -7.266911537
    a6  =   -4.752015829
 
 % Calculating phase at regularly spaced points
    psi1=a0+a1*XH1+a2*YH1+a3*XH1.^2+a4*YH1.^2+a5*XH1.^4+a6*YH1.^4;
end
 
% Output
figure(1)
surf(XH1,YH1,psi1)
title('Phase over DOE')
 %______________________________________________________%
% to simulate output intensity
i=sqrt(-1);
g=exp(-((XH1).^2+(YH1).^2)/(sigma^2));  %Gaussian beam
amp1=exp(i*psi1).*g;   %Amplitude just after hologram
sing=find(isnan(amp1));  %locates singularities
amp1(sing)=zeros(size(sing));  %replaces singularities with zeros
 
amp1=amp1.*exp(i*(k/(2*f))*(XH1.^2+YH1.^2));
figure(2)
colormap(gray)
imagesc(amp1.*conj(amp1))
contour(XH1,YH1,amp1.*conj(amp1))
title('Intensity just after DOE')
xlabel('X-direction')
ylabel('Y-direction')
 
amp2=fft2((amp1));
amp2=fftshift(amp2);
 
figure(3)
colormap(gray)
contour(abs(amp2)/max(max(abs(amp2))))
title('Output intensity - Gaussian to square')
xlabel('X-direction')
ylabel('Y-direction')
