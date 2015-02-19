% The Laplacian matrix defined for a *simple* graph 
% (the difference b/w the diagonal degree and the adjacency matrices)
% Note: This is not the normalized Laplacian
% INPUTS: adjacency matrix
% OUTPUTs: Laplacian matrix

function L=laplacian_matrix(adj, type_normalize)
% type_normalize=0 - non-normalized; 1 - normalized ;2 - nlaplacian 
if (nargin<2)
    type_normalize=0;
end

if (type_normalize==0)
    L=diag(sum(adj))-adj;
else
    if (type_normalize==1)
        % NORMALIZED Laplacian =============
        n=length(adj);
        deg = sum(adj); % for other than simple graphs, use [deg,~,~]=degrees(adj);
        L=zeros(n);
        edges=find(adj>0);
        for e=1:length(edges)
            [ii,jj]=ind2sub([n,n],edges(e));
            if ii==jj; L(ii,ii)=1; continue; end
            L(ii,jj)=-1/sqrt(deg(ii)*deg(jj));
        end
    else % type_normalize=2 - nlaplacian 
        L = nlaplacian(adj ,size(adj,1));
    end
end