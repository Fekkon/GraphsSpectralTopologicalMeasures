% The eigenvalues of the Laplacian of the graph
% INPUTs: adjacency matrix
% OUTPUTs: laplacian eigenvalues, sorted

function s=graph_spectrum(adj, type_normalize)
% type_normalize=0 - non-normalized; 1 - normalized ;2 - nlaplacian 
if (nargin<2)
    type_normalize=0;
end

[v,D]=eig(laplacian_matrix(adj, type_normalize));
s=-sort(-diag(D)); % sort in decreasing order