import pandas as pd
import numpy as np
import scipy
from scipy import signal
import decimal
from scipy.fftpack import fft
from scipy.stats import skew
import statistics as st


# data = pd.read_csv('FH_table.csv')
# data_test = data.iloc[1]
# print(data_test)

def float_range(start, stop, step):
    while start < stop:
        yield float(start)
        start += decimal.Decimal(step)


def FourierTransform(X, Fs, t0):
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


def topEnergy(x):
    a = max(x)
    b = 0.6 * a
    c = [(x <= a) & (x >= b)]
    Y = x[tuple(c)]
    return Y


def meanfreq(x, fs):
    f, Pxx_den = signal.periodogram(x, fs)
    Pxx_den = np.reshape(Pxx_den, (1, -1))
    width = np.tile(f[1] - f[0], (1, Pxx_den.shape[1]))
    f = np.reshape(f, (1, -1))
    P = Pxx_den * width
    pwr = np.sum(P)

    mnfreq = np.dot(P, f.T) / pwr

    return mnfreq


def feature_extraction(data_test):
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