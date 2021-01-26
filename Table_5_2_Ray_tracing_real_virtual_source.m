%%program to perform ray tracing from the real and virtual source to the FZP plane
u=5000;%Object distance
t=1050;%Thickness of glass plate
ng=1.5;%Refractive index of glass plate
na=1;%Refractive index of air
N=na/ng;%Refractive index ratio
U=u*u;

%To calculate the angles of rays and location of real/virtual source
for r=1:1000; 
    RR(r)=r*r;
    D(r)=(sqrt(1+(U/RR(r))));  
    A(r)=(((u-t)/u)*r);
    B(r)=asin(N/D(r));
    r1(r)=A(r)+t*tan(B(r));
    u1(r)=u*(r1(r)/r);
    R1(r)=sqrt(u*u+r*r)-u;
    R3(r)=sqrt((u-t)*(u-t)+r*r)-(u-t);
    R2(r)=sqrt(u1(r)*u1(r)+r1(r)*r1(r))-u1(r);
    delR(r)=R1(r)-R2(r);
    delu(r)=(u-u1(r));
    ratio(r)=r1(r)/r;
    theta(r)=r1(r)/u1(r);
    theta1(r)=r/u;
end

%Ray tracing
for r=1:100:1000;
    for x=1:u1(r)+1;
        y(x)=x-1;
        r11(x)=(x-1)*tan(theta(r));
    end
    plot(y+(u-u1(r)),r11,'k','LineWidth',1)
    hold on
end

for r=1:100:1000;
    for x=1:u+1;
        y(x)=x-1;
        r12(x)=(x-1)*tan(theta1(r));
    end
    plot(y,r12,'--k')
    hold on
end
