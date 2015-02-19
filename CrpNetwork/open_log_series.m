function open_log_series(fileToRead1,measurename,docalcentr)
%IMPORTFILE(FILETOREAD1)
%  Imports data from the specified file
%  FILETOREAD1:  file to read

%  Auto-generated by MATLAB on 19-May-2013 20:59:12

% Import the file
newData1 = importdata(fileToRead1);

if (nargin<3)
    docalcentr=1;
end

% Create new variables in the base workspace from those fields.
vars = fieldnames(newData1);
for i = 1:length(vars)
    assignin('base', vars{i}, newData1.(vars{i}));
end

[n,m]=size(newData1.data);
Nbars=50;
m=2;
L=1;
l=5;
st=1;
figure;
mas_degreeDistrCoeff=[];
mas_sh_entr=[];
mas_ap_entr=[];
mas_permu_entr=[];
mas_hurst=[];
mas_spectral_radius=[]; % spectral radius - max eigenvalue for adj matrix
mas_spectral_gap=[]; % spectral gap - difference between two max max eigenvalues for adj matrix
mas_eigenRatio=[]; % eigen ratio - lambda2/lambdan, where lambdai - sorted �� ����������� ������� - ����������
mas_spectral_moment1=[];
mas_spectral_moment2=[];
mas_spectral_moment3=[];
mas_spectral_moment4=[];
mas_MFDFA_width = [];
mas_MFDFA_max = [];


for i=2:n
    Values=newData1.data(i,:);
    if (docalcentr)
        sh_entr=shannon_entr(Values);
        permu_entr=permen(Values,m,L);
        ap_entr=ApEn(Values,l,st);
        hurst=localDFA_a(Values);
        % ----- MFDFA
        %    calculateMFDFA(degr,20,400,[-3:0.1:-0.1 0.1:0.1:3],2,'nRatio','100','90');
        try
            [S,FqS,Q]=MFDFA(Values,20,400,[-3:0.1:-0.1 0.1:0.1:3],2,'nRatio','100');
            [Hq,TAUq,Q2]=MFDFAHTau(S,FqS,Q);
            [XResTemp,YResTemp]=MFDFAAlphaFTAUSpline(Q2,TAUq,'90');
            mas_MFDFA_width = [mas_MFDFA_width; (max(XResTemp)-min(XResTemp))];
            [maxMFDFA,imaxMFDFA] = max(YResTemp);
            mas_MFDFA_max = [mas_MFDFA_max; XResTemp(imaxMFDFA(1))];
        catch
            mas_MFDFA_width = [mas_MFDFA_width; NaN];
            mas_MFDFA_max = [mas_MFDFA_max; NaN];
        end
    else
        sh_entr=0;%shannon_entr(Values);
        permu_entr=0;%permen(Values,m,L);
        ap_entr=0;%ApEn(Values,l,st);
        hurst=0;%localDFA_a(Values);
        mas_MFDFA_width = [mas_MFDFA_width; 0];
        mas_MFDFA_max = [mas_MFDFA_max; 0];
    end
    
    mas_sh_entr=[mas_sh_entr,sh_entr];
    
    mas_permu_entr=[mas_permu_entr,permu_entr];
    
    mas_ap_entr=[mas_ap_entr,ap_entr];
    
    mas_hurst=[mas_hurst,hurst];
    raspr=hist(Values,Nbars);
    raspr=raspr/(sum(raspr));
    hold on;
    minV=min(Values);
    maxV=max(Values);
    stepV=(maxV-minV)/Nbars;
    plot3(ones(size(raspr))*i,minV+stepV*(1:length(raspr)),raspr);
    nonzeroindices=find(raspr~=0);
    YY=log(raspr);
    XX=log(minV+stepV*(1:length(raspr)));
    XX=XX(nonzeroindices);
    YY=YY(nonzeroindices);
    coefs=polyfit(XX,YY,1);
    a=coefs(1);
    b=coefs(2);
    mas_degreeDistrCoeff=[mas_degreeDistrCoeff,a];
    if (0)
        figure;
        plot(XX,YY);
        hold on;
        plot(XX,a*XX+b,'r');
    end
    if (strcmp(measurename,'Graph spectrum'))
        % c������ ��, ��� ���� ����� ������ ����������
        ValuesSort=sort(Values);
        mas_eigenRatio=[mas_eigenRatio, ValuesSort(2)/ValuesSort(length(ValuesSort))];
    else
        mas_eigenRatio=[mas_eigenRatio,0];
    end
    if (strcmp(measurename,'Graph spectrum adjacency matrix'))
        % c������ ��, ��� ���� ����� ������ ������� ���������.
        mas_spectral_radius=[mas_spectral_radius,max(Values)]; % spectral radius - max eigenvalue for adj matrix
        ValuesSort=-sort(-Values);
        mas_spectral_gap=[mas_spectral_gap,ValuesSort(1)-ValuesSort(2)]; % spectral gap - difference between two max max eigenvalues for adj matrix
        
    else
        mas_spectral_radius=[mas_spectral_radius,0];
        mas_spectral_gap=[mas_spectral_gap,0];
    end
    if ((strcmp(measurename,'Graph spectrum')==1)||(strcmp(measurename,'Graph spectrum adjacency matrix')==1))
        moment001=mean(Values);
        mas_spectral_moment1=[mas_spectral_moment1,mean(Values)];
        mas_spectral_moment2=[mas_spectral_moment2,mean((Values-moment001).^2)];
        mas_spectral_moment3=[mas_spectral_moment3,mean((Values-moment001).^3)];
        mas_spectral_moment4=[mas_spectral_moment4,mean((Values-moment001).^4)];
    end
