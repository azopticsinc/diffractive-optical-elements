% Fresnel diffraction of a DOE designed by Gerchberg-Saxton algorithm
% Use table 3.10 to obtain the “DOE phase” and save it as DOE
% Multiply the “DOE phase” with a lens function
%Defining all parameters and sampling
DOE1=exp(1i*DOE);
wsamp=1e-6;%sampling period
    x=-N/2:N/2-1;
    y=-N/2:N/2-1;
    [X,Y]=meshgrid(x*wsamp,y*wsamp);
    Rsamp=sqrt(X.^2+Y.^2);
    lambda=0.633e-6; %Wavelength
    Q=exp(-1i*(pi/(lambda*d))*(X.^2+Y.^2));
    DOE2=DOE1.*Q;
%Calculation of Fresnel diffraction pattern 
    m=1;
    n=1:m;
    zs2=0.05; % Propagation distance
    PPF=zeros(N,N,m);
    A1=zeros(N,N,m);
    E=zeros(N,N,m);
    Field1=zeros(100,m);
        for counter1=1:1:m;
            PPF(:,:,counter1)=exp(1i*pi/(lambda*zs2(counter1)).*Rsamp.*Rsamp); % Parabolic phase factor
            A1(:,:,counter1)=DOE2.*PPF(:,:,counter1); %Multiply the axilens function with the parabolic phase factor
            E(:,:,counter1)=abs((fft2((A1(:,:,counter1))))); %Calculate Fourier Transform
            % imagesc(E(:,:,counter1)); title (zs2)
            % pause(1.0)
        end

