import pandas as pd
import matplotlib.pyplot as plt
import numpy as np


def DCoffset(x):
    res = 4095
    offset = 3.3 / 2
    out = ((x / res) * 3.3) - offset
    return out

def topEnergy(x):
    a = max(x)
    b = 0.6 * a
    c = [(x <= a) & (x >= b)]
    Y = x[c]
    return Y

# def csv2table(data):
#
data = pd.read_csv(r'C:\Users\pc\PycharmProjects\UMassBoston\FH1.csv')  # Read from excel Vibration data

A1 = data['A1']  # Read from column 1 of geophone data
A2 = data['A2']  # Read from column 2 of geophone data
A3 = data['A3']  # Read from column 3 of geophone data
time = data['Time']  # Read time vector and assign to variable

A1 = np.array(A1).T  # Transpose column to row
A2 = np.array(A2).T  # Transpose column to row
A3 = np.array(A3).T  # Transpose column to row
time = np.array(time).T  # Transpose column to row

# print(A1)

A1 = DCoffset(A1)
A2 = DCoffset(A2)
A3 = DCoffset(A3)

table = np.vstack((A1, A2, A3))  # Combine 3 Geophone observations into one table
# print(table)

plt.subplot(311)
plt.plot(time, A1)
plt.subplot(312)
plt.plot(time, A2)
plt.subplot(313)
plt.plot(time, A3)
plt.show()

