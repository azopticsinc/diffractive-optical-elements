% Fresnel diffraction of an axilens
clear; %Clear all memory

%Defining all parameters and sampling
N=500; %Matrix size
lambda=0.633e-6; %Wavelength
wsamp=1e-6;%sampling period
    x=-N/2:N/2-1;
    y=-N/2:N/2-1;
    [X,Y]=meshgrid(x*wsamp,y*wsamp);
    Rsamp=sqrt(X.^2+Y.^2);
    f0=0.005;%Focal length
    delf=0.003;%Focal depth
    R=10^-3;%Radius of the axilens

%Design of axilens
    f=(f0+(delf/R)*sqrt(X.^2+Y.^2));%Focal length calculation 
    FZA=exp(-1i*(pi/(lambda))*((X.^2+Y.^2)./f));%Phase profile of Axilens

%Calculation of Fresnel diffraction pattern 
    m=100;
    n=1:m;
    zs2=0.003+(0.005/m).*n; % Propagation distance
    PPF=zeros(N,N,m);
    A1=zeros(N,N,m);
    E=zeros(N,N,m);
    Field1=zeros(100,m);
    for counter1=1:1:m;
        PPF(:,:,counter1)=exp(1i*pi/(lambda*zs2(counter1)).*Rsamp.*Rsamp); % Parabolic phase factor
        A1(:,:,counter1)=FZA.*PPF(:,:,counter1); %Multiply the axilens function with  parabolic phase factor
        E(:,:,counter1)=abs(fftshift(fft2(fftshift(A1(:,:,counter1))))); %Calculate Fourier Transform
        % imagesc(E(201:300,201:300,counter1));
        % pause(1.0)
        Field1(:,counter1)=E(N/2+1,201:300,counter1); %Accumulate the intensity profile
       end
colormap(gray)
imagesc(Field1)