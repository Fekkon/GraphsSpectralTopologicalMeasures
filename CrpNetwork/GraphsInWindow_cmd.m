% Graph from time series (canonical graphs, model graphs, time series: CRP, vg, hvg, RMT matrices)
filename='dj2008.txt';
%filename='world.txt';
outfile='dj2008.csv';
logfile='dj2008_vg_500_5_topological.txt';
filename_index='dj2008_index.txt'; % имя файла временного ряда индекса. В случае мер crp, lacasa должен равняться filename

model_type=8; % 1- line, 2 - circle, 3 - star, 4 - Erdos Renyi, 5 - Small world, 6 - prefattach
  % 7 - crp, 8 - visibility graph, 9 - horizontal vizibility, 10 - RMT matrix
  
wind=500;
tstep=5;

n_rand=30; % для случайных моделей! кол-во экспериментов

% p for Erdos Renyi
    p=0.3;
% Parameters for small world: k, beta
    k= 10; % mean degree
    beta=0.5; % ot 0 do 1
% Parameters for preferential attachment: n and m
    % n - final (desired) number of vertices, m - # edges to attach at every step
    %wind=n_rand;
    n_pref = wind;
    m_pref = 7; % кол-во ребер, добавляемых каждый раз.
% Parameters for CRP
crp_emb_dimm=1;
crp_delay=1;
crp_epsilon=0.7; %0.1 - Marwan default
crp_multiplier=1.1; % multiplier to calculate treshold for crp graph (treshold=mean(distance)*crp_multiplier)

thr_fr=0.5; % используется в smooth_diameter(...)
docalcentr=1; % 0 - не считать сложные локальные меры, 1 - считать
skip_complex_measures=1;
measure_type=1; % 1-topological, 2-spectral
doplot_ipr=0; % 0 - не рисовать ипр. 1 - рисовать.
if (measure_type==1)
    graphs_in_window_topologic_fun(filename,wind,tstep,thr_fr,crp_emb_dimm, crp_delay, crp_epsilon, logfile, model_type, docalcentr, skip_complex_measures, p, k, beta, n_pref, m_pref, crp_multiplier);
else
    graphs_in_window_spectral_fun(filename, wind, tstep, thr_fr, crp_emb_dimm, crp_delay, crp_epsilon, logfile, model_type, docalcentr, p, k, beta, n_pref, m_pref,doplot_ipr, crp_multiplier,filename_index);
end
