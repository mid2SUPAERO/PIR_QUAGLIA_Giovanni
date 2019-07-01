# -*- coding: utf-8 -*-
"""
Created on Wed Jul 4 2018

@author: © Joan Mas Colomer
"""
from __future__ import print_function
import numpy as np

from aerostructures.number_formatting.is_number import isfloat, isint

#user_input = input('Enter the name of the nastran input file, please\n')
user_input = 'nastran_static_alpha_c'
inp = user_input + '.inp'
pnh = user_input + '.pnh'

node_coord = {}
elm = {}
displ = {}
principal_stress_1 = {}
principal_stress_2 = {}
von_mises_1 = {}
von_mises_2 = {}
von_mises = {}
VMmax = 0
elmmax = 0
xmax = 0
ymax = 0
zmax = 0
deltamax = 0
el_type = 0

#Open the .inp file and get the node coordinates and element connectivity table
with open(inp) as f:
    lines = f.readlines()

    for line in lines:
        #Detect Nastran free field (comma separated) or small field (8 character)
        if ',' in line:
            line = line.split(',')
        else:
            line = [line[i:i+8] for i in range(0, len(line), 8)]

        #Remove blank spaces
        line = [word.strip() for word in line]

        if len(line) > 1:
            if line[0] == 'GRID':
                node_coord[int(line[1])] = [float(line[3]), float(line[4]), float(line[5])]

            if line[0] == 'CTRIA3':
                elm[int(line[1])] = [int(line[3]), int(line[4]), int(line[5])]

            if line[0] == 'CQUAD4':
                elm[int(line[1])] = [int(line[3]), int(line[4]), int(line[5]), int(line[6])]
                
            if line[0] == 'CBAR':
                elm[int(line[1])] = [int(line[3]), int(line[4])]
                
            if line[0] == 'CROD':
                elm[int(line[1])] = [int(line[3]), int(line[4])]

#Read the Nastran punch file (.pnh) and extract displacement and stress data
with open(pnh) as f:
    lines = f.readlines()
    lines = [i.split() for i in lines]

    for i in range(len(lines)):
        if len(lines[i]) > 1:

            #Write nodal displacements onto u if the node belongs to the outer surface
            if lines[i][1] == 'G':
                displ[int(lines[i][0])] = [float(lines[i][2]), float(lines[i][3]), float(lines[i][4])]

            if isint(lines[i][0]) and isfloat(lines[i][1]):
                #Store stresses only if the element is of shell type:
                if lines[i+1][0] == '-CONT-' and lines[i+2][0] == '-CONT-' and lines[i+3][0] == '-CONT-' and lines[i+4][0] == '-CONT-' and lines[i+5][0] == '-CONT-':
                    #Write shell principal stresses (upper and lower shell faces)
                    principal_stress_1[int(lines[i][0])] = (float(lines[i+1][3]), float(lines[i+2][1]))
                    principal_stress_2[int(lines[i][0])] = (float(lines[i+4][2]), float(lines[i+4][3]))
                
                #bar elements
                elif lines[i+1][0] == '-CONT-' and lines[i+2][0] == '-CONT-' and lines[i+3][0] == '-CONT-' and lines[i+4][0] == '-CONT-':
                    von_mises_1[int(lines[i][0])] = (float(lines[i+1][2]))
                
                #rod elements
                elif lines[i+1][0] == '-CONT-':
                    von_mises_1[int(lines[i][0])] = (float(lines[i][1]))
                    
#Store the maximum von Mises stress between the upper and lower surface
for elm_id in elm.keys():
    if len(elm[elm_id]) == 3 or len(elm[elm_id]) == 4:
        von_mises_1[elm_id] = np.sqrt(principal_stress_1[elm_id][0]**2 - principal_stress_1[elm_id][0]*principal_stress_1[elm_id][1] + principal_stress_1[elm_id][1]**2)
        von_mises_2[elm_id] = np.sqrt(principal_stress_2[elm_id][0]**2 - principal_stress_2[elm_id][0]*principal_stress_2[elm_id][1] + principal_stress_2[elm_id][1]**2)
        von_mises[elm_id] = max(von_mises_1[elm_id], von_mises_2[elm_id])
    else:
        von_mises[elm_id] = abs(von_mises_1[elm_id])
    
    if von_mises[elm_id] > VMmax:
         VMmax = von_mises[elm_id]
         elmmax = elm_id
        
