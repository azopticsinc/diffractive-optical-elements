%% Iterative Fourier Transform Algorithm% 
clear; % Clear all memory

% Loading the target image 
N=500;% Matrix size
target=imread(‘File location’); % Read image from file 
m=size(target,1); % Size of the image
scale=N/m; % Estimate the necessary scaling factor
target=imresize(target,scale); % Resize image to the matrix size 
target=double(target); % Convert symbolic object to a numeric object
target=target/(max(max(target))); % Normalize matrix

% Defining DOE phase
DOE=2*pi*rand(N,N); % Generate a N x N matrix of random phase between 0 and 2?
s=5;

% IFTA algorithm
for t=1:s; %Iterate to calculate the phase value 
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
