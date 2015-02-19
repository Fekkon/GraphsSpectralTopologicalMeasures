function save_eigenvectors(curlogfile,i,measure);
% функция сохранения каждой конкретной меры (строки в соотв. лог-файле)
[n,m]=size(measure);
fp=fopen(curlogfile,'a');
if (i==1)
    fprintf(fp,'t\t');
    for j=1:m-1
        fprintf(fp,'%d\t',j);
    end
    fprintf(fp,'%d\n',n);
end
for ii=1:n
    fprintf(fp,'%d\t',ii);
    for j=1:m-1
        fprintf(fp,'%d\t',measure(ii,j));
    end
    fprintf(fp,'%d\n',measure(ii,n));
end
fclose(fp);
