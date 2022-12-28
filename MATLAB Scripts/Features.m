%% Extract Features from user-defined functions and results from simulink model
clear all
close all

Fs = 500; %Sample rate of 500Hz
[FT_table,time] = xlsx2table('FT1.xlsx','FT2.xlsx','FT3.xlsx','FT4.xlsx','FT5.xlsx'); %Preprocess 5 Finger Tap xlsx files
FH_table = xlsx2table('FH1.xlsx','FH2.xlsx','FH3.xlsx','FH4.xlsx','FH5.xlsx'); %Preprocess 5 Finger Hit xlsx files
HD_table = xlsx2table('HD1.xlsx','HD2.xlsx','HD3.xlsx','HD4.xlsx','HD5.xlsx'); %Preprocess 5 Hand Drumming xlsx files
SD_table = xlsx2table('SD1.xlsx','SD2.xlsx','SD3.xlsx','SD4.xlsx','SD5.xlsx'); %Preprocess 5 Stick Drumming xlsx files

writematrix(FH_table, 'FH_table.csv') %Write table of data to a csv file

featureTable(1:15,:) = buildFeatureTable(FH_table,15); %Extract features from FH_table and store in rows 1-15
featureTable(16:30,:) = buildFeatureTable(FT_table,15); %Extract features from FT_table and store in rows 16-30
featureTable(31:45,:) = buildFeatureTable(HD_table,15); %Extract features from HD_table and store in rows 31-45
featureTable(46:60,:) = buildFeatureTable(SD_table,15); %Extract features from SD_table and store in rows 46-60

one = ones(15,1); %Create column vector of all 1's
two = 2*ones(15,1); %Create column vector of all 2's
three = 3*ones(15,1); %Create column vector of all 3's
four = 4*ones(15,1); %Create column vector of all 4's
actId = [one;two;three;four]; %Create column vector of all previous Classification Index numbers

featureTable = [featureTable actId]; %Append Classification Index column array to the feature table
%Creates feature table with known classifications in the last column 
                                     

featureTable = array2table(featureTable); %Converts feature array to a formated table
featureTable.Properties.VariableNames = {'Mean' 'Std' 'Max' 'Variance' 'Skewness' 'Kurtosis' 'RMS' 'Mean Freq' 'Median Freq' 'Peak to Peak' 'Peak to RMS' 'Num of Maxima' 'SpecPeak1' 'SpecPeak2' 'SpecPeak3' 'SpecPeak4' 'SpecPeak5' 'SpecPeak6' 'SpecPeak7' 'SpecPeak8' 'SpecPeak9' 'SpecPeak10' 'SpecPeak11' 'SpecPeak12' 'AutoCorrMainPeak' 'AutoCorr2ndHeight' 'AutoCorr2ndPeak' 'SpecPwr1' 'SpecPwr2' 'SpecPwr3' 'SpecPwr4' 'SpecPwr5' 'VibrationClass'};
%Create Header labels for each feature corresponding to the same column
% featureTable.VibrationClass(featureTable.VibrationClass == 1) = {'Finger Hits'};
% featureTable.VibrationClass(featureTable.VibrationClass == 2) = {'Finger Taps'};
% featureTable.VibrationClass(featureTable.VibrationClass == 3) = {'Hand Drumming'};
% featureTable.VibrationClass(featureTable.VibrationClass == 4) = {'Stick Drumming'};
featureTable.VibrationClass = categorical(featureTable.VibrationClass);

%% UMass McCormack Lab Recordings and Feature Extraction
clear all 
close all

Fs = 500; %Sample Rate of 500Hz
[FS_table1,time] = xlsx2table('FS_1.xlsx','FS_2.xlsx','FS_3.xlsx','FS_4.xlsx','FS_5.xlsx'); %Preprocess 1-5 Finger Steps xlsx files
FS_table2 = xlsx2table('FS_6.xlsx','FS_7.xlsx','FS_8.xlsx','FS_9.xlsx','FS_10.xlsx'); %Preprocess 6-10 Finger Steps xlsx files

