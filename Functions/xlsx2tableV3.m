function [table,Time] = xlsx2tableV3(data1)
%XLSX2TABLEV3 takes input excel worksheet file and converts them to a
%readable table in MATLAB after splicing into 3 sec intervals

tableA = readtable(data1, 'VariableNamingRule','preserve');
tableA.Properties.VariableNames = {'Time' 'A3' 'A2' 'A1'};

Time = tableA.Time';

A2 = tableA.A2';
A3 = tableA.A3';

a = 1500;
B2 = zeros(25,1501);
B3 = zeros(25,1501);
for k = 1:25
    B2(k,:) = A2(1,(k*a-a)+1:(k*a)+1);
    B3(k,:) = A3(1,(k*a-a)+1:(k*a)+1);
end

B2 = DCoffset(B2);
B3 = DCoffset(B3);

table = [B2;B3];
end

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
