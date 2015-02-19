function Adj=data_to_graph(filename, model_type, t_beg, t_end, wind, p, k, beta, n_pref, m_pref, crp_emb_dimm, crp_delay, crp_epsilon,rmt_multiplier);
% Функція обчислення матриці суміжності для а) канонічних моделей б)
% моделей реальних систем (смолл ворлд, переважного приєднання,
% Ердоша-Реньї), моделей Лакаса, CRP, та матриць крос-кореляції
if (model_type>=7)
    if (model_type<10)
        y=dlmread(filename);
        n=length(y);
        if (t_end>n)
            t_end=n;
        end
        if (t_beg>n)
            t_beg=n;
        end
        y_fragm=y(t_beg:t_end);
    else
        if (model_type<11)
            y=dlmread(filename);
            [n,m]=size(y);
            if (t_end>n)
                t_end=n;
            end
            if (t_beg>n)
                t_beg=n;
            end
            y_fragm=y(t_beg:t_end,:);
        end
    end
end

     % parameters for random graph (Renyi):p
    switch (model_type)
        case 1
            edgel=canonical_nets(wind,'line');
            Adj=edgeL2adj(edgel); % translation from edge list to adj matrix
        case 2
            edgel=canonical_nets(wind,'circle');
            Adj=edgeL2adj(edgel); % translation from edge list to adj matrix
        case 3
            edgel=canonical_nets(wind,'star');
            Adj=edgeL2adj(edgel); % translation from edge list to adj matrix
        case 4
            Adj=random_graph(wind,p); % Erdos Renyi with the given p;
        case 5
            Adj_sparse = small_world(wind, k, beta);
            Adj=full(Adj_sparse);
        case 6
            edgel = preferential_attachment(n_pref,m_pref);
            Adj=edgeL2adj(edgel); % translation from edge list to adj matrix
        case 7
            Adj=double(crp(y_fragm,crp_emb_dimm,crp_delay,crp_epsilon));
        case 8
            Adj=ts2visgraph(y_fragm);
        case 9
            Adj=ts2visgraph_horiz(y_fragm);
        case 10
            wind=t_end-t_beg;
            y_ret=(y_fragm(2:wind,:)-y_fragm(1:wind-1,:))./y_fragm(1:wind-1,:);
            y_mean=mean(y_ret);
            y_mean_m=repmat(y_mean,size(y_ret,1),1);
            y_disp=std(y_ret);
            y_disp_m=repmat(y_disp,size(y_ret,1),1);
            y_ret_n=(y_ret-y_mean_m)./y_disp_m;
            y_corr=y_ret_n'*y_ret_n/size(y_ret_n,1);
            y_corr(find(isnan(y_corr)))=0;
            y_dist=sqrt(2*(1-y_corr));
            y_thr=mean(mean(y_dist))*rmt_multiplier;
            Adj=double(y_dist<y_thr);
        case 11
            Adj=dlmread(filename);
        case 12
            load(filename);
        otherwise
            
            error
    end
    %edgel=canonical_nets(wind,'circle');
end