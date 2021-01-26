%Multilevel SPP
clear;%Clear all memory

%Define SPP parameters
N=500; % Matrix size
L=1; % Topological charge number
g=5; % Number of phase levels
delphase=(L*2*pi)/g; % Phase increment

%Constructing the SPP
x=1:N;
y=1:N;
[X,Y]=meshgrid(x,y);
theta=atan2((X-N/2),(Y-N/2));
r=sqrt((X-N/2).*(X-N/2)+(Y-N/2).*(Y-N/2));
A1=L*(theta)+L*pi;
A1(r>30)=0;
for n=1:g;
    for p=1:N;%
        for q=1:N;
               if A1(p,q) > (delphase*(n-1)) && A1(p,q) <= (delphase*n)
                  A1(p,q) = exp(1i*delphase*(n-1));
               end
        end
    end
end

%Observation of the diffraction pattern
E=fftshift(fft2(A1)); %fftshift to re-order the terms to the natural order
I=abs(E).*abs(E);
figure(1)
colormap(gray); 
imagesc(angle(A1))          
figure(2)
colormap(gray);
imagesc(I);
