filename='bank25072014.txt';
%filename='world.txt';
outfile='vbank25072014.csv';
logfile='bank25072014_500_5_RMT_spec.txt';
filename_index='db.txt'; % ��� ����� ���������� ���� �������. � ������ ��� crp, lacasa ������ ��������� filename
docalcentr=0; % 0 - �� ������� ������� ��������� ����, 1 - �������
wind=500;
tstep=25;
doplot_ipr=1; % 0 - �� �������� ���. 1 - ��������.
doplot_spec=0; % ���������/���������� ������� ���� ��� Algebraic connectivity, graph energy, spectr delta,max lambda

%open_all_logs_template(logfile,docalcentr);
%open_logs_cmd_robustness_fun(logfile);
open_all_eigenvectors(logfile,filename_index,wind,tstep,doplot_ipr,doplot_spec);
