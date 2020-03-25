# -*- coding: utf-8 -*-
"""
Created on Tue May 29 10:43:31 2018

@author: m.meliani
"""

import numpy as np
import matplotlib.pyplot as plt
from smt.applications.mfk import MFK, NestedLHS
from aerostructures import MFEGO
from modal_LF import ModalLF
from modal_HF import ModalHF
from openmdao.api import Problem


dim = 2
n = 7 # number of low and high-fidelity points
nlevel=2
ub0 = 30.
lb0 = 0.
ub1 = 70.
lb1 = 40.

costs = np.array([1,100]) # low and high-fidelity costs
initial_cost = np.sum(np.array(n)*costs)

def modal_HF(X):
    pb = Problem()
    pb.root = ModalHF()
    
    pb.setup()  
    print('###########')
    print('X',X) 
    
    pb['sweep'] = X[0]
    pb['b'] = X[1]
    pb.run() 
    res = 1/pb['mode_1_2_dist']
       
    return res

def modal_LF(X):
    pb = Problem()
    pb.root = ModalLF()
    
    pb.setup()  
    print('###########')
    print('X',X) 
    
    pb['sweep'] = X[0]
    pb['b'] = X[1]
    pb.run()  
    res = 1/pb['mode_1_2_dist']
       
    return res


#np.random.seed(1)
xlimits = np.array([[0.0, 1.0],[0.0, 1.0]])
X = NestedLHS(nlevel=nlevel, xlimits=xlimits)
Xc, Xe = X(n)

Xe[:,0] = Xe[:,0]*(ub0-lb0)+lb0
Xc[:,0] = Xc[:,0]*(ub0-lb0)+lb0
Xe[:,1] = Xe[:,1]*(ub1-lb1)+lb1
Xc[:,1] = Xc[:,1]*(ub1-lb1)+lb1

yc = np.zeros(2*n)
ye = np.zeros(n)

for i in range(n):
    ye[i] = modal_HF(Xe[i])
for i in range(2*n):    
    yc[i] = modal_LF(Xc[i])

print(Xe)
print(ye)

#time.sleep(5)

sm = MFK(theta0=np.array(Xe.shape[1]*[1.]), print_global = False)
sm.set_training_values(Xc, yc, name = 0)
sm.set_training_values(Xe, ye)
sm.train()


bounds=np.array([[lb0,ub0],[lb1,ub1]])
algo_EGO = MFEGO([modal_LF, modal_HF],sm,bounds, costs = costs)
#Running the EGO algorithm for n_iter
budget = 15
Y_min, sm = algo_EGO.run(budget)

target_level = algo_EGO.levels[-1]

print( "######################################")
print( "Optimization summary Modal CRM")
print( "###################################### \n\n\n")
      
#
#x = np.linspace(0.,1., 50)
#y = np.copy(x)
#xv, yv = np.meshgrid(x, y)
#
#x_test= np.array([np.ravel(xv), np.ravel(yv)]).T
#y_test = sm.predict_values(x_test)
#y_mse = sm.predict_variances      
#      
#fig = plt.figure()
#ax = fig.add_subplot(111, projection='3d')
#ax.plot_surface(xv, yv, y_test.reshape((50, 50)), label ='surrogate')
##ax.plot_surface(xv, yv, currin_LF(x_test).reshape((50,50)),label ='LF')
#ax.plot_surface(xv, yv, currin_HF(x_test).reshape((50,50)),label ='HF reference')
#
#plt.show()
#
print( "######################################")
print( "minimum found by ego x=",algo_EGO.doe_x[target_level][algo_EGO.doe_y[target_level].argmin()]," y=",algo_EGO.doe_y[target_level].min())

print( "######################################")
print( "Initial DOE \n\n\n")
fig1 = plt.figure()
ax1 = fig1.add_subplot(111)
ax1.scatter(Xc[:,0],Xc[:,1],\
            marker = 'd', c = "green",s=20, label ='initial cheap DOE')
ax1.scatter(Xe[:,0],Xe[:,1],\
            marker = 'o', c = "blue", s =40, label ='initial expensive DOE')
ax1.legend(loc=0)
plt.show()

print( "######################################")
print( "Updated DOE : End of Opitmization \n\n\n")
fig2 = plt.figure()
ax2 = fig2.add_subplot(111)
ax2.scatter(algo_EGO.doe_x[0][:,0],algo_EGO.doe_x[0][:,1],\
            marker = 'd', c = "green",s=20, label ='cheap DOE')
ax2.scatter(algo_EGO.doe_x[None][:,0],algo_EGO.doe_x[None][:,1],\
            marker = 'o', c = "blue", s =40, label ='expensive DOE')
ax2.scatter(algo_EGO.doe_x[target_level][algo_EGO.doe_y[target_level].argmin()][0],\
                           algo_EGO.doe_x[target_level][algo_EGO.doe_y[target_level].argmin()][1],\
                           c='red',marker = '*',s = 80, label ='opt')
ax2.legend(loc=0)

ax1.set_xlim(lb0-0.1,ub0+.1)
ax1.set_ylim(lb1-0.1,ub1+.1)
ax2.set_xlim(lb0-0.1,ub0+.1)
ax2.set_ylim(lb1-0.1,ub1+.1)
plt.show()

print("######################################")
print( "Gain figure \n\n\n")
fig3 = plt.figure()
ax3 = fig3.add_subplot(111)
ax3.plot(np.log(np.array(algo_EGO.cost_hist) + initial_cost), algo_EGO.gain, c = "black", marker = "o")
ax3.set_title("Gain vs cost graph")
ax3.set_xlabel("log(Total Cost)")
ax3.set_ylabel("Gain")
plt.show()



