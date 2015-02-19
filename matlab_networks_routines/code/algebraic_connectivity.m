% The algebraic connectivity of a graph: the second smallest eigenvalue of the Laplacian
% INPUTs: adjacency matrix
% OUTPUTs: algebraic connectivity

function a=algebraic_connectivity(adj, type_normalize)
% type_normalize=0 - non-normalized; 1 - normalized ;2 - nlaplacian 
if (nargin<2)
    type_normalize=0;
end

s=graph_spectrum(adj, type_normalize);
a=s(length(s)-1);