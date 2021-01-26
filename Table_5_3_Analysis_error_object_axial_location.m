%%program to analyze the aberration due to error in object location in z-direction

% Input Parameters
u1=5000; % Object distance in micrometers
v=30000; % Image distance in micrometers
l=0.632; % Wavelength in micrometers
t=1050; % Thickness of glass substrate in micrometers
na=1; % Refractive index of air
ng=1.5; % Refractive index of glass
n=1; % Zone number
a=n*n*l*l+2*n*l*(u1+v)+2*u1*v;
r=sqrt(((a*a)-4*u1*u1*v*v)/(4*(a+u1*u1+v*v))); %Radius of first zone before aberration correction
theta=atan(r/u1);
rr=r*((u1-t)/u1);
r1=rr+t*tan(asin(na/ng*(sin(atan(r/u1)))));
u2=u1*(r1/r);
a1=n*n*l*l+2*n*l*(u2+v)+2*u2*v;
rr=sqrt(((a1*a1)-4*u2*u2*v*v)/(4*(a1+u2*u2+v*v))); % Radius of first zone after aberration correction

%Error calculation
s=1:1000 ;
u4=s-501;
u=5000+u4(s);
u3=u(s).*(r1/r);
b=(4*n*n*l*l+8*n*l.*u3(s)-4*rr*rr);
c=(4*n^3*l^3+12*n*n*l*l.*u3(s)+8*n*l.*u3(s).*u3(s)-8*rr*rr*n*l-8*rr*rr.*u3(s));
d=(n^4*l^4+4*n*n*l*l.*u3(s).*u3(s)+4*n^.3*l^3.*u3(s)-4*rr*rr.*u3(s).*u3(s)-4*rr*rr*n*n*l*l-8*rr*rr*n*l.*u3(s));
v1=(-c(s)+sqrt(c(s).*c(s)-4.*b(s).*d(s)))./(2.*b(s));  
ve=abs(v1(s)-v);

%Display results
plot(u4,v1/1000)
hold on
plot(u4,ve/1000,'r')