RUN_table1 = xlsx2table('RUN_1.xlsx','RUN_2.xlsx','RUN_3.xlsx','RUN_4.xlsx','RUN_5.xlsx'); %Preprocess 1-5 Running xlsx files
RUN_table2 = xlsx2table('RUN_6.xlsx','RUN_7.xlsx','RUN_8.xlsx','RUN_9.xlsx','RUN_10.xlsx'); %Preprocess 6-10 Running xlsx files

JUMP_table1 = xlsx2table('JUMP_1.xlsx','JUMP_2.xlsx','JUMP_3.xlsx','JUMP_4.xlsx','JUMP_5.xlsx'); %Preprocess 1-5 Jumping xlsx files
JUMP_table2 = xlsx2table('JUMP_6.xlsx','JUMP_7.xlsx','JUMP_8.xlsx','JUMP_9.xlsx','JUMP_10.xlsx'); %Preprocess 6-10 Running xlsx files

CART_table1 = xlsx2table('CART_1.xlsx','CART_2.xlsx','CART_3.xlsx','CART_4.xlsx','CART_5.xlsx'); %Preprocess 1-5 Cart xlsx files
CART_table2 = xlsx2table('CART_6.xlsx','CART_7.xlsx','CART_8.xlsx','CART_9.xlsx','CART_10.xlsx'); %Preprocess 6-10 Cart xlsx files

featureTable(1:15,:) = buildFeatureTable(FS_table1,15); %Extract features from FS_table1 and store in rows 1-15
featureTable(16:30,:) = buildFeatureTable(FS_table2,15); %Extract features from FS_table2 and store in rows 16-30
featureTable(31:45,:) = buildFeatureTable(RUN_table1,15); %Extract features from RUN_table1 and store in rows 31-45
featureTable(46:60,:) = buildFeatureTable(RUN_table2,15); %Extract features from RUN_table2 and store in rows 46-60
featureTable(61:75,:) = buildFeatureTable(JUMP_table1,15); %Extract features from JUMP_table1 and store in rows 61-75
featureTable(76:90,:) = buildFeatureTable(JUMP_table2,15); %Extract features from JUMP_table2 and store in rows 76-90
featureTable(91:105,:) = buildFeatureTable(CART_table1,15); %Extract features from CART_table1 and store in rows 91-105
featureTable(106:120,:) = buildFeatureTable(CART_table2,15); %Extract features from CART_table1 and store in rows 106-120

one = ones(30,1); %Create column vector of all 1's
two = 2*ones(30,1); %Create column vector of all 2's
three = 3*ones(30,1); %Create column vector of all 3's
four = 4*ones(30,1); %Create column vector of all 4's
actId = [one;two;three;four]; %Create column vector of all previous Classification Index numbers

featureTable = [featureTable actId]; %Append Classification Index column array to the feature table
%Creates feature table with known classifications in the last column 

featureTable = array2table(featureTable); %Converts feature array to a formated table
%Create Header labels for each feature corresponding to the same column
featureTable.Properties.VariableNames = {'Mean' 'Std' 'Max' 'Variance' 'Skewness' 'Kurtosis' 'RMS' 'Mean Freq' 'Median Freq' 'Peak to Peak' 'Peak to RMS' 'Num of Maxima' 'Num of Minima' 'SpecPeak1' 'SpecPeak2' 'SpecPeak3' 'SpecPeak4' 'SpecPeak5' 'SpecPeak6' 'SpecPeak7' 'SpecPeak8' 'SpecPeak9' 'SpecPeak10' 'SpecPeak11' 'SpecPeak12' 'AutoCorrMainPeak' 'AutoCorr2ndHeight' 'AutoCorr2ndPeak' 'SpecPwr1' 'SpecPwr2' 'SpecPwr3' 'SpecPwr4' 'SpecPwr5' 'VibrationClass'};
featureTable.VibrationClass = cell(120,1); %Create Cell array to add in Classification strings to feature table 
featureTable.VibrationClass(1:30) = {'Footsteps'}; %Create cell array for Footsteps classification
featureTable.VibrationClass(31:60) = {'Running'}; %Create cell array for Running classification
featureTable.VibrationClass(61:90) = {'Jumping'}; %Create cell array for Jumping classification
featureTable.VibrationClass(91:120) = {'Handcart'}; % Create cell array for Handcart classification
featureTable.VibrationClass = categorical(featureTable.VibrationClass); %Make Vibration class a categorical type 
%When opening the MATLAB Classifcation Learner as part of the Deep Learning
%Toolbox, choose the featureTable as an input and the categorical column of
%classifications will be the predictor types. Classification Learner will
%then uses the categorical vibration names as the labels for the difference
%machine learning models.

