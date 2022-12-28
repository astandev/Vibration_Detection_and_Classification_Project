# Vibration_Detection_and_Classification_Project
ENGIN 491/492 Project Materials

I.	APPENDIX

Troubleshooting Table
Problem Observed	Possible Reason	Solution
Drastically abnormal values	The normal range of values (received by the RPI) is centered around 2048, if there are values +- 2000 off from 2048 there may be an issue with the soldering connections	Check the soldering connections on both the PCB and the geophones. These joints are fragile and our team has had to resolder them multiple times. 
Error when running code in real-time	The values streamed into the RPI should be in three columns, sometimes these columns are merged or extended by accident. 	Check that this is indeed the issue and modify the code to delete any rows that have more than 4 columns. 
Classifications are incorrect	Different ground mediums significantly affect how the vibration signals are received. If the machine learning algorithm is trained on signals from a particular area it may misclassify those same signals if they are received via a different ground medium. 	Design a library to train a ML model for a particular location or find a way to remove the transform function of the ground medium via code.


A.	List of Materials 
•	3 wired geophones
•	1 PCB
•	1 Arduino Due
•	1 Raspberry Pi 3 B+
•	1 12V battery
•	Source Code
•	Signal Library
The three wired geophones are our data acquisition devices and should be connected directly to the PCB. This PCB adds a DC offset so that both the peaks and the troughs of the signals can be captured. This PCB is then sent to the Arduino Due for analog to digital conversion (note: our team found that it was necessary to use the Arduino Due since it has an excellent A/D converter and the Raspberry Pi does not have any analog inputs). These digital signals are now sent to the Raspberry Pi where they are run through Python code and assigned a class. This whole system is powered by the 12V battery, and the only component that needs to be directly tied to the battery is the Raspberry Pi. The GUI and resulting classification will display on the Raspberry Pi screen although it is possible to display the Raspberry Pi desktop on an external monitor. 
Operation Manual:
	Open the “source code” python file on the Raspberry Pi desktop and run it. This should display the GUI and it will continuously run until stopped. This code is thoroughly commented, so refer to the comments for any further questions about the code. The signal library used to train the machine learning algorithm should be in the same folder as the source code file. Below, in figure 13, is a conceptual flowchart for how the code is supposed to run in real time.  

 
Figure 13 – Conceptual flowchart of the Python code

B.	Previously Unsuccessful Approaches
Throughout this project our team tried several different approaches in order to implement our classification algorithm. Our team wanted to originally have the feature extraction and machine learning algorithm all created by MatLab. Our team was successfully able to create a feature extraction process and  a machine learning model in MatLab, but we were unable to implement it in real time. We investigated converting the MatLab code to C code with the “MatLab C Coder” application but we were unable to convert the code. We also tried to use the “MatLab Application Compiler” in order to export our pretrained machine learning model as an application that could run independently of MatLab on a Raspberry Pi. We were also unsuccessful with this approach. Finally, our team tried to run the signal capture and machine learning algorithm on the Arduino by implementing Simulink, but this was also unsuccessful. Our team would encourage any future teams to research if any of these approaches seem viable, since they all seem more accurate than coding the project in Python. All of our MatLab code can be found in the same folder as this README and the source code file. 

C.	Possible Design Improvements
Our team has several design improvements that we would like to suggest to any future teams. First of all we would like to suggest an expansion of both the geophones and the nodes. One improvement would be to implement wireless geophones, as well as adding 3 nodes instead of 1 (as our early prototype diagrams show). We believe this would greatly increase the range of the sensors and create a better security system. As well as this we would like to suggest adding acoustic sensors or visual sensors. This could act as a “verification” method for incoming signals. If both the geophones and the acoustic sensors classify a signal as “RUNNING” then we will be able to classify the observed signal with much more certainty than before. 
	Our team would also like to suggest that any future teams expand the signal database used to train the machine learning algorithm. A larger signal database would create an even more accurate machine learning algorithm. We would also suggest that any future teams consider the transform functions of differing ground mediums and their affects on observed signals. We have theorized that if a team were to obtain the transfer function of a particular ground medium, then they could filter out this transfer function from all received signals (for more information on this topic research “signal processing”, “convolution”, and “ transform function”). 
Our team would also suggest that a future team should buy a better battery. The one we have currently implemented runs for about 10 hours, and a longer battery life would greatly improve the usability of the system. 
Finally, our team would suggest that future teams make it so the “source code” script runs at the startup of the Raspberry Pi. This would make the system appear more user-friendly to any soldiers or personnel that do not have coding experience. Our team decided not to implement this idea because we would like future teams to work on this project before we consider it “finished”. 
