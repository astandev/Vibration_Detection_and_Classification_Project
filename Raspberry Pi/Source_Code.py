
import time
import threading
import serial
import pandas as pd
import numpy as np
import csv
import scipy
from scipy import signal
import decimal
from scipy.fftpack import fft
from scipy.stats import skew
import statistics as st
from tkinter import*
import time as tm 


################################################## PREPROCESS ##########################################################




def DCoffset(x):
    res = 4095
    offset = 3.3 / 2
    out = ((x / res) * 3.3) - offset
    return out

def preprocess(filepath):
    data = pd.read_csv(filepath, error_bad_lines= False)  # Read from excel Vibration data/ Ignores bad lines
    data= data.fillna(0)
    
#     
#     A1= data.iloc[:,2].values
#     A2= data.iloc[:,1].values
#     A3= data.iloc[:,0].values
     
    

    A1 = data['A3']  # Read from column 1 of geophone data
    A2 = data['A2']  # Read from column 2 of geophone data
    A3 = data['A1']  # Read from column 3 of geophone data
    
     
    
    A1 = np.array(A1).T  # Transpose column to row
    A2 = np.array(A2).T  # Transpose column to row
    A3 = np.array(A3).T  # Transpose column to row


    A1 = DCoffset(A1)
    A2 = DCoffset(A2)
    A3 = DCoffset(A3)

    table = np.vstack((A1, A2, A3))# Combine 3 Geophone observations into one table

    return(table)





################################################### FEATURE EXTRACTION #####################################






# data = pd.read_csv('FH_table.csv')
# data_test = data.iloc[1]
# print(data_test)

def float_range(start, stop, step):
    while start<stop:
        yield float(start)
        start+= decimal.Decimal(step)

def FourierTransform(X, Fs, t0):
    L0 = len(t0)
    L1= L0/2
#     global new_f0
#     global Mag

    f0= (list(float_range(0,round(L1),'1')))
    old_f0 = [num1*Fs for num1 in f0]
    new_f0= [num2/L0 for num2 in old_f0]
#     print(new_f0)
    Y = fft(X)
    P2 = abs(Y/L0)
    temp=list(range(0,round(L1)))
    Mag = (P2[temp])
#     print(Mag)
    Mag[1:-1]= 2*Mag[1:-1]
#     print(Mag)
#     print(len(Mag))
    return [new_f0,Mag]
    
def topEnergy(x):
    global Y
    a = max(x)
    b = 0.6 * a
    c = [(x <= a) & (x >= b)]
    Y = x[tuple(c)]
    return Y

def meanfreq(x, fs):
    f, Pxx_den = signal.periodogram(x, fs)                                                    
    Pxx_den = np.reshape( Pxx_den, (1,-1) ) 
    width = np.tile(f[1]-f[0], (1, Pxx_den.shape[1]))
    f = np.reshape(f, (1, -1))
    P = Pxx_den * width
    pwr = np.sum(P)

    mnfreq = np.dot(P, f.T)/pwr

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
############################################################# GUI IMPLEMENTATION ############################################################

win=Tk()  # Creating window for the GUI
win.title("Geophone Sensors Activities")     #GUI Title
# win.attributes('-fullscreen',True) # Having the GUI Full Screen
win.minsize(1000,500)
win.configure(bg="#022a39")#Backgroung color for the GUI
ExitButton= Button(win,text="Close App",command=win.destroy,borderwidth= 0, bg="#00c1ef",fg="white", height=1, width=7)  #Creating Exit button to close GUI
ExitButton.pack(side=TOP,anchor=NE)  #Placement for the GUI exit button (NE= Top Left Corner)

 #time
