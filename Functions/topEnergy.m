function [Y] = topEnergy(X)
%TOPENERGY Summary of this function goes here
a = max(X);
b = 0.9*a;
c = X <= a & X >= b;
Y = X(c);
end

