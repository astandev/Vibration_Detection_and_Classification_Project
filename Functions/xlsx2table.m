function [table,Time] = xlsx2table(data1, data2, data3, data4, data5)
%XLSX2TABLE takes input excel worksheet files and converts them to a
%readable table in MATLAB

tableA = readtable(data1, 'VariableNamingRule','preserve');
tableA.Properties.VariableNames = {'Time' 'A3' 'A2' 'A1'};

Time = tableA.Time';
A1 = tableA.A1';
A2 = tableA.A2';
A3 = tableA.A3';

tableB = readtable(data2, 'VariableNamingRule','preserve');
tableB.Properties.VariableNames = {'Time' 'B3' 'B2' 'B1'};

B1 = tableB.B1';
B2 = tableB.B2';
B3 = tableB.B3';

tableC = readtable(data3, 'VariableNamingRule','preserve');
tableC.Properties.VariableNames = {'Time' 'C3' 'C2' 'C1'};

C1 = tableC.C1';
C2 = tableC.C2';
C3 = tableC.C3';

tableD = readtable(data4, 'VariableNamingRule','preserve');
tableD.Properties.VariableNames = {'Time' 'D3' 'D2' 'D1'};

D1 = tableD.D1';
D2 = tableD.D2';
D3 = tableD.D3';

tableE = readtable(data5, 'VariableNamingRule','preserve');
tableE.Properties.VariableNames = {'Time' 'E3' 'E2' 'E1'};

E1 = tableE.E1';
E2 = tableE.E2';
E3 = tableE.E3';

G1 = [A1;B1;C1;D1;E1];
G2 = [A2;B2;C2;D2;E2];
G3 = [A3;B3;C3;D3;E3];

G1 = DCoffset(G1);
G2 = DCoffset(G2);
G3 = DCoffset(G3);

table = [G1;G2;G3];
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