Time_label= Label(win,text="Time", bg="#00c1ef",fg="white") #Creating a label called "Time" to be displayed on the GUI
Time_label.pack(side=TOP,anchor=NE) # Placement of "Time" label (Top Left Corner)
Current_time=tm.strftime('%I:%M:%S:%p') # Reading Actual Time of the Rasperry pi
Clock_label= Label(win, bg="#022a39",fg="white",text= Current_time) # Creating a label called "Current_time"
Clock_label.pack(side=TOP,anchor=NE) #Placement of "Current_time" label
# 
# 
# Predict the test set results
global Pred_label1 # Making "Pred_label1" (Pred_label1 = Prediction label 1)label global so it can be used outside of its main module
global Lb_Pred1    # Making "Lb_Pred1" label global so it can be used outside of its main module
	
#print(Y_Pred)
Pred_label1=Label(win,bg="#00c1ef",fg="white", text="Sensor 1",borderwidth=3,relief= "ridge", padx=10, pady=15, font= 10) # Creating Prediction label (name) for Sensor 1
Lb_Pred1= Label(win, bg="#022a39",fg="green2", font=30) # Creating label for the actual prediction
Pred_label1.pack(side=TOP) #Placement for sensor 1 label on the GUI
Lb_Pred1.place(relx=0.5, rely=0.3, anchor=CENTER) #Placement for Sensor 1 prediction on the GUI

### Same thing is done for the other two sensors

	# Predict the test set results
global Pred_label2
global Lb_Pred2
	#print(Y_Pred)
Pred_label2=Label(win,bg="#00c1ef",fg="white", text="Sensor 2",borderwidth=3,relief= "ridge", padx=10, pady=15, font= 10)
Lb_Pred2= Label(win, bg="#022a39",fg="green2")
Pred_label2.place(relx=0.1, rely=0.5, anchor=CENTER)
Lb_Pred2.place(relx=0.1, rely=0.6, anchor=CENTER)

global Pred_label3
global Lb_Pred3
	#print(Y_Pred)
Pred_label3=Label(win,bg="#00c1ef",fg="white", text="Sensor 3",borderwidth=3,relief= "ridge", padx=10, pady=15, font= 10)
Lb_Pred3= Label(win, bg="#022a39",fg="green2")
Pred_label3.place(relx=0.9, rely=0.5, anchor=CENTER)
Lb_Pred3.place(relx=0.9, rely=0.6, anchor=CENTER)

# History Tab

def Open_History(): # Creating a function for history to be called when the history button is pressed
    global close_his
    global my_his
    my_his= Text(win, width= 50, height= 20, bg= "darkslategray", fg= "white") # Creating the background for the history file in the GUI
    my_his.pack() #Placing of the background
    his_file = open("History.txt", 'r') # Reading History file
    content= his_file.read() # Passing the history file to variable "content" to be displayed on the GUI
    my_his.insert(END,content) # Passing content to GUI
    close_his= Button(win,text="Close History", command= His_close, borderwidth= 2, bg="orange",fg="black", height=2, width=9)# Bring up a "close history button" after the history button is prssed
    close_his.pack() # Placement of closing history button
    His_Button['state']= DISABLED # Disabling history button after it's been pressed, it can't be pressed again until history is closed off
    Lb_Pred1.place_forget()  # Temporarily erase the prediction labels
    Pred_label1.pack_forget() # ''
    Lb_Pred2.place_forget() #''
    Pred_label2.place_forget() # ''
    Pred_label3.place_forget() # ''
    Lb_Pred3.place_forget() # ''
    

def His_close(): #Creating function for the "close history" button
    my_his.destroy() #Closing history
    close_his.destroy() # Closing "close history" button 
    His_Button['state']=NORMAL #Enabling history button again
    Pred_label1.pack(side=TOP) # Bring all the labels back
    Lb_Pred1.place(relx=0.5, rely=0.3, anchor=CENTER) # ''
    Pred_label2.place(relx=0.1, rely=0.5, anchor=CENTER) # ''
    Lb_Pred2.place(relx=0.1, rely=0.6, anchor=CENTER) # ''
    Pred_label3.place(relx=0.9, rely=0.5, anchor=CENTER) # ''
    Lb_Pred3.place(relx=0.9, rely=0.6, anchor=CENTER)  # ''



