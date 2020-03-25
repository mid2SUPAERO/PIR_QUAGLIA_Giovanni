# -*- coding: utf-8 -*-
"""
Created on Sat Sep 28 09:07:35 2019

@author: Giovanni Quaglia
"""

from __future__ import print_function

import numpy as np

from openmdao.api import Group, IndepVarComp, ScipyGMRES, ExecComp

from aerostructures import NastranDynamic, Interpolation, DynamicStructureProblemDimensions, DynamicStructureProblemPureParams, PlanformGeometry, AeroProblemDimensions, AeroProblemParams, StructureMesher, PanairMesher

class ModalHF(Group):
    """ An OpenMDAO base component to encapsulate aerostructure MDA """

    def __init__(self):
        
        super(ModalHF, self).__init__()
        #user_input1 = input('Enter the name of the nastran dynamic template, please\n')
        user_input1 = 'dynamic_template_HF'
        #user_input2 = input('Enter the name of the nastran input geometry, please\n')
        user_input2 = 'mesh_HF'
        #user_input3 = input('Enter the name of the nastran output, please\n')
        user_input3 = 'dynamic_HF'
        
        template_file = user_input1 + '.inp'
        nastran_geometry = user_input2 + '.inp'
        output_file = user_input3
    
        #Symmetry plane index
        sym_plane_index = 2
    
        #Interpolation function type and setup
        function_type = 'linear'
        bias_morph = (1.,1.,1.)
        
         #Airfoil file
        ref_airfoil_file = 'crm.eta65.unswept31.5deg.sharp.te.txt'
    
        #Number of wing sections
        n_sec = 8
        #Position (index) of the wing break
        b_sec = 4
    
        alpha_0 = 1.340
        
        b_0 = 58.7629 
        sweep_0 = 37.16
        
        b_baseline = 58.7629
    
        #Problem parameters
        Sw = 383.689555
        V = 252.16168
        rho_a = 0.38058496
        Mach = 0.85
        #alpha = 1.340
        #b = 58.7629
        c = 7.00532
        E = 6.89e10
        nu = 0.31
        rho_s = 2795.67
        n = 1.
        
        #Sectional properties (that are not design variables)
        y_le_baseline = np.array([0., 2.938145, 7.3453752, 10.8711746, 16.1598356, 20.5670658, 24.974296, 29.3815262])
        z_le = np.array([4.424397971, 4.44511389, 4.476187859, 4.501047142, 4.538335797, 4.569409766, 4.600483735, 4.631557704])
        c_0 = np.array([13.6189974, 11.9001794, 9.3216984,
                        7.2588628, 5.9643264, 4.8855376, 3.8067488, 2.72796])
        tc_0 = np.array([0.1542, 0.138, 0.1137, 0.1052, 0.0988, 0.0962, 0.0953, 0.095])
        th = tc_0*c_0
        camc = np.array([0.0003, 0.0012, 0.0037, 0.0095, 0.0146, 0.0158, 0.0161, 0.0009])
        
        
        M = 10
        eigr = 'INV'
        
        #Parameters to define the shell section
        t = np.array([.00635, .005334, .004572, .003302, .00254,
                      .001651, .01905, .01524, .0127, .009525, .00508, .00254])
    
        #Parameters to define the bar properties
        s = np.array([.0001636, .0003403, .0003097, .0005161, .0011355, 
                        .0001064])
        Ix = np.array([7.661e-09, 3.315e-08, 2.745e-08, 5.695e-07, 
                             3.691e-07, 2.421e-08])
        Iy = np.array([5.723e-08, 2.476e-07, 2.051e-07, 7.624e-08, 
                             2.757e-06, 3.24e-09])
        
        structure_problem_dimensions = DynamicStructureProblemDimensions(template_file)
        
        node_id_all = structure_problem_dimensions.node_id_all
        node_id = structure_problem_dimensions.node_id
        ns_all = structure_problem_dimensions.ns_all
        ns = structure_problem_dimensions.ns
        
        aero_problem_params = AeroProblemParams()
    
        aero_problem_dimensions = AeroProblemDimensions()
    
        na = aero_problem_dimensions.na
        na_unique = aero_problem_dimensions.na_unique
        network_info = aero_problem_dimensions.network_info
        
        tn = structure_problem_dimensions.tn
        mn = structure_problem_dimensions.mn
        sn = structure_problem_dimensions.sn
        an = structure_problem_dimensions.an
    
        structure_problem_params = DynamicStructureProblemPureParams(node_id,node_id_all,nastran_geometry)
        
        #node_coord_all = structure_problem_params.node_coord_all
        
        theta = np.array([6.691738003, 4.545042708, 2.793550837, 1.673916686,
                          0.754303126, 0.91369482, 1.136056807, 0.272576679])
    
        cr_0 = 13.6189974
    
        cb_0 = 7.2588628
    
        ct_0 = 2.72796
     
        #X-position of the leading edge at the root
        xr = 22.9690676
           
        #Coordinates of aerodynamic and structure matching meshes
        xa_b = aero_problem_params.apoints_coord_unique
        xs_b = structure_problem_params.node_coord_all
    
    
        #Add independent variables
        #root.add('number_of_normal_modes', IndepVarComp('M', M), promotes=['*'])
        #root.add('s_coord_all', IndepVarComp('node_coord_all', node_coord_all), promotes=['*'])
        self.add('thicknesses', IndepVarComp('t', t), promotes=['*']) 
        self.add('bar_sections', IndepVarComp('s', s), promotes=['*'])
        self.add('first_moment_inertia', IndepVarComp('Ix', Ix), promotes=['*'])
        self.add('second_moment_inertia', IndepVarComp('Iy', Iy), promotes=['*'])
        self.add('y_leading_edge_baseline', IndepVarComp('y_le_baseline', y_le_baseline), promotes=['*'])
        self.add('z_leading_edge', IndepVarComp('z_le', z_le), promotes=['*'])
        self.add('airfoil_thickness', IndepVarComp('th', th), promotes=['*'])
        self.add('camber_chord_ratio', IndepVarComp('camc', camc), promotes=['*'])
        self.add('base_aerodynamic_mesh', IndepVarComp('xa_b', xa_b), promotes=['*'])
        self.add('base_structure_mesh', IndepVarComp('xs_b', xs_b), promotes=['*'])
        self.add('cruise_load_factor', IndepVarComp('n', n), promotes=['*'])
        self.add('root_leading_edge_x', IndepVarComp('xr', xr), promotes=['*'])
        self.add('wing_twist', IndepVarComp('theta', theta), promotes=['*'])
        self.add('root_chord', IndepVarComp('cr', cr_0), promotes=['*'])
        self.add('break_chord', IndepVarComp('cb', cb_0), promotes=['*'])
        self.add('tip_chord', IndepVarComp('ct', ct_0), promotes=['*'])
        self.add('sweep_angle', IndepVarComp('sweep', sweep_0), promotes=['*'])
        self.add('wing_span', IndepVarComp('b', b_0), promotes=['*'])
        self.add('angle_of_attack', IndepVarComp('alpha', alpha_0), promotes=['*'])
        self.add('wing_area', IndepVarComp('Sw', Sw), promotes=['*'])
        self.add('Airspeed', IndepVarComp('V', V), promotes=['*'])
        self.add('air_density', IndepVarComp('rho_a', rho_a), promotes=['*'])
        self.add('Mach_number', IndepVarComp('Mach', Mach), promotes=['*'])
        self.add('baseline_wing_span', IndepVarComp('b_baseline', b_baseline), promotes=['*'])
        self.add('wing_chord', IndepVarComp('c', c), promotes=['*'])
    
        #Interpolation Components
        self.add('interp_struct_morph', Interpolation(ns_all, na_unique, function = function_type, bias = bias_morph))
        
        #Add disciplines to the group
        self.add('planform_geometry', PlanformGeometry(n_sec, b_sec), promotes=['*'])
        self.add('structures', NastranDynamic(node_id_all, template_file, output_file, tn, mn, sn, an, M, eigr , 0.,100.), promotes=['*'])
        self.add('aerodynamic_mesher', PanairMesher(n_sec, na, na_unique, network_info, ref_airfoil_file), promotes=['*'])
        self.add('structure_mesher', StructureMesher(na_unique, node_id, node_id_all), promotes=['*'])
        self.add('y_leading_edge', ExecComp(
            'y_le = b/b_baseline*y_le_baseline', y_le=np.zeros(len(y_le_baseline), dtype=float), y_le_baseline=np.zeros(len(y_le_baseline), dtype=float)), promotes=['*'])
    
        self.add('tc_ratio', ExecComp(
            'tc = th/chords', tc=np.zeros(n_sec, dtype=float), th=np.zeros(n_sec, dtype=float), chords=np.zeros(n_sec, dtype=float)), promotes=['*'])
    
        self.add('mode_1_2_dist', ExecComp(
            'mode_1_2_dist = eigval[1] - eigval[0]', eigval=np.zeros(M)), promotes=['*'])
    
        #Explicit connections
        self.connect('interp_struct_morph.H', 'G')
        self.connect('xa_b', 'interp_struct_morph.node_coord')
        self.connect('xs_b', 'interp_struct_morph.apoints_coord')
        
        #Define solver type
        self.ln_solver = ScipyGMRES()