end
xlabel('time,days','FontSize',14);
ylabel(measurename,'FontSize',14);
zlabel('P','FontSize',14);
outfilename=strrep(fileToRead1,'.txt',['_' measurename '_P.fig']);
saveas(gcf,outfilename,'fig');
outfilename=strrep(fileToRead1,'.txt',['_' measurename '_P.jpg']);
saveas(gcf,outfilename,'jpg');
close(gcf);

if (strcmp(measurename,'degree')==1)
figure;
plot(mas_degreeDistrCoeff);
set(gca,'FontSize',14);
h=ylabel([measurename,' Degree distr coeff']);
set(h,'FontSize',14);

h=xlabel('time, days');
set(h,'FontSize',14);

outfilename=strrep(fileToRead1,'.txt',['_' measurename '_DegreeDistrPower.fig']);
saveas(gcf,outfilename,'fig');
outfilename=strrep(fileToRead1,'.txt',['_' measurename '_DegreeDistrPower.jpg']);
saveas(gcf,outfilename,'jpg');
close(gcf);
outfilename=strrep(fileToRead1,'.txt',['_' measurename '_DegreeDistrPower.txt']);
dlmwrite(outfilename,mas_degreeDistrCoeff,'\n');
end


figure;
plot(mas_sh_entr);
h=ylabel([measurename ' Shannon entr']);
set(h,'FontSize',14);

h=xlabel('time,days');
set(h,'FontSize',14);

outfilename=strrep(fileToRead1,'.txt',['_' measurename '_ShEntr.fig']);
saveas(gcf,outfilename,'fig');
outfilename=strrep(fileToRead1,'.txt',['_' measurename '_ShEntr.jpg']);
saveas(gcf,outfilename,'jpg');
close(gcf);
outfilename=strrep(fileToRead1,'.txt',['_' measurename '_ShEntr.txt']);
dlmwrite(outfilename,mas_sh_entr,'\n');

figure;
plot(mas_ap_entr);
h=ylabel([measurename ' Sample entr']);
set(h,'FontSize',14);

h=xlabel('time,days');
set(h,'FontSize',14);

outfilename=strrep(fileToRead1,'.txt',['_' measurename '_ApEntr.fig']);
saveas(gcf,outfilename,'fig');
outfilename=strrep(fileToRead1,'.txt',['_' measurename '_ApEntr.jpg']);
saveas(gcf,outfilename,'jpg');
close(gcf);
outfilename=strrep(fileToRead1,'.txt',['_' measurename '_ApEntr.txt']);
dlmwrite(outfilename,mas_ap_entr,'\n');

figure;
plot(mas_permu_entr);
h=ylabel([measurename ' Permutation entr']);
set(h,'FontSize',14);

h=xlabel('time,days');
set(h,'FontSize',14);

outfilename=strrep(fileToRead1,'.txt',['_' measurename '_PermEntr.fig']);
saveas(gcf,outfilename,'fig');
outfilename=strrep(fileToRead1,'.txt',['_' measurename '_PermEntr.jpg']);
saveas(gcf,outfilename,'jpg');
close(gcf);
outfilename=strrep(fileToRead1,'.txt',['_' measurename '_PermEntr.txt']);
dlmwrite(outfilename,mas_permu_entr,'\n');


figure;
plot(mas_hurst);
h=ylabel([measurename ' Hurst']);
set(h,'FontSize',14);

h=xlabel('time,days');
set(h,'FontSize',14);