writetable(featureTable, '3.19.21.LabTests.csv') % write featureTable to a csv file

%% 3.22.21 Outdoor Vibration Tests
clear all 
close all

Fs = 500; %Sample Rate of 500Hz
[WALKtable1,time] = xlsx2tableV2('WALK_1.xlsx','WALK_2.xlsx','WALK_3.xlsx','WALK_4.xlsx','WALK_5.xlsx'); %Preprocess 1-5 WALK xlsx files
WALKtable2 = xlsx2tableV2('WALK_6.xlsx','WALK_7.xlsx','WALK_8.xlsx','WALK_9.xlsx','WALK_10.xlsx'); %Preprocess 6-10 WALK xlsx files
WALKtable3 = xlsx2tableV2('WALK_11.xlsx','WALK_12.xlsx','WALK_13.xlsx','WALK_14.xlsx','WALK_15.xlsx'); %Preprocess 11-15 WALK xlsx files
WALKtable4 = xlsx2tableV2('WALK_16.xlsx','WALK_17.xlsx','WALK_18.xlsx','WALK_19.xlsx','WALK_20.xlsx'); %Preprocess 16-20 WALK xlsx files
WALKtable5 = xlsx2tableV2('WALK_21.xlsx','WALK_22.xlsx','WALK_23.xlsx','WALK_24.xlsx','WALK_25.xlsx'); %Preprocess 21-25 WALK xlsx files

featureTable(1:10,:) = buildFeatureTable(WALKtable1,10); %Extract features from WALKtable1 and store in rows 1-10
featureTable(11:20,:) = buildFeatureTable(WALKtable2,10); %Extract features from WALKtable2 and store in rows 11-20
featureTable(21:30,:) = buildFeatureTable(WALKtable2,10); %Extract features from WALKtable and store in rows 21-30
featureTable(31:40,:) = buildFeatureTable(WALKtable2,10); %Extract features from WALKtable and store in rows 31-40
featureTable(41:50,:) = buildFeatureTable(WALKtable2,10); %Extract features from WALKtable and store in rows 41-50

JUMPtable = xlsx2tableV3('JUMP75sec.xlsx'); %Preprocess xlsx to output 27 observations that are 3 secs long
RUNtable = xlsx2tableV3('RUN75sec.xlsx'); %Preprocess xlsx to output 27 observations that are 3 secs long
SHOVELtable = xlsx2tableV3('SHOVEL75sec.xlsx'); %Preprocess xlsx to output 27 observations that are 3 secs long
WEIGHTtable = xlsx2tableV3('WEIGHT75sec.xlsx'); %Preprocess xlsx to output 27 observations that are 3 secs long
CARtable = xlsx2tableV3('CAR75sec.xlsx'); %Preprocess xlsx to output 27 observations that are 3 secs long

