import pandas as pd
import numpy as np

def DCoffset(x):
    res = 4095
    offset = 3.3 / 2
    out = ((x / res) * 3.3) - offset
    return out

def preprocess(filepath):
    data = pd.read_csv(filepath)  # Read from excel Vibration data

    A1 = data['G1_A0:1']  # Read from column 1 of geophone data
    A2 = data['G2_A1:1']  # Read from column 2 of geophone data
    A3 = data['G3_A2:1']  # Read from column 3 of geophone data
    time = data['time']  # Read time vector and assign to variable

    A1 = np.array(A1).T  # Transpose column to row
    A2 = np.array(A2).T  # Transpose column to row
    A3 = np.array(A3).T  # Transpose column to row
    time = np.array(time).T  # Transpose column to row

    # print(A1) 

    A1 = DCoffset(A1)
    A2 = DCoffset(A2)
    A3 = DCoffset(A3)

    table = np.vstack((A1, A2, A3))  # Combine 3 Geophone observations into one table
    return(table)
    # 
    # plt.subplot(311)
    # plt.plot(time, A1)
    # plt.subplot(312)
    # plt.plot(time, A2)
    # plt.subplot(313)
    # plt.plot(A3)
    # plt.show()

# table = preprocess(r'/home/pi/Desktop/ML/FH1.csv')
# print(table)