outfilename=strrep(fileToRead1,'.txt',['_' measurename '_Hurst.fig']);
saveas(gcf,outfilename,'fig');
outfilename=strrep(fileToRead1,'.txt',['_' measurename '_Hurst.jpg']);
saveas(gcf,outfilename,'jpg');
close(gcf);
outfilename=strrep(fileToRead1,'.txt',['_' measurename '_Hurst.txt']);
dlmwrite(outfilename,mas_hurst,'\n');


figure;
mesh(newData1.data(2:end,:));
h=ylabel('time,days');
set(h,'FontSize',14);

h=xlabel('node number');
set(h,'FontSize',14);

h=zlabel(measurename);
set(h,'FontSize',14);

outfilename=strrep(fileToRead1,'.txt',['_' measurename '_orig.fig']);
saveas(gcf,outfilename,'fig');
outfilename=strrep(fileToRead1,'.txt',['_' measurename '_orig.jpg']);
saveas(gcf,outfilename,'jpg');
close(gcf);

sorted_data=sort(newData1.data(2:end,:),2);
figure;
mesh(sorted_data);
h=ylabel('time,days');
set(h,'FontSize',14);

h=xlabel('node number');
set(h,'FontSize',14);

h=zlabel(measurename);
set(h,'FontSize',14);

outfilename=strrep(fileToRead1,'.txt',['_' measurename '_sort.fig']);
saveas(gcf,outfilename,'fig');
outfilename=strrep(fileToRead1,'.txt',['_' measurename '_sort.jpg']);
saveas(gcf,outfilename,'jpg');
close(gcf);

if (strcmp(measurename,'Graph spectrum')==1)
    figure;
    maxsize=size(sorted_data,2);
    for i=maxsize:-1:maxsize-5
        hold on;
        h=plot(sorted_data(:,i));
        set(h,'LineWidth');
    end
    h=ylabel([measurename,' graph spectrum']);
    set(h,'FontSize',14);
    
    h=xlabel('time,days');
    set(h,'FontSize',14);
    outfilename=strrep(fileToRead1,'.txt',['_' measurename '_spectra.fig']);
    saveas(gcf,outfilename,'fig');
    outfilename=strrep(fileToRead1,'.txt',['_' measurename '_spectra.jpg']);
    saveas(gcf,outfilename,'jpg');
    close(gcf);
    figure;
    h=plot(mas_eigenRatio);
    set(h,'LineWidth');
    h=ylabel([measurename, ' EigenRatio']);
    set(h,'FontSize',14);
    outfilename=strrep(fileToRead1,'.txt',['_' measurename '_spectraEigenRatio.fig']);
    saveas(gcf,outfilename,'fig');
    outfilename=strrep(fileToRead1,'.txt',['_' measurename '_spectraEigenRatio.jpg']);
    saveas(gcf,outfilename,'jpg');
    close(gcf);
    outfilename=strrep(fileToRead1,'.txt',['_' measurename '_spectraEigenRatio.txt']);
    dlmwrite(outfilename,mas_eigenRatio,'\n');
end

if (strcmp(measurename,'Graph spectrum adjacency matrix')==1)
    figure;
    maxsize=size(sorted_data,2);
    for i=maxsize:-1:maxsize-5
        hold on;
        h=plot(sorted_data(:,i));
        set(h,'LineWidth');
    end
    h=ylabel([measurename ' graph spectrum']);
    set(h,'FontSize',14);
    
    h=xlabel('time,days');
    set(h,'FontSize',14);
    outfilename=strrep(fileToRead1,'.txt',['_' measurename '_adj_spectra.fig']);
    saveas(gcf,outfilename,'fig');
    outfilename=strrep(fileToRead1,'.txt',['_' measurename '_adj_spectra.jpg']);
    saveas(gcf,outfilename,'jpg');
    close(gcf);

    figure;
    h=plot(mas_spectral_radius);
    set(h,'LineWidth');
    h=ylabel([measurename ' spectral radius']);
    set(h,'FontSize',14);
    outfilename=strrep(fileToRead1,'.txt',['_' measurename '_spectra_spectral_radius.fig']);
    saveas(gcf,outfilename,'fig');
    outfilename=strrep(fileToRead1,'.txt',['_' measurename '_spectra_spectral_radius.jpg']);
    saveas(gcf,outfilename,'jpg');
    close(gcf);
    outfilename=strrep(fileToRead1,'.txt',['_' measurename '_spectra_spectral_radius.txt']);
    dlmwrite(outfilename,mas_spectral_radius,'\n');
    figure;
    h=plot(mas_spectral_gap);
    set(h,'LineWidth');
    h=ylabel([measurename ' spectral gap']);
    set(h,'FontSize',14);
    outfilename=strrep(fileToRead1,'.txt',['_' measurename '_spectra_spectral_gap.fig']);
    saveas(gcf,outfilename,'fig');
    outfilename=strrep(fileToRead1,'.txt',['_' measurename '_spectra_spectral_gap.jpg']);
    saveas(gcf,outfilename,'jpg');
    close(gcf);
    outfilename=strrep(fileToRead1,'.txt',['_' measurename '_spectra_spectral_gap.txt']);
    dlmwrite(outfilename,mas_spectral_gap,'\n');
    
