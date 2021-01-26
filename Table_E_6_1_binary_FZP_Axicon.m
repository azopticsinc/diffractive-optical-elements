%Multifunctional DOE – Circular grating and FZP – Modulo-2? phase addition method
clear; %Clear all memory

%Define grating parameters
N=1000;%Define matrix size
M=10;%Define number of half period zones of FZP
f=30000; %Define focal length of FZP
lambda=0.633;%Define wavelength 
A1=zeros(N,N); %Define a Matrix by assigning 0 to all elements
A2=zeros(N,N);
r=zeros(N,N);
r1=zeros(M);
Pr=38; %Define the period of the grating
FFr=0.5; %Define fill factors for x and y periodicity

%Construct the binary FZP and binary circular grating
for n=1:M;
    r1(n)=sqrt(n*f*lambda);
end
for n=1:2:M;
    for p=1:N;
        for q=1:N;
            r(p,q)=sqrt((p-N/2)*(p-N/2)+(q-N/2)*(q-N/2));
            if r(p,q)<N/2;
                if rem(r(p,q),Pr)<Pr*FFr;
                A1(p,q)=1;
                end
                if r(p,q) > r1(n) && r(p,q) < r1(n+1);
                A2(p,q)=1;
                end
            end
        end
    end
end
A3=exp(1i*pi*xor(A1,A2)); %XOR operation between A1 and A2

%Observation of the DOE
colormap(gray)
imagesc(angle(A3))