### BUTTON ###

His_Button= Button(win, text="History", command= Open_History, bg="#00c1ef",fg="white",borderwidth= 2 ,height=4, width=8) # Creating History button, when pressed calls the function "Open_History"
His_Button.pack(side= BOTTOM) #placement of history button on the GUI









################################################### DATA COLLECTION & FEATURE LIST MAKING & MACHINE LEARNING MODEL/CLASSIFICATION ALGORITHM (KNN) #####################################


num_line=1502 # Collecting 1502 samples from Arduino

i=0
Header_list= ['A3','A2','A1'] # Creating headers for the csv file

def repeat():
    line=0
    threading.Timer(15,repeat).start() # Loop overwriting csv file every 15 seconds
    if __name__ == '__main__':
        ser = serial.Serial('/dev/ttyACM0', 115200, timeout=1) # Connecting to Arduino, Baud-rate = 115200 bytes per second
        ser.flush() #flushes any input and output buffer, so it will avoid receiving or sending weird/not useful/not complete data at the beginning of the communication
        with open("Input_Data.csv",'w') as data_file: #Creating csv file for data coming from arduino
            hd= csv.DictWriter(data_file,delimiter=',', fieldnames=Header_list) # Writing headers to csv file
            hd.writeheader()
            while line <=num_line: #Loop, making sure to collect 1502 samples
                if ser.in_waiting > 0:
                    getData=str(ser.readline().rstrip().decode('utf-8','ignore')) #Reading Data from Arduiono
                    Data = getData[0:][:]
                    data_file.write((Data) + "\n") #Writing Data into the csv file
                    line=line+1 #Wrinting data on different lines
                    print(getData)
                    # threading.Timer(7,rep).start()
        preprocessed_data = preprocess("Input_Data.csv") # Passing csv file to the preprocessing module
        rows = len(preprocessed_data)
        num_of_features = 10
        feature_list = [[0]*num_of_features]*rows
        for i in range(rows):
            feature_list[i] = feature_extraction(preprocessed_data[i])
        print(feature_list)
        
        ####### Machine Learing ######                          
        
        dataset = pd.read_csv('python_training_dataV2.csv') # TRAINING DATA
        X = dataset.iloc[:, 0:10].values # X DATA
        Y = dataset.iloc[:, 10].values #Y DATA WHICH CONTAINS THE CLASSES

        from sklearn.preprocessing import StandardScaler
        sc = StandardScaler()
        X = sc.fit_transform(X)
        feature_list= sc.transform(feature_list)
#

        from sklearn.neighbors import KNeighborsClassifier
        classifier = KNeighborsClassifier(n_neighbors = 5)
        classifier.fit(X, Y)
        global Y_Pred
        
#     
        Y_Pred = classifier.predict(feature_list)
        
        Sensor1= Y_Pred[0]
        Sensor2= Y_Pred[1]
        Sensor3= Y_Pred[2]
        
        print(Sensor1)
        print(Sensor2)
        print(Sensor3)
        
    global his_file
    his_file = open("History.txt", 'a+') # Appending into history file
    his_file.write("\n  -------Activity Detected -------\n"  )
        
    his_file.write(" Sencor-1 Prediction : %s \n" % (Y_Pred[0])) #Saving Predictions into history file
    his_file.write(" Sencor-2 Prediction : %s \n" % (Y_Pred[1])) # ''
    his_file.write(" Sencor-3 Prediction : %s \n" % (Y_Pred[2]))# ''
    his_file.write(" Time =" + Current_time +'\n') # Also sanving the time
        
        
    Lb_Pred1["text"]=Y_Pred[0] #Passing Predictions to GUI
    Lb_Pred2["text"]=Y_Pred[1] # ''
    Lb_Pred3["text"]=Y_Pred[2] # ''
        
        
repeat()

win.mainloop()


