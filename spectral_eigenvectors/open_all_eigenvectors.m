function open_all_eigenvectors(logfile,filename,wind,tstep,doplot_ipr);
eigenvectorsfile_lapl=strrep(logfile,'.txt','_laplace_eigenvectors.txt');
eigenvaluesfile_lapl=strrep(logfile,'.txt','_GrSpec.txt');
%open_eigenvectors(eigenvectorsfile_lapl,eigenvaluesfile_lapl,filename,wind,tstep,logfile);
eigenvectorsfile_adj=strrep(logfile,'.txt','_adj_eigenvectors.txt');
eigenvaluesfile_adj=strrep(logfile,'.txt','_GrSpec_adjmatr.txt');
%open_eigenvectors(eigenvectorsfile_adj,eigenvaluesfile_adj,filename,wind,tstep,logfile);
open_eigenvectors2(eigenvectorsfile_adj,eigenvaluesfile_adj,eigenvectorsfile_lapl,eigenvaluesfile_lapl,filename,wind,tstep,logfile,doplot_ipr);