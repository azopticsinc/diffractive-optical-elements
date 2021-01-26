%2D Amplitude grating
%Clear all memory
clear;
%Define Matrix size
N=2000;
M=50;
%Define a Matrix by assigning 0 to all elements
A1=zeros(N,N);
A2=zeros(N,N);
A3=zeros(N,N);
r=zeros(N,N);
%Define the period of the grating
f=30000;
Px=50;
Py=50;
FFx=0.5;
FFy=0.5;
R=100;
lambda=0.633;
%Define fill factors for x and y periodicity
FFr=0.5;
FFx=0.5;
FFy=0.5;
%Scan element by element using two for loops 
%Use reminder function 'rem' to construct the grating
x=1:N;
y=1:N;
[X,Y]=meshgrid(x,y);
r=sqrt((X-N/2).*(X-N/2)+(Y-N/2).*(Y-N/2));
A1(rem(Y,Py)<Py*FFy)=1;
A2(rem(X,Px)<Px*FFx)=1;
for n=1:M;
     n1(n)=(n-1)/2;
    r(n)=sqrt(n1(n)*n1(n)*lambda*lambda+2*n1(n)*f*lambda);
    r1(n)=R+r(n);
    if R > r(n)
    r2(n)=R-r(n);
    end
end
for n=1:2:M;
for p=1:N;
    for q=1:N;
        r(p,q)=sqrt((p-N/2)*(p-N/2)+(q-N/2)*(q-N/2));
        if r(p,q)<N/2;
        if r(p,q) > r1(n) && r(p,q) < r1(n+1);
            A3(p,q)=1;
        end
        end
    end
end
end
%XOR operation between A1 and A2
A=exp(1i*pi*xor(A3,xor(A1,A2)));
A(r>N/2)=0;
%Observation of the DOE
colormap(gray)
imagesc(angle(A));
