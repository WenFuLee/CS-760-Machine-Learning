import numpy as np
import sys
import csv
def main() :
	class_prob = sys.argv[1]
	class_name = sys.argv[2]
	instance_generate(class_prob,class_name)

def zero_one(prob_one):
	x = np.random.choice(np.arange(0,2),p = [1-prob_one,prob_one])
	return x

def instance_generate(class_prob,class_name):
	class_set = []
	prob_list = class_prob.split(',')
	# generate 100 instance for each class
	for i in range(0,100):
		newins = []
		i = 0
		for single_prob in prob_list: 
			temp_value = zero_one(float(single_prob))
			if i == 24:
				if newins[-1] == 1 :
					temp_value = 0
			if i == 25:
				if newins [-1] == 1:
					temp_value = 0
				elif newins[-1] == 0 and float(single_prob) >0 :
					if newins[23] == 1:
						temp_value = 0 
					else :
						temp_value = 1
				else:
					temp_value = 0
			if class_name == 'baseball' and i == 29 :
				if newins[-1] == 1:
					temp_value = 0
				else :
					temp_value = 1
			if class_name == 'baseball'  and i == 30 :
				if newins[-1] == 1 :
					temp_value = 0 
				elif newins[-1] == 0 and newins[-2] == 0:
					temp_value = 1 
				else :
					temp_value = 0
			newins.append(temp_value)
		if sum(newins) >= 5 :
			class_set.append(newins)
		else:
			continue
	print len(class_set)			
	with open('mlinstancetag.csv','a') as output:
		writer = csv.writer(output,lineterminator = '\n')
		writer.writerows(class_set)

	


main()


	
