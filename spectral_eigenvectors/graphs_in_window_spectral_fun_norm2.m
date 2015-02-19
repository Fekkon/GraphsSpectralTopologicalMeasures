function graphs_in_window_spectral_fun_norm2(filename, wind, tstep, thr_fr, crp_emb_dimm, crp_delay, crp_epsilon, logfile, graph_type, docalcentr, p, k, beta, n_pref, m_pref,doplot_ipr,rmt_multiplier,filename_index,type_normalize);
%!!!! graphs_spectrum_cmd_ts - ��� ����, � graphs_spectrum_cmd_model - ���
%������� (��������� ������)!!!
%filename='SP500_1983_05112013.txt';
y=dlmread(filename);
n=length(y);
%wind=250;
% tstep=5;
% thr_fr=0.5;
% crp_emb_dimm=1;
% crp_delay=1;
% crp_epsilon=0.5; %0.1 - Marwan default
% logfile='SP500_1983_05112013_hvg_spec_250_5.txt';
% graph_type=3; % 1 - crp, 2 - visibility graph, 3 - horizontal visibility graph
% docalcentr=0; % 0 - �� ������� ������� ��������� ����, 1 - �������
%graph_type=2;%visibility
% 20130601 Graph Entropy
Q=5;
types=round((1:wind+1)/(wind/(Q-1))+1);% ������ ������� ����� (������ �� ����� ������ ���� ������� � ������-�� ������)
Nrunmax=3;% ���-�� �������� ���������
Nd=10;% ������� �������� ������ ��� �����ﳿ ��������
   % l=logspace(log(d_min)/log(10),log(Dmax)/log(10),Nd);
   %l=linspace(-14,55,30);
 % l=linspace(0.2,9,Nd);
skip_complex_measures=1;
% end 20130601 Graph Entropy

% �������� ������ �������� ��� �����. ���
% � ������ ���������� ��� ��������� - ���� �����. (��������, ���� "�������")
% mas_diam=[];
% � ������ ��������� ��� �� ������ - ������, ��������������� ���� ���
% ������� ���� ��� �����. ��������, ������� ������ (��� ������ ������� -
% ���� �������)
% ������ �������� (�������)
mas_degr=[];
% �������������� �������������� �������� (����, ���, �������)
mas_maxdegr=[];
mas_mindegr=[];
mas_meandegr=[];

mas_graphSpectrum=[];
mas_graphSpectrum_delta=[];
mas_min_graphSpectrum=[];
mas_max_graphSpectrum=[];
mas_mean_graphSpectrum=[];

mas_algebraic_connectivity = [];

mas_Alg_Connect=[];
mas_fiedler_vector = [];
mas_min_fiedler_vector=[];
mas_max_fiedler_vector=[];
mas_mean_fiedler_vector=[];

