%Axicon with two base angles
N=500;
Angle=1;
V=0.5;
lambda=0.632;
A=zeros(N,N);
B=zeros(N,N);

%%Design of a conical wave with two angles and a plane reference wave
for p=1:N;
    for q=1:N;
        r(p,q)=sqrt((p-N/2)*(p-N/2)+(q-N/2)*(q-N/2));
        if r(p,q)<125;
            A(p,q)=V*exp(1i*(r(p,q)/lambda)*tand(Angle*2)*2*pi);
        else
            A(p,q)=V*exp(1i*(((125/lambda)*tand(Angle*2)*2*pi)+(((r(p,q)-125)/lambda)*tand(Angle)*2*pi)));
        end
        B(p,q)=V*exp(1i*0);
    end
end
D=A+B;%Interference
I=abs(D).*abs(D);
colormap(gray)
imagesc(I)

%Binarize
I1=im2bw(I);%Binarize the matrix
Axicon=exp(1i*pi*I1);%Generate the FZP