end

if ((strcmp(measurename,'Graph spectrum')==1)||(strcmp(measurename,'Graph spectrum adjacency matrix')==1))
    figure;
    h=plot(mas_spectral_moment1);
    set(h,'LineWidth');
    h=ylabel([measurename, ' spectral moment1']);
    set(h,'FontSize',14);
    outfilename=strrep(fileToRead1,'.txt',['_' measurename '_spectra_spectral_moment1.fig']);
    saveas(gcf,outfilename,'fig');
    outfilename=strrep(fileToRead1,'.txt',['_' measurename '_spectra_spectral_moment1.jpg']);
    saveas(gcf,outfilename,'jpg');
    close(gcf);
    outfilename=strrep(fileToRead1,'.txt',['_' measurename '_spectra_spectral_moment1.txt']);
    dlmwrite(outfilename,mas_spectral_moment1,'\n');
    
    figure;
    h=plot(mas_spectral_moment2);
    set(h,'LineWidth');
    h=ylabel([measurename ' spectral moment2']);
    set(h,'FontSize',14);
    outfilename=strrep(fileToRead1,'.txt',['_' measurename '_spectra_spectral_moment2.fig']);
    saveas(gcf,outfilename,'fig');
    outfilename=strrep(fileToRead1,'.txt',['_' measurename '_spectra_spectral_moment2.jpg']);
    saveas(gcf,outfilename,'jpg');
    close(gcf);
    outfilename=strrep(fileToRead1,'.txt',['_' measurename '_spectra_spectral_moment2.txt']);
    dlmwrite(outfilename,mas_spectral_moment2,'\n');

        figure;
    h=plot(mas_spectral_moment3);
    set(h,'LineWidth');
    h=ylabel([measurename, ' spectral moment3']);
    set(h,'FontSize',14);
    outfilename=strrep(fileToRead1,'.txt',['_' measurename '_spectra_spectral_moment3.fig']);
    saveas(gcf,outfilename,'fig');
    outfilename=strrep(fileToRead1,'.txt',['_' measurename '_spectra_spectral_moment3.jpg']);
    saveas(gcf,outfilename,'jpg');
    close(gcf);
    outfilename=strrep(fileToRead1,'.txt',['_' measurename '_spectra_spectral_moment3.txt']);
    dlmwrite(outfilename,mas_spectral_moment3,'\n');

        figure;
    h=plot(mas_spectral_moment4);
    set(h,'LineWidth');
    h=ylabel([measurename, ' spectral moment4']);
    set(h,'FontSize',14);
    outfilename=strrep(fileToRead1,'.txt',['_' measurename '_spectra_spectral_moment4.fig']);
    saveas(gcf,outfilename,'fig');
    outfilename=strrep(fileToRead1,'.txt',['_' measurename '_spectra_spectral_moment4.jpg']);
    saveas(gcf,outfilename,'jpg');
    close(gcf);
    outfilename=strrep(fileToRead1,'.txt',['_' measurename '_spectra_spectral_moment4.txt']);
    dlmwrite(outfilename,mas_spectral_moment4,'\n');
end

figure;
plot(mas_MFDFA_width);
hold on;
plot(mas_MFDFA_max);
legend('MFDFA width','MFDFA max');
h=ylabel([measurename ' MFDFA']);
set(h,'FontSize',14);

h=xlabel('time,days');
set(h,'FontSize',14);

outfilename=strrep(fileToRead1,'.txt',['_' measurename '_MFDFA.fig']);
saveas(gcf,outfilename,'fig');
outfilename=strrep(fileToRead1,'.txt',['_' measurename '_MFDFA.jpg']);
saveas(gcf,outfilename,'jpg');
close(gcf);
outfilename=strrep(fileToRead1,'.txt',['_' measurename '_MFDFA_max.txt']);
dlmwrite(outfilename,mas_MFDFA_max,'\n');
outfilename=strrep(fileToRead1,'.txt',['_' measurename '_MFDFA_width.txt']);
dlmwrite(outfilename,mas_MFDFA_width,'\n');