featureTable(51:100,:) = buildFeatureTable(RUNtable,50); %Extract features from RUNtable and store in rows 51-100
featureTable(101:150,:) = buildFeatureTable(JUMPtable,50); %Extract features from JUMPtable and store in rows 101-150
featureTable(151:200,:) = buildFeatureTable(SHOVELtable,50); %Extract features from SHOVELtable and store in rows 151-200
featureTable(201:250,:) = buildFeatureTable(WEIGHTtable,50); %Extract features from WEIGHTtable and store in rows 201-250
featureTable(251:300,:) = buildFeatureTable(CARtable,50); %Extract features from CARtable and store in rows 251-300

one = ones(50,1); %Create column vector of all 1's
two = ones(50,1); %Create column vector of all 2's
three = ones(50,1); %Create column vector of all 3's
four = ones(50,1); %Create column vector of all 4's
five = ones(50,1); %Create column vector of all 5's
six = ones(50,1); %Create column vector of all 6's

actId = [one;two;three;four;five;six]; %Create column vector of all previous Classification Index numbers

featureTable = [featureTable actId]; %Append Classification Index column array to the feature table
%Creates feature table with known classifications in the last column 

featureTable = array2table(featureTable); %Converts feature array to a formated table
%Create Header labels for each feature corresponding to the same column
featureTable.Properties.VariableNames = {'Mean' 'Std' 'Max' 'Variance' 'Skewness' 'Kurtosis' 'RMS' 'Mean Freq' 'Median Freq' 'Peak to Peak' 'Peak to RMS' 'Num of Maxima' 'Num of Minima' 'SpecPeak1' 'SpecPeak2' 'SpecPeak3' 'SpecPeak4' 'SpecPeak5' 'SpecPeak6' 'SpecPeak7' 'SpecPeak8' 'SpecPeak9' 'SpecPeak10' 'SpecPeak11' 'SpecPeak12' 'AutoCorrMainPeak' 'AutoCorr2ndHeight' 'AutoCorr2ndPeak' 'SpecPwr1' 'SpecPwr2' 'SpecPwr3' 'SpecPwr4' 'SpecPwr5' 'VibrationClass'};
featureTable.VibrationClass = cell(300,1); %Create Cell array to add in Classification strings to feature table 
featureTable.VibrationClass(1:50) = {'Walking'}; %Create cell array for Walking classification
featureTable.VibrationClass(51:100) = {'Running'}; %Create cell array for Running classification
featureTable.VibrationClass(101:150) = {'Jumping'}; %Create cell array for Jumping classification
featureTable.VibrationClass(151:200) = {'Shovel'}; %Create cell array for Shovel classification
featureTable.VibrationClass(201:250) = {'Weight Dropped'}; %Create cell array for Weight Dropped classification
featureTable.VibrationClass(251:300) = {'Car'}; %Create cell array for Car classification
featureTable.VibrationClass = categorical(featureTable.VibrationClass); %Make Vibration class a categorical type 
%When opening the MATLAB Classifcation Learner as part of the Deep Learning
%Toolbox, choose the featureTable as an input and the categorical column of
%classifications will be the predictor types. Classification Learner will
%then uses the categorical vibration names as the labels for the difference
%machine learning models.

writetable(featureTable, '3.21.21.BackyardTests.csv') % write featureTable to a csv file
figure()
plot(time, WEIGHTtable(1,:))

%% 3.27.21 Outdoor Vibration Tests - Collected 5 different vibration classes and 1 Noise class
% Geophones were planted in ground and sampled at 500 Hz
% Test were run in Simulink and export to MATLAB as .xlsx files
% Custom functions were created to preprocess signals, extract their
% features and import them into the MATLAB CLassification Learner to verify
% which type of Machine Learning Model would best fit our data.
clear all 
close all

a = 27; % # of observations 
b = 25; % # of observations
Fs = 500; % Sample Rate of 500Hz
[WALK1table,time] = xlsx2tableV4('WALK1.xlsx',a); %Preprocess WALK1 xlsx file, input a specifies 27 rows 
WALK2table = xlsx2tableV4('WALK2.xlsx',a); %Preprocess WALK2 xlsx file, input a specifies 27 rows
WALK3table = xlsx2tableV4('WALK3.xlsx',a); %Preprocess WALK3 xlsx file, input a specifies 27 rows

