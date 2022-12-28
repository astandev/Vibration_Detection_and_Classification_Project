import preprocess as pp
import feature_extraction as fx
import numpy as np
import ML as ml
import time


import serial
if __name__ == '__main__':
    ser = serial.Serial('/dev/ttyACM0', 9600, timeout=1)
    ser.flush()
    while True:
        if ser.in_waiting > 0:
            Data = ser.readline().rstrip()
            print(Data)

data_file= open("Input_Data.csv","w")
data_file.write("Data")
time.sleep(5)




preprocessed_data = pp.preprocess(r'/home/pi/Desktop/ML/FH1.csv')
# print(fx.feature_extraction(preprocessed_data[1]))

rows = len(preprocessed_data)
# columns = len(preprocessed_data[0])
num_of_features = 32

feature_list = [[0]*num_of_features]*rows

for i in range(rows):
    feature_list[i] = fx.feature_extraction(preprocessed_data[i])

print(feature_list)
# im having an issue right here im not sure why, but everything above this line looks
# accurate and functions well, im trying to used the trained model (in ML.py)
# and to run a new feature list through it but it is not working
# could be that there arent necessarily "rows" in the above feature_list
# could be that there isnt a global variable somewhere
# the ML code has the split of the test/ training turned off currently
# so im using the entire feature list to train it and then trying to use
# my features (from the code here to test it)

# correction
# it seems my code can assign a class pretty well
# but it is having trouble creating a confusion matrix
# could be that Y (the labels from the TRAINING dataset
# is not the same length or its a global variable
# or im using the wrong variable there
# something like that 
# 
# re = ml.ML(feature_list)
# 
# print(re)


