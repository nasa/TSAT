function [ T,Y ] = ReduceDataSet( t,y,dt )
%ReduceDataSet.m Summary
%   This function takes the data set (t,y) and reduces the number of points
%   by only retaining the data points that are spaced approximately dt
%   apart.

n = 0;
for i = 1:length(t)
    if t(i) >= (n*dt + t(1))
        T(n+1) = t(i);
        Y(n+1) = y(i);
        n = n + 1;
    end
end

end