RUN1table = xlsx2tableV4('RUN1.xlsx',a); %Preprocess RUN1 xlsx file, input a specifies 27 rows
RUN2table = xlsx2tableV4('RUN2.xlsx',a); %Preprocess RUN2 xlsx file, input a specifies 27 rows
RUN3table = xlsx2tableV4('RUN3.xlsx',a); %Preprocess RUN3 xlsx file, input a specifies 27 rows

JUMP1table = xlsx2tableV4('JUMP1.xlsx',a); %Preprocess JUMP1 xlsx file, input a specifies 27 rows
JUMP2table = xlsx2tableV4('JUMP2.xlsx',a); %Preprocess JUMP2 xlsx file, input a specifies 27 rows
JUMP3table = xlsx2tableV4('JUMP3.xlsx',a); %Preprocess JUMP3 xlsx file, input a specifies 27 rows

SHOVEL1table = xlsx2tableV4('SHOVEL1.xlsx',a); %Preprocess SHOVEL1 xlsx file, input a specifies 27 rows
SHOVEL2table = xlsx2tableV4('SHOVEL2.xlsx',a); %Preprocess SHOVEL2 xlsx file, input a specifies 27 rows
SHOVEL3table = xlsx2tableV4('SHOVEL3.xlsx',a); %Preprocess SHOVEL3 xlsx file, input a specifies 27 rows

WEIGHT1table = xlsx2tableV4('WEIGHT1.xlsx',a); %Preprocess WEIGHT1 xlsx file, input a specifies 27 rows
WEIGHT2table = xlsx2tableV4('WEIGHT2.xlsx',a); %Preprocess WEIGHT2 xlsx file, input a specifies 27 rows
WEIGHT3table = xlsx2tableV4('WEIGHT3.xlsx',a); %Preprocess WEIGHT3 xlsx file, input a specifies 27 rows

NOISEtable = xlsx2tableV4('NOISE75sec.xlsx',b); %Preprocess NOISE75sec xlsx file, input b specifies 25 rows

featureTable(1:81,:) = buildFeatureTable(WALK1table,81); %Extract features from WALK1table and store in rows 1-81
featureTable(82:162,:) = buildFeatureTable(WALK2table,81); %Extract features from WALK2table and store in rows 82-162
featureTable(163:243,:) = buildFeatureTable(WALK3table,81); %Extract features from WALK3table and store in rows 163:243
 
featureTable(244:324,:) = buildFeatureTable(RUN1table,81); %Extract features from RUN1table and store in rows 244-324
featureTable(325:405,:) = buildFeatureTable(RUN2table,81); %Extract features from RUN2table and store in rows 325-405
featureTable(406:486,:) = buildFeatureTable(RUN3table,81); %Extract features from RUN3table and store in rows 406-486

featureTable(487:567,:) = buildFeatureTable(JUMP1table,81); %Extract features from JUMP1table and store in rows 487-567
featureTable(568:648,:) = buildFeatureTable(JUMP2table,81); %Extract features from JUMP2table and store in rows 568-648
featureTable(649:729,:) = buildFeatureTable(JUMP3table,81); %Extract features from JUMP3table and store in rows 649-729

featureTable(730:810,:) = buildFeatureTable(SHOVEL1table,81); %Extract features from SHOVEL1table and store in rows 730-810
featureTable(811:891,:) = buildFeatureTable(SHOVEL2table,81); %Extract features from SHOVEL2table and store in rows 811-891
featureTable(892:972,:) = buildFeatureTable(SHOVEL3table,81); %Extract features from SHOVEL3table and store in rows 892-972

featureTable(973:1053,:) = buildFeatureTable(WEIGHT1table,81); %Extract features from WEIGHT1table and store in rows 973-1053
featureTable(1054:1134,:) = buildFeatureTable(WEIGHT2table,81); %Extract features from WEIGHT2table and store in rows 1054-1134
featureTable(1135:1215,:) = buildFeatureTable(WEIGHT3table,81); %Extract features from WEIGHT3table and store in rows 1135-1215

