function open_eigenvectors2(eigenvectorsfile_adj,eigenvaluesfile_adj,eigenvectorsfile_lapl,eigenvaluesfile_lapl,filename,wind,tstep,logfile,doplot_ipr);
%newData1 = importdata(eigenvectorsfile_adj);
%newData1_lapl = importdata(eigenvectorsfile_lapl);

%[n,m]=size(newData1.data);
%N=m;
%Tmax=n/N;

newData2 = importdata(eigenvaluesfile_adj);
[n1,m1]=size(newData2.data);
n=m1;
newData2_lapl = importdata(eigenvaluesfile_lapl);
yreal=dlmread(filename);

logdata = importdata(logfile);

% 9 - alg connect, !!!17 - graph energy, 18 grspect delta 3 - max lambda
% (spectral radius)
mas_spectral_gap=[];
mas_t=[];
fp_adj=fopen(eigenvectorsfile_adj,'r');
sss=fgets(fp_adj);
fp_lapl=fopen(eigenvectorsfile_lapl,'r');
sss=fgets(fp_lapl);

mean_IPR_adj=[];
rozmah_IPR_adj=[];
mean_IPR_lapl=[];
rozmah_IPR_lapl=[];
mean_IPR_adj_x=[];
rozmah_IPR_adj_x=[];
mean_IPR_lapl_x=[];
rozmah_IPR_lapl_x=[];


