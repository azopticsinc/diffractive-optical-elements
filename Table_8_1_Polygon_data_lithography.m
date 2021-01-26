%Generating polygon data for lithography
N=2000; % Size of the DOE
A=zeros(N,N); % Define matrices
B=zeros(N,N);
M=1000; % Define the number of points in the circle
theta1=zeros(M);
P=100; % Define period of the grating
p1=0; % Initialize the iteration variable
for r=1:300; % Generate point data of every circle
   for theta=1:M;
       if rem(r,P)<P/2;
            theta1(theta)=((2*pi)/M)*theta;
            p1=p1+1;
            X1(p1)=(r-1)*cos(theta1(theta));
            Y1(p1)=(r-1)*sin(theta1(theta));
       end
   end
end
fid = fopen('C:\Vijayakumar\cgrating.txt','wt');%Open text file
for s=1:p1;
    fprintf(fid,'Draw Line %d,%d',X1(s),Y1(s));
    fprintf(fid,'\n');
end
fclose(fid);%Close text file
