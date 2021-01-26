%Generating line data for lithography
N=2000; % Size of the matrix
A=zeros(N,N); % Define matrices
B=zeros(N,N);
P=100; % Define period of the grating
p1=0; % Initialize line number
for q=1:N;
       if rem(q,P)<=P/2;
           p1=p1+1;
           X1(p1)=1;
           Y1(p1)=q;
           X2(p1)=N;
           Y2(p1)=q;
      end
end
fid = fopen('File location','wt');%Open a text file
for s=1:p1;
    fprintf(fid,'Draw Line %d,%d',X1(s),Y1(s));
    fprintf(fid,'\n');
    fprintf(fid,'          %d,%d',X2(s),Y2(s));
    fprintf(fid,'\n');
end
fclose(fid);%Close the text file
