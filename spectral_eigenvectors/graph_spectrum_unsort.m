% The eigenvalues of the Laplacian of the graph
% INPUTs: adjacency matrix
% OUTPUTs: laplacian eigenvalues, sorted

function [s,v]=graph_spectrum_unsort(adj, type_normalize)
% donormalize=0 - non-normalized; 1 - normalized ;2 - nlaplacian 
if (nargin<2)
    type_normalize=0;
end

[v,D]=eig(laplacian_matrix(adj, type_normalize));
s=diag(D);