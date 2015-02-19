function open_logs_cmd_robustness_fun(logfile);
% функция вычисляет меры робастности по спектру собственных значений,
% сохраненном в лог-файле.
% 3.6. Number of spanning trees
% е=1/n*product_{i=2}^n{\lambda_i}
% 3.7. Effective graph resistance
% 
% R=n*sum_{i=2}^n{1/lambda_i}
% 3.8. Natural connectivity
% _lambda=ln(S/n)=ln(sum_i=1^n{e^\lambda_i}/n)
% 
% 3.9 Percolation limit
% vertex degrees \delta_1, \delta_2, ..., \delta_n,
% <k_0>=(\delta_1+ \delta_2+ ...+ \delta_n)/n
% <k_0^2>=(\delta_1^2+ \delta_2^2+ ...+ \delta_n^2)/n
% p_c=1-1/(<k_0^2>/<k_0>-1)



% logfile='C:\Users\Андрей\Dropbox\SpectralEmbeddingDistribs\dax_04_spec_250_1.txt';
eigenvectorsfile=strrep(logfile,'.txt','_laplace_eigenvectors.txt');
eigenvaluesfile=strrep(logfile,'.txt','_GrSpec.txt');% laplace
eigenvaluesfile_adj=strrep(logfile,'.txt','_GrSpec_adjmatr.txt'); %adj

newData2 = importdata(eigenvaluesfile);

[n1,m1]=size(newData2.data);
Tmax=n1;
N=m1;

newData2adj = importdata(eigenvaluesfile_adj);


mas_num_spaning_trees=[]
mas_effective_resistance=[];
mas_natural_connectivity=[];
%mas_percolation_limit=[];
for i=1:Tmax-1
   eigenvalues=newData2.data(i+1,2:N);
   sorted_eigenvects=sort(eigenvalues);
   num_spaning_trees=prod(sorted_eigenvects(2:length(sorted_eigenvects)))/(N-1);
   mas_num_spaning_trees=[mas_num_spaning_trees,num_spaning_trees];
   effective_resistance=(N-1)*sum(1./sorted_eigenvects(2:length(sorted_eigenvects)));
   mas_effective_resistance=[mas_effective_resistance,effective_resistance];
   eigenvalues_adj=newData2adj.data(i+1,2:N);
   sorted_eigenvects_adj=sort(eigenvalues_adj);
   natural_connectivity=log(sum(exp(sorted_eigenvects_adj))/length(sorted_eigenvects_adj));
   mas_natural_connectivity=[mas_natural_connectivity,natural_connectivity];
   %percolation_limit=
   %mas_percolation_limit=[mas_percolation_limit,percolation_limit];
   
   
end

pos_filename=find(logfile=='\');
pos_filename=pos_filename(length(pos_filename));
logfile=logfile(pos_filename+1:length(logfile));

figure;
plot(mas_num_spaning_trees,'LineWidth',2);
set(gca,'FontSize',14);
xlabel('time, days','FontSize',14);
ylabel('# of spanning trees','FontSize',14);
outfile=strrep(logfile,'.txt','_num_spaning_trees.fig');
saveas(gcf,outfile,'fig');
outfile=strrep(logfile,'.txt','_num_spaning_trees.png');
saveas(gcf,outfile,'png');
outfile=strrep(logfile,'.txt','_num_spaning_trees.txt');
dlmwrite(outfile,mas_num_spaning_trees,'\n');
close(gcf);

figure;
plot(mas_effective_resistance,'LineWidth',2);
set(gca,'FontSize',14);
xlabel('time, days','FontSize',14);
ylabel('effective resistance','FontSize',14);
outfile=strrep(logfile,'.txt','_effective_resistance.fig');
saveas(gcf,outfile,'fig');
outfile=strrep(logfile,'.txt','_effective_resistance.png');
saveas(gcf,outfile,'png');
outfile=strrep(logfile,'.txt','_effective_resistance.txt');
saveas(gcf,outfile,'png');
dlmwrite(outfile,mas_effective_resistance,'\n');
close(gcf);

figure;
plot(mas_natural_connectivity,'LineWidth',2);
set(gca,'FontSize',14);
xlabel('time, days','FontSize',14);
ylabel('natural connectivity','FontSize',14);
outfile=strrep(logfile,'.txt','_natural_connectivity.fig');
saveas(gcf,outfile,'fig');
outfile=strrep(logfile,'.txt','_natural_connectivity.png');
saveas(gcf,outfile,'png');
outfile=strrep(logfile,'.txt','_natural_connectivity.txt');
dlmwrite(outfile,mas_natural_connectivity,'\n');
close(gcf);