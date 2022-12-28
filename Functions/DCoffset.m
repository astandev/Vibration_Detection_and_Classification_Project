function [out] = DCoffset(in)
%DCOFFSET converts the digital values back to analog and removes the DC offset from PCB 

n = 12;
res = 2^n - 1;
Vref = 3.3;
offset = Vref/2;

% ADC equation = (Vinput/Vref)*res = DAC value
% So, ((DAC value)/res)*Vref = Analog value
out = (in./res)*Vref - offset;
end

