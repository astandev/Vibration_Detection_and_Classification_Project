# import necessary libraries
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

# import data
dataset = pd.read_csv('featureTable.csv')
# X = features (Age, Salary)
# Y = classification labels (bought or not)
X = dataset.iloc[:, 0:32].values
Y = dataset.iloc[:, 33].values

# # split dataset into training and test sets
from sklearn.model_selection import train_test_split
X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size = 0.3, random_state = 0)

# standardized the data so huge salaries and small ages won't affect calculated distance bewtween datapoints
from sklearn.preprocessing import StandardScaler
sc = StandardScaler()
X = sc.fit_transform(X)
# X_test = sc.transform(X_test)

# train the model
from sklearn.neighbors import KNeighborsClassifier
classifier = KNeighborsClassifier(n_neighbors = 3)
classifier.fit(X, Y)

def ML(X_test):
    global Y_Pred
    global cm
    Y_Pred = classifier.predict(sc.transform(X_test))
    from sklearn.metrics import confusion_matrix
    cm = confusion_matrix(Y_test, Y_Pred)
    return(Y_Pred)
           #, cm)

result = ML(X_test)
print(Y_Pred)
print(Y_test)
print(cm)

# # 
# # Visualising the Training set results
# from matplotlib.colors import ListedColormap
# X_set, y_set = X_train, Y_train
# X1, X2 = np.meshgrid(np.arange(start = X_set[:, 0].min() - 1, stop = X_set[:, 0].max() + 1, step = 0.01),
#                      np.arange(start = X_set[:, 1].min() - 1, stop = X_set[:, 1].max() + 1, step = 0.01))
# plt.contourf(X1, X2, classifier.predict(np.array([X1.ravel(), X2.ravel()]).T).reshape(X1.shape),
#              alpha = 0.75, cmap = ListedColormap(('red', 'green')))
# plt.xlim(X1.min(), X1.max())
# plt.ylim(X2.min(), X2.max())
# for i, j in enumerate(np.unique(y_set)):
#     plt.scatter(X_set[y_set == j, 0], X_set[y_set == j, 1],
#                 c = ListedColormap(('red', 'green'))(i), label = j)
# plt.title('Classifier (Training set)')
# plt.xlabel('Age')
# plt.ylabel('Estimated Salary')
# plt.legend()
# plt.show()
##





# 
# # Visualising the Test set results
# from matplotlib.colors import ListedColormap
# X_test, Y_test = X_train, Y_train
# X1, X2 = np.meshgrid(np.arange(start = X_test[:, 0].min() - 1, stop = X_test[:, 0].max() + 1, step = 0.01),
#                      np.arange(start = X_test[:, 1].min() - 1, stop = X_test[:, 1].max() + 1, step = 0.01))
# plt.contourf(X1, X2, classifier.predict(np.array([X1.ravel(), X2.ravel()]).T).reshape(X1.shape),
#              alpha = 0.75, cmap = ListedColormap(('red', 'green')))
# plt.xlim(X1.min(), X1.max())
# plt.ylim(X2.min(), X2.max())
# for i, j in enumerate(np.unique(Y_test)):
#     plt.scatter(X_test[Y_test == j, 0], X_test[Y_test == j, 1],
#                 c = ListedColormap(('red', 'green'))(i), label = j)
# plt.title('Classifier (Testing set)')
# plt.xlabel('Age')
# plt.ylabel('Estimated Salary')
# plt.legend()
# plt.show()