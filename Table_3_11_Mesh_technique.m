%program creates a mesh of zones of equal energy for a Gaussian beam
%mesh is rotated away from axes to avoid zeros
clear all 
close all
% all units in mm
 
global I J R xh yh sigma
sigma=0.8;   % Gaussian spot size
R=1;  % radius of beam
%mesh co-ordinates
I=20;   %related to rows and therefore also to y coords
J=20;   %related to columns and therefore also to x coords
 
%N=(I*J);    %total number of zones
TP=pi*sigma*sigma/2;  %total power
P=(1-exp(-2*R*R/(sigma*sigma)))*TP;    %total power in radius R
rings=I/2;    %no of rings
Pring=P/rings;  %Power per ring
 
%calculating radii of rings
n=1:rings;
r=sigma*sqrt(0.5*log(1./(1-n.*Pring)));
 
%%add very small value for first ring (close to zero)
rad(1)=1e-10;

i=1:n(end);
rad(i+1)=r(i);
r=rad;
 
% number of zones in a ring-decided by angles chosen
angle_step=pi/I;
angle_shift=pi/100;
 
count1=0;
for theta=pi-angle_shift:-angle_step:-angle_shift,
count1=count1+1;
    if theta==(pi-angle_shift)
        xh=[r.*cos(theta)];
        yh=[r.*sin(theta)];
    else
    xh=[xh;r.*cos(theta)];
    yh=[yh;r.*sin(theta)];
end 
end
 
xh=flipud(xh');
yh=flipud(yh'); 

theta=(pi-angle_shift)+angle_step;
for count2=1:count1, 
    if theta==((pi-angle_shift)+angle_step)
        xh1=[r.*cos(theta)];
        yh1=[r.*sin(theta)];
    else
    xh1=[xh1;r.*cos(theta)];
    yh1=[yh1;r.*sin(theta)];
    end
    theta=theta+angle_step;
end
 
xh1=(xh1');
yh1=(yh1'); 
 
xh=[xh(1:end-1,:);xh1];
yh=[yh(1:end-1,:);yh1];
 
figure(1)
plot(xh,yh,'k.')
title('Locations of nodes of a Gaussian input')
xlabel('X-direction  (arb. units)')
ylabel('Y-direction  (arb. units)')
 
figure(2)
plot(xh',yh')
title('Annular rings of a Gaussian input')
xlabel('X-direction  (arb. units)')
ylabel('Y-direction  (arb. units)')
 
% Saves mesh details and variables in a file called GaussianMesh 
% for use by further programs
save GaussianMesh I J R sigma xh yh
