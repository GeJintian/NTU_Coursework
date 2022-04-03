import scipy.io as io
import numpy as np
from numpy.linalg import eig
import heapq



def accuracy_metric(actual, predicted):
	correct = 0
	for i in range(len(actual)):
		if actual[i] == predicted[i]:
			correct += 1
	return correct / float(len(actual)) * 100.0

def mn(folder):
    return sum(folder)/len(folder)
def Si(folder):
    avg = mn(folder)
    return sum([np.dot(np.array([x-avg]).T,np.array([x-avg])) for x in folder])
def Sw(d1,d2,d3):
    return Si(d1)+Si(d2)+Si(d3)
def Sb(train_x, d1,d2,d3):
    avg = mn(train_x)
    avg1 = mn(d1)
    avg2 = mn(d2)
    avg3 = mn(d3)
    return len(d1)*np.dot((avg1-avg).T,avg1-avg)+len(d2)*np.dot((avg2-avg).T,avg2-avg)+len(d3)*np.dot((avg3-avg).T,avg3-avg)
def cal_w(Sb,Sw):
    value, vector = eig(np.dot(Sw.T,Sb))
    order = heapq.nlargest(2, range(len(value)), value.take)
    return vector[order[0]], vector[order[1]]
def g(sample, w):
    return np.dot(w,sample.T)
def mn_proj(folder,w):
    return sum([g(x,w) for x in folder])/len(folder)
def cal_w0(w,d1,d2,d3):
    m_list = np.array([mn_proj(d1,w),mn_proj(d2,w),mn_proj(d3,w)])
    m_a, m_b, m_L = np.sort(m_list)
    if abs(m_L-m_a)<=abs(m_L-m_b):
        w0 = -1/2*(m_a+m_L)
    else:
        w0 = -1/2*(m_b+m_L)
    return w0
def discriminant_function(w,w0,sample):
    return np.dot(w,sample.T)+w0

if __name__ == "__main__":
    # TODO: if you want to place dataset in other directory, modify the path here.
    train_x = io.loadmat("Data_Train.mat")["Data_Train"]
    train_y = io.loadmat("Label_Train.mat")["Label_Train"]
    test_x = io.loadmat("Data_test.mat")["Data_test"]
    # Create folders
    d1 = []
    d2 = []
    d3 = []
    for i in range(len(train_x)):
        if train_y[i][0] == 1:
            d1.append(train_x[i])
        elif train_y[i][0] == 2:
            d2.append(train_x[i])
        else:
            d3.append(train_x[i])
    # Calculate parameters
    sw = Sw(d1,d2,d3)
    sb = Sb(train_x,d1,d2,d3)
    w1,w2 = cal_w(sb,sw)
    w10 = cal_w0(w1,d1,d2,d3)
    w20 = cal_w0(w2,d1,d2,d3)
    # Validation on training data
    train_pred = []
    for x in train_x:
        g1 = discriminant_function(w1,w10,x)
        g2 = discriminant_function(w2,w20,x)
        if g1<=0 and g2<=0:
            train_pred.append(3)
        elif g1>g2:
            train_pred.append(1)
        else:
            train_pred.append(2)
    accu = accuracy_metric(train_y,train_pred)
    print("In training set, accuracy is ",accu)
    print("Saving result in Decision_Tree_result.txt...")
    # Output
    train_pred=[]
    for x in test_x:
        g1 = discriminant_function(w1,w10,x)
        g2 = discriminant_function(w2,w20,x)
        if g1<=0 and g2<=0:
            train_pred.append(3)
        elif g1>g2:
            train_pred.append(1)
        else:
            train_pred.append(2)
    np.savetxt("Decision_Tree_result.txt",np.array(train_pred))