one = ones(243,1); %Create column vector of all 1's
two = ones(243,1); %Create column vector of all 2's
three = ones(243,1); %Create column vector of all 3's
four = ones(243,1); %Create column vector of all 4's
five = ones(243,1); %Create column vector of all 5's

actId = [one;two;three;four;five]; %Create column vector of all previous Classification Index numbers

featureTable = [featureTable actId]; %Append Classification Index column array to the feature table
%Creates feature table with known classifications in the last column 

featureTable = array2table(featureTable); %Converts feature array to a formated table
%Create Header labels for each feature corresponding to the same column
featureTable.Properties.VariableNames = {'Mean' 'Std' 'Max' 'Variance' 'Skewness' 'Kurtosis' 'RMS' 'Mean Freq' 'Median Freq' 'Peak to Peak' 'Peak to RMS' 'Num of Maxima' 'SpecPeak1' 'SpecPeak2' 'SpecPeak3' 'SpecPeak4' 'SpecPeak5' 'SpecPeak6' 'SpecPeak7' 'SpecPeak8' 'SpecPeak9' 'SpecPeak10' 'SpecPeak11' 'SpecPeak12' 'AutoCorrMainPeak' 'AutoCorr2ndHeight' 'AutoCorr2ndPeak' 'SpecPwr1' 'SpecPwr2' 'SpecPwr3' 'SpecPwr4' 'SpecPwr5' 'VibrationClass'};
featureTable.VibrationClass = cell(1215,1); %Create Cell array to add in Classification strings to feature table 
featureTable.VibrationClass(1:243) = {'Walking'}; %Create cell array for Walking classification
featureTable.VibrationClass(244:486) = {'Running'}; %Create cell array for Running classification
featureTable.VibrationClass(487:729) = {'Jumping'}; %Create cell array for Jumping classification
featureTable.VibrationClass(730:972) = {'Shovel'}; %Create cell array for Shovel classification
featureTable.VibrationClass(973:1215) = {'Weight Dropped'}; %Create cell array for Weight Dropped classification
featureTable.VibrationClass = categorical(featureTable.VibrationClass); %Make Vibration class a categorical type 
%When opening the MATLAB Classifcation Learner as part of the Deep Learning
%Toolbox, choose the featureTable as an input and the categorical column of
%classifications will be the predictor types. Classification Learner will
%then uses the categorical vibration names as the labels for the difference
%machine learning models.

writetable(featureTable, '3.27.21.BackyardTests.csv') % write featureTable to a csv file
%% This section was used to export the csv files of field recordings into csv tables that would be used in Python
% tableA = readtable("FH1.xlsx", 'VariableNamingRule','preserve');
% tableA.Properties.VariableNames = {'Time' 'A3' 'A2' 'A1'};
% 
% tableB = readtable("FH2.xlsx", 'VariableNamingRule','preserve');
% tableB.Properties.VariableNames = {'Time' 'A3' 'A2' 'A1'};
% 
% tableC = readtable("FH3.xlsx", 'VariableNamingRule','preserve');
% tableC.Properties.VariableNames = {'Time' 'A3' 'A2' 'A1'};
% 
% tableD = readtable("FH4.xlsx", 'VariableNamingRule','preserve');
% tableD.Properties.VariableNames = {'Time' 'A3' 'A2' 'A1'};
% 
% tableE = readtable("FH5.xlsx", 'VariableNamingRule','preserve');
% tableE.Properties.VariableNames = {'Time' 'A3' 'A2' 'A1'};
% 
% writetable(tableA, 'FH1.csv')
% writetable(tableB, 'FH2.csv')
% writetable(tableC, 'FH3.csv')
% writetable(tableD, 'FH4.csv')
% writetable(tableE, 'FH5.csv')

