function open_eigenvectors(eigenvectorsfile,eigenvaluesfile,filename,wind,tstep,logfile);
newData1 = importdata(eigenvectorsfile);


[n,m]=size(newData1.data);
N=m;
Tmax=n/N;

newData2 = importdata(eigenvaluesfile);

[n1,m1]=size(newData2.data);
newData2 = importdata(eigenvaluesfile);
yreal=dlmread(filename);

logdata = importdata(logfile);

% 9 - alg connect, 14 - graph energy, 15 grspect delta 3 - max lambda
% (spectral radius)
for i=0:Tmax
   eigenvects=newData1.data(i*N+2:i*N+N+1,:);
   eigenvalues=newData2.data(i+2,:);
   figure;
   [sortedeigenvalues,eigenvorder]=sort(eigenvalues);
   yreal_fragm=yreal(i*tstep+1:wind+i*tstep+1);
   subplot(3,4,[1,2,5,6]);
   for j=length(eigenvorder):-1:1
        cureigenvector=eigenvects(eigenvorder(j),:);
        hold on;
        plot(ones(size(cureigenvector))*sortedeigenvalues(eigenvorder(j)),cureigenvector,'LineStyle','none','Marker','.');
        % [sortedeigenvectors,eigenvectorder]=sort(cureigenvector);
        % firstvectorcomponents=(sortedeigenvectors<treshold);
        % firstvectorcomponents=firstvectorcomponents(1);
        % connectednumbers=eigenvectorder(1:firstvectorcomponents);
   end
   subplot(3,4,[9,10,11,12]);
   plot(yreal_fragm);
   grid on;
   subplot(3,4,3);
   plot(logdata.data(max(1,i-wind):i,9));
   title ('Algebraic connectivity');
   subplot(3,4,4);
   plot(logdata.data(max(1,i-wind):i,14));
   title ('graph energy');
   subplot(3,4,7);
   plot(logdata.data(max(1,i-wind):i,15));
   title ('spectr delta');
   subplot(3,4,8);
   plot(logdata.data(max(1,i-wind):i,3));
   title ('max lambda');
   
   outfigfilename=strrep(eigenvectorsfile,'.txt',sprintf('_fig%04d.bmp', i));
   saveas(gcf,outfigfilename,'bmp');
   close(gcf);
end

