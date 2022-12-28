import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import scipy
from scipy import signal
import decimal
from scipy.fftpack import fft
from scipy.stats import skew
import statistics as st
import math as m
import csv


def DCoffset(x):  # Converts Digital Values to Analog and removes DC Offset creating equilibrium at 0 for signals
    res = 4095
    offset = 3.3 / 2
    out = ((x / res) * 3.3) - offset
    return out


def csv2tableV2(datapath, z):  # Reads from cvs file and puts preprocessed signals into row vectors
    data = pd.read_csv(datapath)  # Read from excel Vibration data

    A1 = data['A1']  # Read from column 1 of geophone data
    A2 = data['A2']  # Read from column 2 of geophone data
    A3 = data['A3']  # Read from column 3 of geophone data
    time = data['Time']  # Read time vector and assign to variable

    A1 = np.array(A1).T  # Transpose column to row
    A2 = np.array(A2).T  # Transpose column to row
    A3 = np.array(A3).T  # Transpose column to row
    time = np.array(time).T  # Transpose column to row

    # plt.subplot(311)
    # plt.plot(time, A1)
    # plt.subplot(312)
    # plt.plot(time, A2)
    # plt.subplot(313)
    # plt.plot(time, A3)
    # plt.show()

    a, c = 1500, 1501  # Variable represent the number of data points per observation, for this function we used
    # Sample rate of 500 Hz so 500 samples per sec, so 1500 samples would be 3 sec observations of the vibrations

    B1 = np.zeros((z, 1501))  # Create an empty Zx1501 matrix that will be used to fill with preprocessed A1 data
    B2 = np.zeros((z, 1501))  # Create an empty Zx1501 matrix that will be used to fill with preprocessed A2 data
    B3 = np.zeros((z, 1501))  # Create an empty Zx1501 matrix that will be used to fill with preprocessed A3 data

    B1[0] = A1[0:1501]  # Fill row 0 of B1 with rows 0 to 1500 of A1
    B2[0] = A2[0:1501]  # Fill row 0 of B2 with rows 0 to 1500 of A2
    B3[0] = A3[0:1501]  # Fill row 0 of B3 with rows 0 to 1500 of A3

    B1[1] = A1[1500:3001]  # Fill row 1 of B1 with rows 1500 to 3000 of A1
    B2[1] = A2[1500:3001]  # Fill row 1 of B2 with rows 1500 to 3000 of A2
    B3[1] = A3[1500:3001]  # Fill row 1 of B3 with rows 1500 to 3000 of A3

    for k in range(2, z):  # This FOR loop runs through the remaining rows of A1, A2, A3 and puts 1501 samples to each
        # Row of B1, B2, B3
        B1[k] = A1[(k * a):((1 + k) * a) + 1]
        B2[k] = A2[(k * a):((1 + k) * a) + 1]
        B3[k] = A3[(k * a):((1 + k) * a) + 1]

    B1 = DCoffset(B1)   # Convert Digital values to Analog and remove DC Offset
    B2 = DCoffset(B2)   # Convert Digital values to Analog and remove DC Offset
    B3 = DCoffset(B3)   # Convert Digital values to Analog and remove DC Offset

    table = np.vstack((B1, B2, B3)) # Concatenate into one table stacked from B1 to B3
    return table


def float_range(start, stop, step):
    while start < stop:
        yield float(start)
        start += decimal.Decimal(step)


def FourierTransform(X, Fs, t0):    # Performs Fourier Transform of vibration data
    L0 = len(t0)
    L1 = L0 / 2
    #     global new_f0
    #     global Mag

    f0 = (list(float_range(0, round(L1), '1')))
    old_f0 = [num1 * Fs for num1 in f0]
    new_f0 = [num2 / L0 for num2 in old_f0]
    #     print(new_f0)
    Y = fft(X)
    P2 = abs(Y / L0)
    temp = list(range(0, round(L1)))
    Mag = (P2[temp])
    #     print(Mag)
    Mag[1:-1] = 2 * Mag[1:-1]
    #     print(Mag)
    #     print(len(Mag))
    return [new_f0, Mag]


def topEnergy(x):   # Uses Logical Indexing to check which values are greater than or equal to 60% of max value
    a = np.amax(x)
    b = 0.6 * a
    c = [(x <= a) & (x >= b)]
    Y = x[tuple(c)]
    return Y


def meanfreq(x, fs):    # Computes the mean frequency
    f, Pxx_den = signal.periodogram(x, fs)
    Pxx_den = np.reshape(Pxx_den, (1, -1))
    width = np.tile(f[1] - f[0], (1, Pxx_den.shape[1]))
    f = np.reshape(f, (1, -1))
    P = Pxx_den * width
    pwr = np.sum(P)

    mnfreq = np.dot(P, f.T) / pwr

    return mnfreq


