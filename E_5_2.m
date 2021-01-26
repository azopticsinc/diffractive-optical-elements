%%program to calculate back transverse focal aberration
u=5000;
v=30000;
l=0.632;
na=1;
ng=1.5;
for n=1:1000;
    a(n)=n*n*l*l+2*n*l*(u+v)+2*u*v;
    r(n)=sqrt(((a(n)*a(n))-4*u*u*v*v)/(4*(a(n)+u*u+v*v)));
    if r(n)>=500 && r(n)<=700;
       t=3000;
    else
       t=1000;
    end
    theta(n)=atan(r(n)/u);
    rr(n)=r(n)*((u-t)/u);
    r1(n)=rr(n)+t*tan(asin(na/ng*(sin(atan(r(n)/u)))));
    u1(n)=u*(r1(n)/r(n));
    a1(n)=n*n*l*l+2*n*l*(u1(n)+v)+2*u1(n)*v;
    rr(n)=sqrt(((a1(n)*a1(n))-4*u1(n)*u1(n)*v*v)/(4*(a1(n)+u1(n)*u1(n)+v*v)));
    b(n)=(4*n*n*l*l+8*n*l*u1(n)-4*rr(n)*rr(n));
    c(n)=(4*n^3*l^3+12*n*n*l*l*u1(n)+8*n*l*u1(n)*u1(n)-8*rr(n)*rr(n)*n*l-8*rr(n)*rr(n)*u1(n));
    d(n)=(n^4*l^4+4*n*n*l*l*u1(n)*u1(n)+4*n^3*l^3*u1(n)-4*rr(n)*rr(n)*u1(n)*u1(n)-4*rr(n)*rr(n)*n*n*l*l-8*rr(n)*rr(n)*n*l*u1(n));
    v2(n)=(-c(n)+sqrt(c(n)*c(n)-4*b(n)*d(n)))/(2*b(n));  
    the1(n)=atan(rr(n)/v2(n));
end
plot(the1)
