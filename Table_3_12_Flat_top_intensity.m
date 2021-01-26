% I, J  will be available since defined as global variables
% if memory was cleared, their values must be entered
 
%creation of image plane co-ordinates for  a square
S=2;   %size of square at image plane is 2S
stepx=2*S/J;
stepy=2*S/I;
X=-S:stepx:S;
Y=-S:stepy:S;
[xsq,ysq]=meshgrid(X,Y);
xsq=flipud(xsq);
ysq=flipud(ysq);
figure(2)
plot(xsq,ysq,'b.')
xlabel('X-direction  (arb. units)')
ylabel('Y-direction  (arb. units)')
 
clear X Y stepx stepy
 
bits=512;
stepx=2*S/bits;
 
indexx=-S:stepx:S;  %regular spaced points 
indexx=indexx(1:end-1);  %even number of points
%indexy=-Sy:stepy:Sy; ;  %regular spaced points 
%indexy=indexy(1:end-1);  %even number of points
[XS,YS] = meshgrid(indexx,indexx);   %creates grid of points with limits given by index
 
% Saves mesh details and variables in a file called square 
% for use by further programs
save square xsq ysq XS YS
