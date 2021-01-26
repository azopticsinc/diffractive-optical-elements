%% Iterative Fourier Transform Algorithm% 
clear; % Clear all memory

% Loading the target image 
N=500;% Matrix size
target=imread('File location'); % Read image from file 
m=size(target,1); % Size of the image
scale=N/m; % Estimate the necessary scaling factor
target=imresize(target,scale); % Resize image to the matrix size 
target=double(target); % Convert symbolic object to a numeric object
target=target/(max(max(target))); % Normalize matrix

% Defining DOE phase
DOE=2*pi*rand(N,N); % Generate a N x N matrix of random phase between 0 and 2?
ns=5;

% IFTA algorithm
for t=1:ns; %Iterate to calculate the phase value 
     DOEphase=exp(1i*DOE); 

     % Forward iteration
     iterf=fft2(DOEphase); 
     intf=abs(iterf); 
     angf=angle(iterf); 
     A=target.*exp(1i*angf); 

     % Backward iteration
      iterb=ifft2(A); 
     angb=angle(iterb); 
     DOE=angb; 
     error=target-intf/max(max(intf)); %Calculate error
     E=sum(sum(abs(error)))/(N*N); 
     if E<0.05;
         iteration=t;
         break
     end
end
%%
DOE1=zeros(N,N);
g=3;%Define the number of phase levels
delphase=2*pi/3;%Define the phase increment
for p=1:N;%Convert the greyscale phase profile into a 3-level phase profile
    for q=1:N;
        for n=1:g;
            if DOE(p,q)>-pi+(n-1)*delphase && DOE(p,q)<=-pi+(n)*delphase;
               DOE1(p,q)=(n-1)*delphase;
            end
        end
    end
end
%Verification of result
DOE2=exp(1i*DOE1); 
I=abs(fft2(DOE2)); %Calculate the Fourier Transform
colormap(gray)
imagesc(I)