%for i=0:Tmax
i=1;
while (~feof(fp_adj))
   %eigenvects=newData1.data(i*N+2:i*N+N+1,:);
   eigenvects=[];
   for j=1:n
       vectdata=fscanf(fp_adj,'%lf',n+1);
       eigenvects=[eigenvects;vectdata(2:n+1)'];
   end
   gr_sp_adj_vect=eigenvects;
   eigenvalues=newData2.data(i+2,:);
   gr_sp_adj=eigenvalues;
   figure('Position', [281,46,1024,768]);
   [sortedeigenvalues,eigenvorder]=sort(eigenvalues);
   spectral_gap=sortedeigenvalues(length(sortedeigenvalues))-sortedeigenvalues(length(sortedeigenvalues)-1);
   mas_spectral_gap=[mas_spectral_gap,spectral_gap];
   mas_t=[mas_t,wind+i*tstep+1];
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
  eigenvects=[];
   for j=1:n
       vectdata=fscanf(fp_lapl,'%lf',n+1);
       eigenvects=[eigenvects;vectdata(2:n+1)'];
   end
   gr_sp_vect=eigenvects;

   %eigenvects=newData1_lapl.data(i*N+2:i*N+N+1,:);
   eigenvalues=newData2_lapl.data(i+2,:);
   gr_sp=eigenvalues;
      
   subplot(4,4,[5,6]);
   [sortedeigenvalues_lapl,eigenvorder_lapl]=sort(eigenvalues);
   yreal_fragm=yreal(i*tstep+1:wind+i*tstep+1);
   for j=length(eigenvorder_lapl):-1:1
        cureigenvector=eigenvects(eigenvorder_lapl(j),:);
        hold on;
        plot(ones(size(cureigenvector))*sortedeigenvalues_lapl(eigenvorder_lapl(j)),cureigenvector,'LineStyle','none','Marker','.');
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
   t_measures=(max(1,i*tstep-wind):tstep:i*tstep)+wind;
   if (~isempty(t_measures))
   [axx,h1,h2]=plotyy(treal_fragm,yreal_fragm,t_measures,logdata.data(max(1,i-floor(wind/tstep)):i,8));
   set(axx,'FontSize', 12);
   set(axx(1),'XColor', 'k');
   set(axx(1),'YColor', 'k');
   set(axx(2),'XColor', 'k');
   set(axx(2),'YColor', 'k');
   set(h1,'LineWidth',2,'Color','k');
   set(h2,'LineWidth',2,'Color','r');
   title('Alg. conn. (Lapl)','FontSize', 14);
   subplot(4,4,[9,10,13,14]);
   [axx,h1,h2]=plotyy(treal_fragm,yreal_fragm,t_measures,logdata.data(max(1,i-floor(wind/tstep)):i,16));
   set(axx(1),'XColor', 'k');
   set(axx(1),'YColor', 'k');
   set(axx(2),'XColor', 'k');
   set(axx(2),'YColor', 'k');
   set(axx,'FontSize', 12);
   set(h1,'LineWidth',2,'Color','k');
   set(h2,'LineWidth',2,'Color','r');
   ylabel('graph energy (adj)','FontSize', 14);
   subplot(4,4,[11,12,15,16]);
   [axx,h1,h2]=plotyy(treal_fragm,yreal_fragm,mas_t(max(1,i-floor(wind/tstep)):i),mas_spectral_gap(max(1,i-floor(wind/tstep)):i));%logdata.data(max(1,i-wind):i,17));
   set(axx,'FontSize', 12);
   set(axx(1),'XColor', 'k');
   set(axx(1),'YColor', [1,1,1]);
   aaa=get(axx(1),'YTickLabel');
   set(axx(1),'YTickLabel',char(aaa*0));
   set(axx(2),'XColor', 'k');
   set(axx(2),'YColor', 'k');
   set(h1,'LineWidth',2,'Color','k');
   set(h2,'LineWidth',2,'Color','r');
   title('spectral gap (adj)','FontSize', 14);
   %subplot(4,4,[15,16]);
   %plot(logdata.data(max(1,i-wind):i,3));
   %title ('max lambda');
   end
   
   outfigfilename=strrep(eigenvectorsfile_adj,'.txt',sprintf('_fig%04d.bmp', i));
   saveas(gcf,outfigfilename,'bmp');
   outfigfilename=strrep(eigenvectorsfile_adj,'.txt',sprintf('_fig%04d.fig', i));
   saveas(gcf,outfigfilename,'fig');
   close(gcf);
       % ipr!!!
       if (doplot_ipr)
       figure;
       subplot(1,2,1);
       end
    [IPRmean_lapl,IPRrozm_lapl,IPRmean_lapl_x,IPRrozm_lapl_x]=plot_IPR(gr_sp,gr_sp_vect,doplot_ipr);
    mean_IPR_lapl=[mean_IPR_lapl,IPRmean_lapl];
    rozmah_IPR_lapl=[rozmah_IPR_lapl,IPRrozm_lapl];
    mean_IPR_lapl_x=[mean_IPR_lapl_x,IPRmean_lapl_x];
    rozmah_IPR_lapl_x=[rozmah_IPR_lapl_x,IPRrozm_lapl_x];
    if (doplot_ipr)

    title ('IPR laplace');
    subplot(1,2,2);
    end
    [IPRmean_adj,IPRrozm_adj,IPRmean_adj_x,IPRrozm_adj_x]=plot_IPR(gr_sp_adj,gr_sp_adj_vect,doplot_ipr);
    mean_IPR_adj=[mean_IPR_adj,IPRmean_adj];
    rozmah_IPR_adj=[rozmah_IPR_adj,IPRrozm_adj];
    mean_IPR_adj_x=[mean_IPR_adj_x,IPRmean_adj_x];
    rozmah_IPR_adj_x=[rozmah_IPR_adj_x,IPRrozm_adj_x];
    if (doplot_ipr)
   outfigfilename=strrep(eigenvectorsfile_adj,'.txt',sprintf('IPR_fig%04d.bmp', i));
   saveas(gcf,outfigfilename,'bmp');
   outfigfilename=strrep(eigenvectorsfile_adj,'.txt',sprintf('IPR_fig%04d.fig', i));
   saveas(gcf,outfigfilename,'fig');
   close(gcf);
    end
   i=i+1;
end


figure;
plot(mean_IPR_adj);
title('mean IPR adj y')
outfilename=strrep(logfile,'.txt','_mean_ipr_adj_y.txt');
dlmwrite(outfilename,mean_IPR_adj,'\n');
figure;
plot(rozmah_IPR_adj);
title('rozmah IPR adj y')
outfilename=strrep(logfile,'.txt','_rozmah_ipr_adj_y.txt');
dlmwrite(outfilename,rozmah_IPR_adj,'\n');

figure;
plot(mean_IPR_lapl);
title('mean IPR lapl y')
outfilename=strrep(logfile,'.txt','_mean_ipr_lapl_y.txt');
dlmwrite(outfilename,mean_IPR_lapl,'\n');
figure;
plot(rozmah_IPR_lapl);
title('rozmah IPR lapl y')
outfilename=strrep(logfile,'.txt','_rozmah_ipr_lapl_y.txt');
dlmwrite(outfilename,rozmah_IPR_lapl,'\n');

figure;
plot(mean_IPR_adj);
title('mean IPR adj y')
outfilename=strrep(logfile,'.txt','_mean_ipr_adj_y.txt');
dlmwrite(outfilename,mean_IPR_adj,'\n');
figure;
plot(rozmah_IPR_adj);
title('rozmah IPR adj y')
outfilename=strrep(logfile,'.txt','_rozmah_ipr_adj_y.txt');
dlmwrite(outfilename,rozmah_IPR_adj,'\n');

figure;
plot(mean_IPR_lapl_x);
title('mean IPR lapl x')
outfilename=strrep(logfile,'.txt','_mean_ipr_lapl_x.txt');
dlmwrite(outfilename,mean_IPR_lapl_x,'\n');
figure;
plot(rozmah_IPR_lapl_x);
title('rozmah IPR lapl x')
outfilename=strrep(logfile,'.txt','_rozmah_ipr_lapl_x.txt');
dlmwrite(outfilename,rozmah_IPR_lapl_x,'\n');
