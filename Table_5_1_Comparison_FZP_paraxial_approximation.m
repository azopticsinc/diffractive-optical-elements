%%program to compare the FZPs designed with and without paraxial %%approximation  
%%program to compare the FZPs designed with and without paraxial %%approximation
u=5000; % Object distance
v=30000; % Image distance
l=0.632; % Lambda-wavelength

%To calculate the angles of rays and location of real/virtual source
    n=1:200 ; 
    a=n.*n.*l*l+2.*n.*l*(u+v)+2*u*v;
    r=sqrt(((a(n).*a(n))-4*u*u*v*v)./(4.*(a(n)+u*u+v*v)));%Radius of zones
    A=(4.*n.*n.*l*l+8.*n*l*u-4.*r(n).*r(n));
    B=(4.*n.^3*l^3+12.*n.*n.*l*l*u+8.*n.*l*u*u-8.*r(n).*r(n).*n.*l-8.*r(n).*r(n).*u);
    C=(n.^4.*l.^4+4.*n.*n.*l*l*u*u+4.*n.^3*l^3*u-4.*r(n).*r(n)*u*u-4.*r(n).*r(n).*n.*n*l*l-8.*r(n).*r(n).*n*l*u);
    v1=(-B(n)+sqrt(B(n).*B(n)-4.*A(n).*C(n)))./(2.*A(n));%Image distance
    the1=atan(r(n)./v1(n));%Angle theta
    v2=u.*(r(n).*r(n)-n.*n.*l*l)./(2.*n.*l*u+n.*n.*l*l-r(n).*r(n));%
    the2=atan(r(n)./v2(n));%Angle theta
 
%Ray tracing
    for m=1:100; %Ray tracing with 100 points on each ray
        n=m*2;
            for p=1:11;
                v3(p)=(p-1)*3000;
                rr1(p,n)=(v1(n)-v3(p))*tan(the1(n));
                rr2(p,n)=(v2(n)-v3(p))*tan(the2(n));
            end
    end

%Display results
n=10:10:200; % Ray tracing display
plot(v3,rr1(:,n),'k','LineWidth',1)
hold on
plot(v3,rr2(:,n),'b','LineWidth',1)