def feature_extraction(data_test):  # Extract features from input data
    fs = (500)
    T = 1 / fs
    L = float(len(data_test))

    t = (list(float_range(0, (L - 1), '1')))
    new_t = [num / fs for num in t]
    [f, Mag] = FourierTransform(data_test, fs, new_t)

    energy = topEnergy(Mag)

    feature_list = [0] * 10  # Create empty Feature Vector

    feature_list[0] = np.mean(energy)  # Mean

    feature_list[1] = st.stdev(Mag)  # Standard Deviation of FFT

    feature_list[2] = max(energy)  # Max

    feature_list[3] = st.pvariance(Mag)  # Variance of FFT

    feature_list[4] = scipy.stats.skew(Mag, axis=0, bias=True)  # Skewness of FFT

    feature_list[5] = scipy.stats.kurtosis(Mag, axis=0, fisher=True, bias=True,
                                           nan_policy='propagate')  # Kurtosis of FFT

    feature_list[6] = np.sqrt(np.mean(data_test ** 2))  # RMS

    feature_list[7] = data_test.max(0) - data_test.min(0)  # Peak to Peak

    feature_list[8] = (abs(data_test)).max(0) / (np.sqrt(np.mean(data_test ** 2)))  # Peak to RMS

    feature_list[9] = scipy.signal.find_peaks(Mag)[0].size  # Number of Maxima

    return feature_list


def buildFeatureTable(data, z): # Concatenates all the features into one table 
    table = np.zeros((z, 10))
    for i in range(0, z):
        table[i] = feature_extraction(data[i])
    return table


WALK1table = csv2tableV2(r'C:\Users\pc\PycharmProjects\UMassBoston\WALK1.csv', 27)
WALK2table = csv2tableV2(r'C:\Users\pc\PycharmProjects\UMassBoston\WALK2.csv', 27)
WALK3table = csv2tableV2(r'C:\Users\pc\PycharmProjects\UMassBoston\WALK3.csv', 27)

# print(WALK1table)

RUN1table = csv2tableV2(r'C:\Users\pc\PycharmProjects\UMassBoston\RUN1.csv', 27)
RUN2table = csv2tableV2(r'C:\Users\pc\PycharmProjects\UMassBoston\RUN2.csv', 27)
RUN3table = csv2tableV2(r'C:\Users\pc\PycharmProjects\UMassBoston\RUN3.csv', 27)

JUMP1table = csv2tableV2(r'C:\Users\pc\PycharmProjects\UMassBoston\JUMP1.csv', 27)
JUMP2table = csv2tableV2(r'C:\Users\pc\PycharmProjects\UMassBoston\JUMP2.csv', 27)
JUMP3table = csv2tableV2(r'C:\Users\pc\PycharmProjects\UMassBoston\JUMP3.csv', 27)

SHOVEL1table = csv2tableV2(r'C:\Users\pc\PycharmProjects\UMassBoston\SHOVEL1.csv', 27)
SHOVEL2table = csv2tableV2(r'C:\Users\pc\PycharmProjects\UMassBoston\SHOVEL2.csv', 27)
SHOVEL3table = csv2tableV2(r'C:\Users\pc\PycharmProjects\UMassBoston\SHOVEL3.csv', 27)

WEIGHT1table = csv2tableV2(r'C:\Users\pc\PycharmProjects\UMassBoston\WEIGHT1.csv', 27)
WEIGHT2table = csv2tableV2(r'C:\Users\pc\PycharmProjects\UMassBoston\WEIGHT2.csv', 27)
WEIGHT3table = csv2tableV2(r'C:\Users\pc\PycharmProjects\UMassBoston\WEIGHT3.csv', 27)

NOISE1table = csv2tableV2(r'C:\Users\pc\PycharmProjects\UMassBoston\NOISE.csv', 25)
# print(NOISE1table)

featureTable = np.zeros((1290, 10))

featureTable[0:81] = buildFeatureTable(WALK1table, 81)
featureTable[81:162] = buildFeatureTable(WALK2table, 81)
featureTable[162:243] = buildFeatureTable(WALK3table, 81)

featuresWALK = featureTable[0:243]

featureTable[243:324] = buildFeatureTable(RUN1table, 81)
featureTable[324:405] = buildFeatureTable(RUN2table, 81)
featureTable[405:486] = buildFeatureTable(RUN3table, 81)

featureTable[486:567] = buildFeatureTable(JUMP1table, 81)
featureTable[567:648] = buildFeatureTable(JUMP2table, 81)
featureTable[648:729] = buildFeatureTable(JUMP3table, 81)

featureTable[729:810] = buildFeatureTable(SHOVEL1table, 81)
featureTable[810:891] = buildFeatureTable(SHOVEL2table, 81)
featureTable[891:972] = buildFeatureTable(SHOVEL3table, 81)

featureTable[972:1053] = buildFeatureTable(WEIGHT1table, 81)
featureTable[1053:1134] = buildFeatureTable(WEIGHT2table, 81)
featureTable[1134:1215] = buildFeatureTable(WEIGHT3table, 81)

featureTable[1215:1291] = buildFeatureTable(NOISE1table, 75)

walk = 'Walking'
run = 'Running'
jump = 'Jumping'
shovel = 'Shovel'
weight = 'Weight Dropped'
noise = 'Noise'

fields = ['MEAN', 'STD', 'MAX', 'VAR', 'SKEWNESS', 'KURTOSIS', 'RMS', 'PEAK2PEAK', 'PEAK2RMS', '# OF MAXIMA']
filename = "python_training_data.csv"

with open(filename, 'w', newline='') as csvfile:
    csvwriter = csv.writer(csvfile)
    csvwriter.writerow(fields)
    csvwriter.writerows(featureTable)