if len(elm[elmmax]) == 4:
    el_type = 4
    xmax = (node_coord[elm[elmmax][0]][0]+node_coord[elm[elmmax][1]][0]+node_coord[elm[elmmax][2]][0]+node_coord[elm[elmmax][3]][0])/4
    ymax = (node_coord[elm[elmmax][0]][1]+node_coord[elm[elmmax][1]][1]+node_coord[elm[elmmax][2]][1]+node_coord[elm[elmmax][3]][1])/4
    zmax = (node_coord[elm[elmmax][0]][2]+node_coord[elm[elmmax][1]][2]+node_coord[elm[elmmax][2]][2]+node_coord[elm[elmmax][3]][2])/4       
elif len(elm[elmmax]) == 3:
    el_type = 3
    xmax = (node_coord[elm[elmmax][0]][0]+node_coord[elm[elmmax][1]][0]+node_coord[elm[elmmax][2]][0])/3
    ymax = (node_coord[elm[elmmax][0]][1]+node_coord[elm[elmmax][1]][1]+node_coord[elm[elmmax][2]][1])/3
    zmax = (node_coord[elm[elmmax][0]][2]+node_coord[elm[elmmax][1]][2]+node_coord[elm[elmmax][2]][2])/3          
if len(elm[elmmax]) == 2:
    el_type = 2
    xmax = (node_coord[elm[elmmax][0]][0]+node_coord[elm[elmmax][1]][0])/2
    ymax = (node_coord[elm[elmmax][0]][1]+node_coord[elm[elmmax][1]][1])/2
    zmax = (node_coord[elm[elmmax][0]][2]+node_coord[elm[elmmax][1]][2])/2  
        

with open(user_input+'_post.msh','w') as f:
    f.write('$MeshFormat\n')
    f.write('2.2 0 8\n')
    f.write('$EndMeshFormat\n')
    f.write('$Nodes\n')
    f.write(str(len(node_coord))+'\n')

    #The new node coordinates are warped according to the displacements
    for node_id in node_coord.keys():
        f.write(str(node_id)+' '+str(node_coord[node_id][0]+displ[node_id][0])+' '+str(node_coord[node_id][1]+displ[node_id][1])+' '+str(node_coord[node_id][2]+displ[node_id][2])+'\n')
        if node_coord[node_id][2]+displ[node_id][2] > deltamax:
            deltamax = node_coord[node_id][2]+displ[node_id][2]
        
    f.write('$EndNodes\n')
    f.write('$Elements\n')
    f.write(str(len(elm))+'\n')

    for elm_id in elm.keys():
        #For CTRIA3 elements
        if len(elm[elm_id]) == 3:
            f.write(str(elm_id)+' '+str(2)+' '+str(0)+' '+str(elm[elm_id][0])+' '+str(elm[elm_id][1])+' '+str(elm[elm_id][2])+'\n')

        #For CQUAD elements
        elif len(elm[elm_id]) == 4:
            f.write(str(elm_id)+' '+str(3)+' '+str(0)+' '+str(elm[elm_id][0])+' '+str(elm[elm_id][1])+' '+str(elm[elm_id][2])+' '+str(elm[elm_id][3])+'\n')
        
        #For CBAR and CROD elements
        elif len(elm[elm_id]) == 2:
            f.write(str(elm_id)+' '+str(1)+' '+str(0)+' '+str(elm[elm_id][0])+' '+str(elm[elm_id][1])+'\n')

    f.write('$EndElements\n')
    f.write('$ElementData\n')
    f.write('1\n')
    f.write('"Von Mises Stress"\n')
    f.write('1\n')
    f.write('0.0\n')
    f.write('3\n')
    f.write('0\n')
    f.write('1\n')
    f.write(str(len(von_mises))+'\n')

    for elm_id in von_mises.keys():
        f.write(str(elm_id)+' '+str(von_mises[elm_id])+'\n')

    f.write('$EndElementData\n')
    print('Von Mises max = ' + str(VMmax) + 'Tip displacement = ' + str(deltamax))
    f.write('\n$Von Mises max = ' + str(VMmax) + ' at X = [' + str(xmax) + ', ' + str(ymax) + ', ' + str(zmax) + ' ]  in an element type = ' + str(el_type) + '\n')
    f.write('$Tip displacement = ' + str(deltamax) +'\n')
    
    
    
