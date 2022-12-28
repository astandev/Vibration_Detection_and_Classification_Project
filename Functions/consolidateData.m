function [time,] = consolidateData()
%CONSOLIDATEDATA 
[FT1_1_G1,FT1_1_G2,FT1_1_G3,t1] = xlsx2table('FT1.xlsx');
[FT1_2_G1,FT1_2_G2,FT1_2_G3] = xlsx2table('FT1.xlsx');
[FT1_3_G1,FT1_3_G2,FT1_3_G3] = xlsx2table('FT1.xlsx');
[FT1_4_G1,FT1_4_G2,FT1_4_G3] = xlsx2table('FT1.xlsx');
[FT1_5_G1,FT1_5_G2,FT1_5_G3] = xlsx2table('FT1.xlsx');
time = t1;

FT1_G1 = combineTables(FT1_1_G1,FT1_2_G1,FT1_3_G1,FT1_4_G1,FT1_5_G1);
FT2_G1 = combineTables(FT2_1_G1,FT2_2_G1,FT2_3_G1,FT2_4_G1,FT2_5_G1);
FT3_G1 = combineTables(FT3_1_G1,FT3_2_G1,FT3_3_G1,FT3_4_G1,FT3_5_G1);
FT4_G1 = combineTables(FT4_1_G1,FT4_2_G1,FT4_3_G1,FT4_4_G1,FT4_5_G1);
FT5_G1 = combineTables(FT5_1_G1,FT5_2_G1,FT5_3_G1,FT5_4_G1,FT5_5_G1);

FT1_G2 = combineTables(FT1_1_G2,FT1_2_G2,FT1_3_G2,FT1_4_G2,FT1_5_G2);
FT2_G2 = combineTables(FT2_1_G2,FT2_2_G2,FT2_3_G2,FT2_4_G2,FT2_5_G2);
FT3_G2 = combineTables(FT3_1_G2,FT3_2_G2,FT3_3_G2,FT3_4_G2,FT3_5_G2);
FT4_G2 = combineTables(FT4_1_G2,FT4_2_G2,FT4_3_G2,FT4_4_G2,FT4_5_G2);
FT5_G2 = combineTables(FT5_1_G2,FT5_2_G2,FT5_3_G2,FT5_4_G2,FT5_5_G2);

FT1_G3 = combineTables(FT1_1_G3,FT1_2_G3,FT1_3_G3,FT1_4_G3,FT1_5_G3);
FT2_G3 = combineTables(FT2_1_G3,FT2_2_G3,FT2_3_G3,FT2_4_G3,FT2_5_G3);
FT3_G3 = combineTables(FT3_1_G3,FT3_2_G3,FT3_3_G3,FT3_4_G3,FT3_5_G3);
FT4_G3 = combineTables(FT4_1_G3,FT4_2_G3,FT4_3_G3,FT4_4_G3,FT4_5_G3);
FT5_G3 = combineTables(FT5_1_G3,FT5_2_G3,FT5_3_G3,FT5_4_G3,FT5_5_G3);

FT1_G1 = DCoffset(FT1_G1);
FT2_G1 = DCoffset(FT2_G1);
FT3_G1 = DCoffset(FT3_G1);
FT4_G1 = DCoffset(FT4_G1);
FT5_G1 = DCoffset(FT5_G1);
FT1_G2 = DCoffset(FT1_G1);
FT2_G2 = DCoffset(FT2_G1);
FT3_G2 = DCoffset(FT3_G1);
FT4_G2 = DCoffset(FT4_G1);
FT5_G2 = DCoffset(FT5_G1);
FT1_G3 = DCoffset(FT1_G1);
FT2_G3 = DCoffset(FT2_G1);
FT3_G3 = DCoffset(FT3_G1);
FT4_G3 = DCoffset(FT4_G1);
FT5_G3 = DCoffset(FT5_G1);
 
end

function [G1,G2,G3,Time] = xlsx2table(data)
%XLSX2TABLE takes input excel worksheet files and converts them to a
%readable table in MATLAB

table = readtable(data, 'VariableNamingRule','preserve');
table.Properties.VariableNames = {'Time' 'G3' 'G2' 'G1'};

Time = table.Time';
G1 = table.G1';
G2 = table.G2';
G3 = table.G3';
end

function [table] = combineTables(data1,data2,data3,data4,data5)
%COMBINETABLES will combine separate tables into one matrix
table(1,:) = data1;
table(2,:) = data2;
table(3,:) = data3;
table(4,:) = data4;
table(5,:) = data5;
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
