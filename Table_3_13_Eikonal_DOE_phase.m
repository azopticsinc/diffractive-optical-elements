%This program reads mesh data from the files GaussianMesh and square
%Phase over the hologram is calculated using the Eikonal technique
%Phase is calculated at a limited number of irregularly spaced data points
close all
clear all
load GaussianMesh
load square
bits=512;
x=xsq;
y=ysq;

%inputs
f=300;   %distance between input and output planes in mm
lambda=0.000633;  %wavelength in mm

figure(1)
plot(xh,yh,'r.')
title('Mesh over hologram plane')
 
%Eikonal retrieval
%delta psi
      del_psix=(x-xh)./f;
      del_psiy=(y-yh)./f;
 
%polynomial calculation to obtain phase of hologram
D=5;   %polynomial of degree D
M=(D+2)*(D+1)/2;
 
%calculates k and l values for each m value
count=0;
for k=0:D
   for l=0:D-k
      count=count+1;
      m=k*((2*D-k+3)/2)+l+1;
      indices(count,1)=m;
      indices(count,2)=k;
      indices(count,3)=l;
   end
end
 
for n=2:M
   for m=2:M
      m1=m-1;
      n1=n-1;
      c(n1,m1)=0;
      b(n1,1)=0;
      for j1=1:J+1
         for i1=1:I+1
            k=indices(m,2);
            k1=indices(n,2);
            l=indices(m,3);
            l1=indices(n,3);
            c(n1,m1)=c(n1,m1)+(k*k1*(xh(j1,i1)^(k+k1-2))*(yh(j1,i1)^(l+l1)))+(l*l1*(xh(j1,i1)^(k+k1))*(yh(j1,i1)^(l+l1-2)));
            b(n1,1)=b(n1,1)+del_psix(j1,i1)*k1*(xh(j1,i1)^(k1-1))*(yh(j1,i1)^l1)+del_psiy(j1,i1)*l1*(xh(j1,i1)^k1)*(yh(j1,i1)^(l1-1));
         end
      end
   end
end
 
%coefficients
a=c\b;
clear del_psix del_psiy x y
 
% eikonal -psi
for j1=1:J+1
   for i1=1:I+1
      psi(j1,i1)=0;
      for m=2:M
         psi(j1,i1)=psi(j1,i1)+a(m-1)*(xh(j1,i1)^indices(m,2))*(yh(j1,i1)^indices(m,3));
      end
   end
end
clear a b c
 
k=2*pi/lambda;
psi=k*psi%phase of hologram
colormap(gray)
figure(3)  
surf(xh,yh,psi)
title('Phase of hologram')
xlabel('X-cordinate in units of length')
ylabel('Y-cordinate in units of length')
zlabel('Phase (radians)')
%save phase psi xh yh
step=R*2/bits;
 
%------------------------------------------------------
%converting arrays to vectors – required for fit process
[m,n]=size(xh);
xh1=xh(:,1);
yh1=yh(:,1);
psi1=psi(:,1);
for i=2:n
    xh1=[xh1;xh(:,i)];
    yh1=[yh1;yh(:,i)];
    psi1=[psi1;psi(:,i)];
end
 
%saves data in files that can be retrieved by software that will carry out regression
% and generate coefficients to help generate phase at equidistant points
output=[xh1 yh1 psi1];
save save('testdata.txt', 'output', '-ascii')
%-----------------------------------------------------
index=-R:step:R;  %regular spaced points 
index=index(1:end-1);  %even number of points
[XH1,YH1] = meshgrid(index,index);   %creates grid of points with limits given by index
 %store regularly spaced points and phase for later use
save phase_circle XH1 YH1 sigma k f lambda xh1 yh1 psi1
