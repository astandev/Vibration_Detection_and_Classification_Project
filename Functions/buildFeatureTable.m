function [ytable] = buildFeatureTable(xtable,z)
%BUILDFEATURETABLE Summary of this function goes here
ytable = zeros(z,32);
for k = 1:z
    ytable(k,:) = featureExtraction(xtable(k,:));
end
end

function [feat] = featureExtraction(data)
%FEATUREEXTRACTION performs statistical analysis to extract features from
%Vibration data
fs = 500;
T = 1/fs;
L = length(data);
t = (0:L-1)*T;
Mag = FourierTransform(data,fs,t);
energy = topEnergy(Mag);
% Initialize feature vector
feat = zeros(1,32);
% Average value of top 10% of energy from vibration data
feat(1) = mean(energy);

% Standard deviation of top 10% of energy from vibration data
feat(2) = std(energy,1);

% Max of Frequency Domain of vibration data
feat(3) = max(energy);

% Variance of top 10% of energy from vibration data
feat(4) = var(energy,1);

% Skewness is the third central moment of X, divided by the cube of its standard deviation.
feat(5) = skewness(Mag);

% Kurtosis is the fourth central moment of X, divided by fourth power of its standard deviation.
feat(6) = kurtosis(Mag);

% RMS value of vibration data
feat(7) = rms(data);

% Mean Freq of Vibration data
feat(8) = meanfreq(data,fs);

% Median Freq of Vibration data
feat(9) = medfreq(data,fs);

% Peak to Peak is the difference between the largest and smallest element in X.
feat(10) = peak2peak(data);

% Peak to RMS is the ratio between the largest absolute value and root mean squared value in X.
feat(11) = peak2rms(data);

% # of maximums in Frequency data of vibration data
feat(12) = numel(findpeaks(Mag));


% Spectral peak features (12 each): height and position of first 6 peaks
feat(13:24) = spectralPeaksFeatures(data, fs);

% Autocorrelation features for vibrtaion data 
% height of main peak; height and position of second peak
feat(25:27) = autocorrFeatures(data, fs);

% Spectral power features (5 each): total power in 5 adjacent
% and pre-defined frequency bands
feat(28:32) = spectralPowerFeatures(data, fs);

% --- Helper functions
function feats = spectralPeaksFeatures(x, fs)

feats = zeros(1,12);
N = 4096;

mindist_units = 0.3;
minpkdistance = floor(mindist_units/(fs/N));

% Cycle through number of channels
nfinalpeaks = 6;
i=1;
    [psd, f] = pwelch(x,rectwin(length(x)),[],N,fs);
    [pks,locs] = findpeaks(psd,'npeaks',20,'minpeakdistance',minpkdistance);
    opks = zeros(nfinalpeaks,1);
    if(~isempty(pks))
        mx = min(6,length(pks));
        [spks, idx] = sort(pks,'descend');
        slocs = locs(idx);

        pkssel = spks(1:mx);
        locssel = slocs(1:mx);

        [olocs, idx] = sort(locssel,'ascend');
        opks = pkssel(idx);
    end
    ofpk = f(olocs);

    % Features 1-6 positions of highest 6 peaks
    feats(12*(i-1)+(1:length(opks))) = ofpk;
    % Features 7-12 power levels of highest 6 peaks
    feats(12*(i-1)+(7:7+length(opks)-1)) = opks;
end

function feats = autocorrFeatures(x, fs)

feats = zeros(1,1);
i=1;
minprom = 0.0005;
mindist_xunits = 0.3;
minpkdistance = floor(mindist_xunits/(1/fs));

% Separate peak analysis for 3 different channels

    [c, lags] = xcorr(x);

    [pks,locs] = findpeaks(c,...
        'minpeakprominence',minprom,...
        'minpeakdistance',minpkdistance);

    tc = (1/fs)*lags;
    tcl = tc(locs);

    % Feature 1 - peak height at 0
    if(~isempty(tcl))   % else f1 already 0
        feats((i-1)+1) = pks((end+1)/2);
    end
    % Features 2 and 3 - position and height of first peak 
    if(length(tcl) >= 3)   % else f2,f3 already 0
        feats((i-1)+2) = tcl((end+1)/2+1);
        feats((i-1)+3) = pks((end+1)/2+1);
    end
end

function feats = spectralPowerFeatures(x, fs)

edges = [0.5, 1.5, 5, 10, 15, 20];

[psd, f] = periodogram(x,[],4096,fs);

featstmp = zeros(5,1);

for kband = 1:length(edges)-1
    featstmp(kband,:) = sum(psd( (f>=edges(kband)) & (f<edges(kband+1)), :),1);
end
feats = featstmp(:);
end

function [Mag,f] = FourierTransform(X,Fs,t)
%FOURIERTRANSFORM Summary of this function goes here
L = length(t);
f = Fs*(0:round(L/2))/L;
Y = fft(X);
P2 = abs(Y/L);
Mag = P2(1:round(L/2)+1);
Mag(2:end-1) = 2*Mag(2:end-1);
end

function [Y] = topEnergy(X)
%TOPENERGY Summary of this function goes here
a = max(X);
b = 0.60*a;
c = X <= a & X >= b;
Y = X(c);
end
end
