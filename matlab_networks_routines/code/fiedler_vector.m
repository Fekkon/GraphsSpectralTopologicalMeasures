% The vector corresponding to the second smallest eigenvalue of the Laplacian matrix
% INPUTs: adjacency matrix (nxn)
% OUTPUTs: fiedler vector (nx1)

function fv=fiedler_vector(adj, type_normalize)
% type_normalize=0 - non-normalized; 1 - normalized ;2 - nlaplacian 
if (nargin<2)
    type_normalize=0;
end

[V,D]=eig(laplacian_matrix(adj, type_normalize));
[ds,Y]=sort(diag(D));
fv=V(:,Y(2));