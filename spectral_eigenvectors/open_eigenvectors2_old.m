function open_eigenvectors2(eigenvectorsfile_adj,eigenvaluesfile_adj,eigenvectorsfile_lapl,eigenvaluesfile_lapl,filename,wind,tstep,logfile);
newData1 = importdata(eigenvectorsfile_adj);
newData1_lapl = importdata(eigenvectorsfile_lapl);

[n,m]=size(newData1.data);
N=m;
Tmax=n/N;


newData2 = importdata(eigenvaluesfile_adj);
[n1,m1]=size(newData2.data);
newData2_lapl = importdata(eigenvaluesfile_lapl);
yreal=dlmread(filename);

logdata = importdata(logfile);

% 9 - alg connect, !!!17 - graph energy, 18 grspect delta 3 - max lambda
% (spectral radius)
for i=0:Tmax
   eigenvects=newData1.data(i*N+2:i*N+N+1,:);
   eigenvalues=newData2.data(i+2,:);
   figure('Position', [281,46,1024,768]);
   [sortedeigenvalues,eigenvorder]=sort(eigenvalues);
   yreal_fragm=yreal(i*tstep+1:wind+i*tstep+1);
   subplot(4,4,[1,2]);
   for j=length(eigenvorder):-1:1
        cureigenvector=eigenvects(eigenvorder(j),:);
        hold on;
        plot(ones(size(cureigenvector))*sortedeigenvalues(eigenvorder(j)),cureigenvector,'LineStyle','none','Marker','.');
        % [sortedeigenvectors,eigenvectorder]=sort(cureigenvector);
        % firstvectorcomponents=(sortedeigenvectors<treshold);
        % firstvectorcomponents=firstvectorcomponents(1);
        % connectednumbers=eigenvectorder(1:firstvectorcomponents);
   end

   xlabel('eigval','FontSize',14);
   ylabel('Adj eigvec','FontSize',14);
   set(gca,'FontSize',12);
   eigenvects=newData1_lapl.data(i*N+2:i*N+N+1,:);
   eigenvalues=newData2_lapl.data(i+2,:);
      
   subplot(4,4,[5,6]);
   [sortedeigenvalues_adj,eigenvorder_adj]=sort(eigenvalues);
   yreal_fragm=yreal(i*tstep+1:wind+i*tstep+1);
   for j=length(eigenvorder_adj):-1:1
        cureigenvector=eigenvects(eigenvorder_adj(j),:);
        hold on;
        plot(ones(size(cureigenvector))*sortedeigenvalues_adj(eigenvorder_adj(j)),cureigenvector,'LineStyle','none','Marker','.');
        % [sortedeigenvectors,eigenvectorder]=sort(cureigenvector);
        % firstvectorcomponents=(sortedeigenvectors<treshold);
        % firstvectorcomponents=firstvectorcomponents(1);
        % connectednumbers=eigenvectorder(1:firstvectorcomponents);
   end
   
   xlabel('eigval','FontSize',14);
   ylabel('Lapl. eigvec','FontSize',14);
   set(gca,'FontSize',12);
   
   treal_fragm=i*tstep+1:wind+i*tstep+1;

   %plot(yreal_fragm);
   %grid on;
   subplot(4,4,[3,4,7,8]);
   t_measures=(max(1,i-wind):i)+wind;
   if (~isempty(t_measures))
   [axx,h1,h2]=plotyy(treal_fragm,yreal_fragm,t_measures,logdata.data(max(1,i-wind):i,8));
   set(axx,'FontSize', 12);
   set(axx(1),'XColor', 'k');
   set(axx(1),'YColor', 'k');
   set(axx(2),'XColor', 'k');
   set(axx(2),'YColor', 'k');
   set(h1,'LineWidth',2,'Color','k');
   set(h2,'LineWidth',2,'Color','r');
   title('Algebraic connectivity','FontSize', 14);
   subplot(4,4,[9,10,13,14]);
   [axx,h1,h2]=plotyy(treal_fragm,yreal_fragm,t_measures,logdata.data(max(1,i-wind):i,16));
   set(axx(1),'XColor', 'k');
   set(axx(1),'YColor', 'k');
   set(axx(2),'XColor', 'k');
   set(axx(2),'YColor', 'k');
   set(axx,'FontSize', 12);
   set(h1,'LineWidth',2,'Color','k');
   set(h2,'LineWidth',2,'Color','r');
   ylabel('graph energy','FontSize', 14);
   subplot(4,4,[11,12,15,16]);
   [axx,h1,h2]=plotyy(treal_fragm,yreal_fragm,t_measures,logdata.data(max(1,i-wind):i,17));
   set(axx,'FontSize', 12);
   set(axx(1),'XColor', 'k');
   set(axx(1),'YColor', [1,1,1]);
   aaa=get(axx(1),'YTickLabel');
   set(axx(1),'YTickLabel',char(aaa*0));
   set(axx(2),'XColor', 'k');
   set(axx(2),'YColor', 'k');
   set(h1,'LineWidth',2,'Color','k');
   set(h2,'LineWidth',2,'Color','r');
   title('spectr delta','FontSize', 14);
   %subplot(4,4,[15,16]);
   %plot(logdata.data(max(1,i-wind):i,3));
   %title ('max lambda');
   end
   
   outfigfilename=strrep(eigenvectorsfile_adj,'.txt',sprintf('_fig%04d.bmp', i));
   saveas(gcf,outfigfilename,'bmp');
   close(gcf);
end

