function [Mag,f] = FourierTransform(X,Fs)
%FOURIERTRANSFORM Summary of this function goes here
T = 1/Fs;
L = length(X);
f = Fs*(0:(L/2))/L;
t = (0:L-1)*T;
Y = fft(X);
P2 = abs(Y/L);
Mag = P2(1:L/2+1);
Mag(2:end-1) = 2*Mag(2:end-1);
end