mas_eigencentrality = [];
mas_min_eigencentrality=[];
mas_max_eigencentrality=[];
mas_mean_eigencentrality=[];
mas_eigence_maxlambda=[];
mas_max_lambda=[];
mas_graph_energy = [];
mas_graph_energy_lapl_norm =[];
mas_graph_energy_lapl_nonorm =[];
mas_graph_energy_positive = [];
% �������� ���-�����. ������ ����������.
% ��� ���������� ����� ���, ����� �������� �����. ���������. \t - ������
% ���������, ����������� ������ ������� �������
fp=fopen(logfile,'a');
fprintf(fp,'filename\tt\tmax node degree\tmin node degree\tmean node degree\tmaxGrSpectr\tminGrSpec\tmeanGrSpec\tAlgConnect\tmaxFiedVectn\tminFiedVectn\tmeanFiedVectn\tMinEigence\tMaxEigence\tMeanEigence\tGraph_ener\tgraphsSpectralDelta_wrongforlaplacian\n');
fclose(fp);
model_type=graph_type;
for i=1:tstep:n-wind % ������� ����
    i
    n-wind
    t_beg=i;
    t_end=i+wind;
    % ���������� ������� ��������� (��� ���, ��� ���� ���������)
    Adj=data_to_graph(filename, model_type, t_beg, t_end, wind, p, k, beta, n_pref, m_pref, crp_emb_dimm, crp_delay, crp_epsilon, rmt_multiplier);
    Adj_n = laplacian_matrix(Adj, type_normalize);
    
    % ���������� ���� �������� (����� ����� �������� ���� �������, ������� 
    % ���������� ���� ����� ��� ���������� ��� ������ ��� ��������� ���)
    % [d,dij]=diameter(Adj);
    % d=0;
    % mas_diam=[mas_diam;d]; % ���������� ������������ �������� � ������

    % ���������� ���� �������� ������ (�� ����� - ������)
     degr=degrees(Adj);
     mas_degr=[mas_degr;degr];% ���������� ����� ������� ��� ������ �������
     maxdegr=max(degr);% ���������� ��������� �������� ������ (���������� ���������� ���� �� ������ ���������)
     mas_maxdegr=[mas_maxdegr;maxdegr]; % ���������� ��������� � �������
     mindegr=min(degr); % ���������� ��������
     mas_mindegr=[mas_mindegr;mindegr]; % ���������� (���������� ��� ����, � ��������� �������)
     meandegr=mean(degr); % ������� ��������
     mas_meandegr=[mas_meandegr;meandegr]; % ���������� �������� ��������...
    % � ����� ������ �������� ���������� ���������� ����������� � ���-����
    % ��� ���������� ����� ���, ����� �����. ���������� (��. fprintf ����
    % ������ 41 ���� ���������, �������� ��������� ����� ��� (��� ���� %d �
    % ��� ����������, ������ ������� ��������� � ����� ������ ����������
    % fprintf
    [gr_sp,gr_sp_vect]=graph_spectrum_unsort(Adj, type_normalize);
    [gr_sp_adj,gr_sp_adj_vect]=graph_spectrum_adjmatr_unsort(Adj);
    eigenvectorsfile=strrep(logfile,'.txt','_laplace_eigenvectors.txt');
    save_eigenvectors(eigenvectorsfile,i,gr_sp_vect);
    eigenvectorsfile=strrep(logfile,'.txt','_adj_eigenvectors.txt');
    save_eigenvectors(eigenvectorsfile,i,gr_sp_adj_vect);    
    mas_graphSpectrum=[mas_graphSpectrum;gr_sp];
    min_gr_sp=min(gr_sp);
    mas_min_graphSpectrum=[mas_min_graphSpectrum,min_gr_sp];
    max_gr_sp=max(gr_sp);
    mas_max_graphSpectrum=[mas_max_graphSpectrum,max_gr_sp];
    mean_gr_sp=mean(gr_sp);
    mas_mean_graphSpectrum=[mas_mean_graphSpectrum,mean_gr_sp];
    
    % 20130717 eigenv(max)-eigenv(max2)  ������ �� �������� ����� ����
    gr_sp_sort=sort(gr_sp);
    gr_sp_delta=gr_sp_sort(2)-gr_sp_sort(1);
    mas_graphSpectrum_delta=[mas_graphSpectrum_delta,gr_sp_delta];
    % end 20130717
    Alg_Connect=algebraic_connectivity(Adj, type_normalize);
    mas_Alg_Connect=[mas_Alg_Connect;Alg_Connect];
    
    FiedVect=fiedler_vector(Adj);
    mas_fiedler_vector=[mas_fiedler_vector;FiedVect];
    min_FiedVect=min(FiedVect);
    mas_min_fiedler_vector=[mas_min_fiedler_vector,min_FiedVect];
    max_FiedVect=max(FiedVect);
    mas_max_fiedler_vector=[mas_max_fiedler_vector,max_FiedVect];
    mean_FiedVect=mean(FiedVect);
    mas_mean_fiedler_vector=[mas_mean_fiedler_vector,mean_FiedVect];
    
    Eigence=eigencentrality(Adj);
    mas_eigencentrality=[mas_eigencentrality;Eigence];
    min_Eigence=min(Eigence); 
    mas_min_eigencentrality=[mas_min_eigencentrality,min_Eigence];
    max_Eigence=max(Eigence);
    mas_max_eigencentrality=[mas_max_eigencentrality,max_Eigence];
    mean_Eigence=mean(Eigence);
    mas_mean_eigencentrality=[mas_mean_eigencentrality,mean_Eigence];
    Lambda=maxlambda(Adj);
    max_Lambda=max(Lambda);
    mas_max_lambda=[mas_max_lambda,max_Lambda];
    
    
    Graph_ener=graph_energy(Adj);
    mas_graph_energy =[mas_graph_energy ;Graph_ener];
    
    Graph_ener_lapl_norm=graph_energy2(Adj_n);
    mas_graph_energy_lapl_norm =[mas_graph_energy_lapl_norm ;Graph_ener_lapl_norm];
    
    Graph_ener_lapl_nonorm=graph_energy3(laplacian_matrix(Adj,0));
    mas_graph_energy_lapl_nonorm =[mas_graph_energy_lapl_nonorm ;Graph_ener_lapl_nonorm];

    Graph_ener_positive=graph_energy_positive(Adj);
    mas_graph_energy_positive =[mas_graph_energy_positive ;Graph_ener_positive];

    fp=fopen(logfile,'a');
    fprintf(fp,'%s\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\n',filename,i,maxdegr,mindegr,meandegr,min_gr_sp,max_gr_sp,mean_gr_sp,Alg_Connect,min_FiedVect,max_FiedVect,mean_FiedVect,min_Eigence,max_Eigence,mean_Eigence,max_Lambda,Graph_ener,gr_sp_delta );
    fclose(fp);
    % ���������� ��������� ��� ����������� � ������� save_logs_template. ���
    % ���������� ����� ��������� ����, �����: �������� � �������� ����
    % ������� (��������� ������) ����� ����, � ����� ����������������� ����
    % ������� (������� ��� �������������� save_logs_template.m  �������� �������� edit save_logs_template
    % ���������� ���������� �� ����������� ��. � save_logs_template.m
    save_logs_template (logfile,i,degr,gr_sp,FiedVect,Eigence,gr_sp_adj);
end

% ����� �� ����� ���������� ����. ��� ����� ���� ����� ����������� ����� ��
% ��������, �� ��������� ��� ����������-������� � �������.
% figure;
% plot(mas_diam); % ���� ������ mas_diam ����� ��� ������ �������
% ('diameter'); %���� - ��� ��������� �������
% outfile=strrep(filename,'.txt','_diameter.txt');% ��� ����� ���������� ����, ���� ���������� ������ ��� ��� 
% dlmwrite(outfile,mas_diam,'\n');% ��� ���� ����������������� ��� ����������



% ��� ���������� ��� - ����������, �� ��������� 3 ������� ���
% �������������: ��������, ������� � ������� �������� ��������� ����
figure;
plot(mas_degr);
title('node degree dynamics');

figure;
plot(mas_maxdegr);
title('max node degree dynamics');
outfile=strrep(filename,'.txt','_maxdegr.txt');
dlmwrite(outfile,mas_maxdegr,'\n');
figure;
plot(mas_mindegr);
title('min node degree dynamics');
outfile=strrep(filename,'.txt','_mindegr.txt');
dlmwrite(outfile,mas_mindegr,'\n');
figure;
plot(mas_meandegr);
title('mean node degree dynamics');
outfile=strrep(filename,'.txt','_meandegr.txt');
dlmwrite(outfile,mas_meandegr,'\n');

figure;
plot(mas_graphSpectrum);
title('graphSpectrum');

figure;
plot(mas_max_graphSpectrum);
title('max graphSpectrum');
outfile=strrep(filename,'.txt','_max_graphSpectrum.txt');
dlmwrite(outfile,mas_max_graphSpectrum,'\n');

figure;
plot(mas_min_graphSpectrum);
title('min graphSpectrum');
outfile=strrep(filename,'.txt','_min_graphSpectrum.txt');
dlmwrite(outfile,mas_min_graphSpectrum,'\n');

figure;
plot(mas_mean_graphSpectrum);
title('mean graphSpectrum');
outfile=strrep(filename,'.txt','_mean_graphSpectrum.txt');
dlmwrite(outfile,mas_mean_graphSpectrum,'\n');

figure;
plot(mas_graphSpectrum_delta);
title('GraphSpectrum delta');
outfile=strrep(filename,'.txt','_graphSpectrum_delta.txt');
dlmwrite(outfile,mas_graphSpectrum_delta,'\n');


figure;
plot(mas_Alg_Connect);
title('algebraic connectivity');
outfile=strrep(filename,'.txt','_algebraic connectivity.txt');
dlmwrite(outfile,mas_Alg_Connect,'\n');

figure;
plot(mas_fiedler_vector);
title('fiedler vector');

figure;
plot(mas_max_fiedler_vector);
title('max fiedler vector');
outfile=strrep(filename,'.txt','_max_fiedler_vector.txt');
dlmwrite(outfile,mas_max_fiedler_vector,'\n');

figure;
plot(mas_min_fiedler_vector);
title('min fiedler vector');
outfile=strrep(filename,'.txt','_min_fiedler_vector.txt');
dlmwrite(outfile,mas_min_fiedler_vector,'\n');

figure;
plot(mas_mean_fiedler_vector);
title('mean fiedler vector');
outfile=strrep(filename,'.txt','_mean_fiedler_vector.txt');
dlmwrite(outfile,mas_mean_fiedler_vector,'\n');

figure;
plot(mas_eigencentrality);
title('eigencentrality');

figure;
plot(mas_max_eigencentrality);
title('max eigencentrality');
outfile=strrep(filename,'.txt','_max_eigencentrality.txt');
dlmwrite(outfile,mas_max_eigencentrality,'\n');

figure;
plot(mas_min_eigencentrality);
title('min eigencentrality');
outfile=strrep(filename,'.txt','_min_eigencentrality.txt');
dlmwrite(outfile,mas_min_eigencentrality,'\n');

figure;
plot(mas_mean_eigencentrality);
title('mean eigencentrality');
outfile=strrep(filename,'.txt','_mean_eigencentrality.txt');
dlmwrite(outfile,mas_mean_eigencentrality,'\n');

figure;
plot(mas_max_lambda);
title('max lambda');
outfile=strrep(filename,'.txt','_max_lambda.txt');
dlmwrite(outfile,mas_max_lambda,'\n');

figure;
plot(mas_graph_energy);
title('graph energy');
outfile=strrep(filename,'.txt','_graph energy.txt');
dlmwrite(outfile,mas_graph_energy,'\n');

figure;
plot(mas_graph_energy_lapl_norm);
title('graph energy laplacian normalized');
outfile=strrep(filename,'.txt','_graph energy_lapl_norm.txt');
dlmwrite(outfile,mas_graph_energy_lapl_norm,'\n');

figure;
plot(mas_graph_energy_lapl_nonorm);
title('graph energy laplacian non-normalized');
outfile=strrep(filename,'.txt','_graph energy_lapl_nonorm.txt');
dlmwrite(outfile,mas_graph_energy_lapl_nonorm,'\n');

figure;
plot(mas_graph_energy_positive);
title('graph energy adj positive');
outfile=strrep(filename,'.txt','_graph energy_positive.txt');
dlmwrite(outfile,mas_graph_energy_positive,'\n');


% ������ ������ ���������, �������� � �������� ��������� ���� �� �����
% �������

% figure;
% plot(mas_max_closeness,'k');
% hold on;
% plot(mas_min_closeness,'k');
% plot(mas_mean_closeness,'r');
% title('closeness');
% outfile=strrep(filename,'.txt','_MaxCloseness.txt');
% dlmwrite(outfile,mas_max_closeness,'\n');
% outfile=strrep(filename,'.txt','_MinCloseness.txt');
% dlmwrite(outfile,mas_min_closeness,'\n');
% outfile=strrep(filename,'.txt','_MeanCloseness.txt');
% dlmwrite(outfile,mas_mean_closeness,'\n');

% ����� ���������� ������� open_all_logs, ������� ��������� �����������
% ������� ��������� ��� � ������� �������. ��� ���������� ����� ���������
% ���, ���������� �������� ��� ����� ���� ������������������ ����������,
% ����������� �����������.
open_all_logs_template(logfile,docalcentr);
open_all_eigenvectors(logfile,filename,wind,tstep,doplot_ipr);
open_logs_cmd_robustness_fun(logfile);