import scipy.io as io
import numpy as np
from numpy.linalg import inv, det
from math import pow, pi, exp


def accuracy_metric(actual, predicted):
	correct = 0
	for i in range(len(actual)):
		if actual[i] == predicted[i]:
			correct += 1
	return correct / float(len(actual)) * 100.0

# For Bayes Decision Rule components
def mn(folder):
	return sum(folder)/float(len(folder))
def covar(folder):
    avg = mn(folder)
    covariance = sum([np.dot(np.array([x-avg]).T,np.array([x-avg])) for x in folder])/len(folder)
    return covariance
def cond_prob(sample, miu, sigma):
    sigma_det = det(sigma)
    sigma_inv = inv(sigma)
    exponent = exp(-1/2*np.dot(np.dot((sample-miu).T, sigma_inv),(sample-miu)))
    prob = 1/(pow(2*pi,4/2)*sigma_det)*exponent
    return prob
def prior_prob(folder, train_x):
    return len(folder)/len(train_x)
def discriminant_function(sample, miu, sigma, prior_prob):
    return cond_prob(sample, miu, sigma)*prior_prob

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
    d1_miu = mn(d1)
    d2_miu = mn(d2)
    d3_miu = mn(d3)
    d1_sigma = covar(d1)
    d2_sigma = covar(d2)
    d3_sigma = covar(d3)
    d1_pri = prior_prob(d1,train_x)
    d2_pri = prior_prob(d2,train_x)
    d3_pri = prior_prob(d3,train_x)
    # Validation on training data
    train_pred = []
    for x in train_x:
        d1_prob = discriminant_function(x,d1_miu,d1_sigma,d1_pri)
        d2_prob = discriminant_function(x,d2_miu,d2_sigma,d2_pri)
        d3_prob = discriminant_function(x,d3_miu,d3_sigma,d3_pri)
        if d1_prob >= d2_prob and d1_prob >= d3_prob:
            train_pred.append(1)
        elif d2_prob >= d1_prob and d2_prob >= d3_prob:
            train_pred.append(2)
        else:
            train_pred.append(3)
    accu = accuracy_metric(train_y,train_pred)
    print("In training set, accuracy is ",accu)
    print("Saving result in Bayes_Decision_Rule_result.txt...")
    # Output
    train_pred=[]
    for x in test_x:
        d1_prob = discriminant_function(x,d1_miu,d1_sigma,d1_pri)
        d2_prob = discriminant_function(x,d2_miu,d2_sigma,d2_pri)
        d3_prob = discriminant_function(x,d3_miu,d3_sigma,d3_pri)
        if d1_prob >= d2_prob and d1_prob >= d3_prob:
            train_pred.append(1)
        elif d2_prob >= d1_prob and d2_prob >= d3_prob:
            train_pred.append(2)
        else:
            train_pred.append(3)
    np.savetxt("Bayes_Decision_Rule_result.txt",np.array(train_pred))