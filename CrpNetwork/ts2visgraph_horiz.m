function Adj=ts2visgraph_horiz(y);
% Transforming the time series to the visibility graphs 
n=length(y);
Adj=zeros(n,n);
for i=1:n-1
    for j=i+1:n
        Adj(i,j)=visib_left_right_horiz(y,i,j);
        Adj(j,i)=Adj(i,j);
        %Adj(j,i)=visib_left_right_horiz(y,j,i);
    end
end

function vis=visib_left_right_horiz(y,i,j);
% return whether the node j is visible from i (from left to right)
% calculating the line equation, that crosses two points:
% y(i)=a0+a1*i
% y(j)=a0+a1*j
a0=min(y(i),y(j));
a1=0;
vis=1;
for k=i+1:j-1
    if (y(k)>a0+a1*k)
        vis=0;
        break;
    end
end

function vis=visib_right_left_horiz(y,i,j);
% return whether the node j is visible from i (from left to right)
% calculating the line equation, that crosses two points:
% y(i)=a0+a1*i
% y(j)=a0+a1*j
a0=min(y(i),y(j));
a1=0;
vis=1;
for k=i+1:j-1
    if (y(k)>a0+a1*k)
        vis=0;
        break;
    end
end

            