% tableF = readtable("JUMP1.xlsx", 'VariableNamingRule','preserve');
% tableF.Properties.VariableNames = {'Time' 'A3' 'A2' 'A1'};
% 
% tableG = readtable("JUMP2.xlsx", 'VariableNamingRule','preserve');
% tableG.Properties.VariableNames = {'Time' 'A3' 'A2' 'A1'};
% 
% tableH = readtable("JUMP3.xlsx", 'VariableNamingRule','preserve');
% tableH.Properties.VariableNames = {'Time' 'A3' 'A2' 'A1'};
% 
% writetable(tableF, 'JUMP1.csv')
% writetable(tableG, 'JUMP2.csv')
% writetable(tableH, 'JUMP3.csv')
% 
% tableI = readtable("RUN1.xlsx", 'VariableNamingRule','preserve');
% tableI.Properties.VariableNames = {'Time' 'A3' 'A2' 'A1'};
% 
% tableJ = readtable("RUN2.xlsx", 'VariableNamingRule','preserve');
% tableJ.Properties.VariableNames = {'Time' 'A3' 'A2' 'A1'};
% 
% tableK = readtable("RUN3.xlsx", 'VariableNamingRule','preserve');
% tableK.Properties.VariableNames = {'Time' 'A3' 'A2' 'A1'};
% 
% writetable(tableI, 'RUN1.csv')
% writetable(tableJ, 'RUN2.csv')
% writetable(tableK, 'RUN3.csv')
% 
% tableL = readtable("SHOVEL1.xlsx", 'VariableNamingRule','preserve');
% tableL.Properties.VariableNames = {'Time' 'A3' 'A2' 'A1'};
% 
% tableM = readtable("SHOVEL2.xlsx", 'VariableNamingRule','preserve');
% tableM.Properties.VariableNames = {'Time' 'A3' 'A2' 'A1'};
% 
% tableN = readtable("SHOVEL3.xlsx", 'VariableNamingRule','preserve');
% tableN.Properties.VariableNames = {'Time' 'A3' 'A2' 'A1'};
% 
% writetable(tableL, 'SHOVEL1.csv')
% writetable(tableM, 'SHOVEL2.csv')
% writetable(tableN, 'SHOVEL3.csv')
% 
% 
% tableO = readtable("WALK1.xlsx", 'VariableNamingRule','preserve');
% tableO.Properties.VariableNames = {'Time' 'A3' 'A2' 'A1'};
% 
% tableP = readtable("WALK2.xlsx", 'VariableNamingRule','preserve');
% tableP.Properties.VariableNames = {'Time' 'A3' 'A2' 'A1'};
% 
% tableQ = readtable("WALK3.xlsx", 'VariableNamingRule','preserve');
% tableQ.Properties.VariableNames = {'Time' 'A3' 'A2' 'A1'};
% 
% writetable(tableO, 'WALK1.csv')
% writetable(tableP, 'WALK2.csv')
% writetable(tableQ, 'WALK3.csv')
% 
% tableR = readtable("WEIGHT1.xlsx", 'VariableNamingRule','preserve');
% tableR.Properties.VariableNames = {'Time' 'A3' 'A2' 'A1'};
% 
% tableS = readtable("WEIGHT2.xlsx", 'VariableNamingRule','preserve');
% tableS.Properties.VariableNames = {'Time' 'A3' 'A2' 'A1'};
% 
% tableT = readtable("WEIGHT3.xlsx", 'VariableNamingRule','preserve');
% tableT.Properties.VariableNames = {'Time' 'A3' 'A2' 'A1'};
% 
% writetable(tableR, 'WEIGHT1.csv')
% writetable(tableS, 'WEIGHT2.csv')
% writetable(tableT, 'WEIGHT3.csv')

tableS = readtable("NOISE75sec.xlsx", 'VariableNamingRule','preserve');
tableS.Properties.VariableNames = {'Time' 'A3' 'A2' 'A1'};

writetable(tableS, 'NOISE.csv')
