# -*- coding: utf-8 -*-
"""
Created on Tue Mar 29 10:50:10 2016

@author: © Joan Mas Colomer
"""

from __future__ import print_function

import numpy as np

from openmdao.api import Problem, Group, IndepVarComp, ScipyGMRES, SqliteRecorder, ExecComp

from aerostructures import NastranStatic, DisplacementTransfer, Panair, LoadTransfer, Interpolation, PanairMesher, StructureMesher, PlanformGeometry, StaticStructureProblemDimensions, AeroProblemDimensions, StaticStructureProblemParams, AeroProblemParams, NLGaussSeidel, GeometricalProperties

import time

if __name__ == "__main__":

    #Interpolation function type and setup
    function_type = 'linear'
    bias_morph = (1.,1.,1.)
    bias_inter = (1.,100.,1.)

    #Symmetry plane index
    sym_plane_index = 2
    case_name = 'alpha_c'
    #Number of wing sections
    n_sec = 8

    #Position (index) of the wing break
    b_sec = 4

    #Airfoil file
    ref_airfoil_file = 'crm.eta65.unswept31.5deg.sharp.te.txt'

    #Problem parameters
    #Speed of sound
    a = 297.4

    Sw = 383.689555
    V = 252.16168
    Mach = V/a
    rho_a = 0.38058496
    # h = 10500.
    alpha_0 = 1.340
    
    b_0 = 58.7629
    sweep_0 = 37.16
    
    b_baseline = 58.7629
    c = 7.00532
    E = 6.89e10
    nu = 0.31
    rho_s = 2795.67
    #Reference aircraft weight (mass units)
    W_ref = 226796.185
    #Wing weight (full span) of the reference aircraft (mass units)
    W_ref_wing = 26400.
    #Airframe weight (complete aircraft excluding wing structure, mass units)
    W_airframe = W_ref - W_ref_wing
    #Yield stress (can also be used as ultimate stress if FS = 1.5)
    sigma_y = 450.e6
    #Factor of safety
    FS = 1.
    #Cruise load factor
    n = 1.

    #Sectional properties (that are not design variables)
    y_le_baseline = np.array([0., 2.938145, 7.3453752, 10.8711746, 16.1598356, 20.5670658, 24.974296, 29.3815262])
    z_le = np.array([4.424397971, 4.44511389, 4.476187859, 4.501047142, 4.538335797, 4.569409766, 4.600483735, 4.631557704])
    c_0 = np.array([13.6189974, 11.9001794, 9.3216984,
                    7.2588628, 5.9643264, 4.8855376, 3.8067488, 2.72796])
    tc_0 = np.array([0.1542, 0.138, 0.1137, 0.1052, 0.0988, 0.0962, 0.0953, 0.095])
    th = tc_0*c_0
    camc = np.array([0.0003, 0.0012, 0.0037, 0.0095, 0.0146, 0.0158, 0.0161, 0.0009])
    
    
    
    #Parameters to define the rod section
    t_0 = np.array([.00635, .005334, .004572, .003302, .00254,
                  .001651, .01905, .01524, .0127, .009525, .00508, .00254]) 
    l_0 = np.array([.358097605120250,   .326274684415706,   .271148349471907,
                  .221233096812120,   .179653543701401,   .158489131881446])

    #Parameters to define the bar properties
    s_0_tot = np.array([.0035992, .0074866, .0003097, .0005161, .024981, 
                    .0001064, .0134186, .0027664 ])
    Ix_0_tot = np.array([1.68542e-07, 7.293e-07, 2.745e-08, 5.695e-07, 
                         8.1202e-06, 2.421e-08, 1.4807e-05, 6.2946e-07 ])
    Iy_0_tot = np.array([1.25906e-06, 5.4472e-06, 2.051e-07, 7.624e-08, 
                         6.0654e-05, 3.24e-09, 1.98224e-06, 8.424e-08])
    

    structure_problem_dimensions = StaticStructureProblemDimensions()
    aero_problem_dimensions = AeroProblemDimensions()

    ns = structure_problem_dimensions.ns
    ns_all = structure_problem_dimensions.ns_all
    node_id = structure_problem_dimensions.node_id
    node_id_all = structure_problem_dimensions.node_id_all
    n_stress = structure_problem_dimensions.n_stress
    
    tn = structure_problem_dimensions.tn
    mn = structure_problem_dimensions.mn
    sn = structure_problem_dimensions.sn
    an = structure_problem_dimensions.an
    Ln = structure_problem_dimensions.Ln
    Vn = structure_problem_dimensions.Vn

    
    structure_problem_params = StaticStructureProblemParams(node_id, node_id_all)
    aero_problem_params = AeroProblemParams()

    aero_problem_dimensions = AeroProblemDimensions()

    na = aero_problem_dimensions.na
    na_unique = aero_problem_dimensions.na_unique
    network_info = aero_problem_dimensions.network_info

    aero_problem_params = AeroProblemParams()

    geom_propts = GeometricalProperties(Ln,Vn,tn,an,sn,t_0,l_0,s_0_tot,Ix_0_tot,Iy_0_tot)
    
    t = geom_propts.t
    a = geom_propts.a
    s = geom_propts.s
    Ix = geom_propts.Ix
    Iy = geom_propts.Iy
    
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
    
    top = Problem()
    top.root = root = Group()

    #Add independent variables (parameters)
    root.add('wing_area', IndepVarComp('Sw', Sw), promotes=['*'])
    root.add('Airspeed', IndepVarComp('V', V), promotes=['*'])
    root.add('air_density', IndepVarComp('rho_a', rho_a), promotes=['*'])
    root.add('Mach_number', IndepVarComp('Mach', Mach), promotes=['*'])
    root.add('baseline_wing_span', IndepVarComp('b_baseline', b_baseline), promotes=['*'])
    root.add('wing_chord', IndepVarComp('c', c), promotes=['*'])
    root.add('Youngs_modulus', IndepVarComp('E', E), promotes=['*'])
    root.add('Poissons_ratio', IndepVarComp('nu', nu), promotes=['*'])
    root.add('material_density', IndepVarComp('rho_s', rho_s), promotes=['*'])
    root.add('airframe_mass', IndepVarComp('W_airframe', W_airframe), promotes=['*'])
    root.add('Tensile_Yield_Strength', IndepVarComp('sigma_y', sigma_y), promotes=['*'])
    root.add('factor_safety', IndepVarComp('FS', FS), promotes=['*'])
    root.add('y_leading_edge_baseline', IndepVarComp('y_le_baseline', y_le_baseline), promotes=['*'])
    root.add('z_leading_edge', IndepVarComp('z_le', z_le), promotes=['*'])
    root.add('airfoil_thickness', IndepVarComp('th', th), promotes=['*'])
    root.add('camber_chord_ratio', IndepVarComp('camc', camc), promotes=['*'])
    root.add('base_aerodynamic_mesh', IndepVarComp('xa_b', xa_b), promotes=['*'])
    root.add('base_structure_mesh', IndepVarComp('xs_b', xs_b), promotes=['*'])
    root.add('cruise_load_factor', IndepVarComp('n', n), promotes=['*'])
    root.add('root_leading_edge_x', IndepVarComp('xr', xr), promotes=['*'])
    root.add('wing_twist', IndepVarComp('theta', theta), promotes=['*'])
    root.add('root_chord', IndepVarComp('cr', cr_0), promotes=['*'])
    root.add('break_chord', IndepVarComp('cb', cb_0), promotes=['*'])
    root.add('tip_chord', IndepVarComp('ct', ct_0), promotes=['*'])
    root.add('sweep_angle', IndepVarComp('sweep', sweep_0), promotes=['*'])
    root.add('wing_span', IndepVarComp('b', b_0), promotes=['*'])
    root.add('angle_of_attack', IndepVarComp('alpha', alpha_0), promotes=['*'])

    
    root.add('thicknesses', IndepVarComp('t', t), promotes=['*'])
    if an > 0:
        root.add('rod_sections', IndepVarComp('a', a), promotes=['*'])   
    root.add('bar_sections', IndepVarComp('s', s), promotes=['*'])
    root.add('first_moment_inertia', IndepVarComp('Ix', Ix), promotes=['*'])
    root.add('second_moment_inertia', IndepVarComp('Iy', Iy), promotes=['*'])

    #Interpolation Components
    root.add('interp_struct_morph', Interpolation(ns_all, na_unique, function = function_type, bias = bias_morph))
    root.add('interp_mda', Interpolation(na, ns, function = function_type, bias = bias_inter), promotes=['*'])

    #Geometry and meshing Components
    root.add('planform_geometry', PlanformGeometry(n_sec, b_sec), promotes=['*'])
    root.add('aerodynamic_mesher', PanairMesher(n_sec, na, na_unique, network_info, ref_airfoil_file), promotes=['*'])
    root.add('structure_mesher', StructureMesher(na_unique, node_id, node_id_all), promotes=['*'])

    root.add('y_leading_edge', ExecComp(
        'y_le = b/b_baseline*y_le_baseline', y_le=np.zeros(len(y_le_baseline), dtype=float), y_le_baseline=np.zeros(len(y_le_baseline), dtype=float)), promotes=['*'])

    root.add('tc_ratio', ExecComp(
        'tc = th/chords', tc=np.zeros(n_sec, dtype=float), th=np.zeros(n_sec, dtype=float), chords=np.zeros(n_sec, dtype=float)), promotes=['*'])

    #Explicit connections
    root.connect('interp_struct_morph.H', 'G')
    root.connect('xa_b', 'interp_struct_morph.node_coord')
    root.connect('xs_b', 'interp_struct_morph.apoints_coord')

    mda = Group()

    #Add disciplines to the group
    mda.add('displacement_transfer', DisplacementTransfer(na, ns), promotes=['*'])
    mda.add('aerodynamics', Panair(na, network_info, case_name, sym_plane_index), promotes=['*'])
    mda.add('load_transfer', LoadTransfer(na, ns), promotes=['*'])
    mda.add('structures', NastranStatic(node_id, node_id_all, n_stress, tn, mn, sn, an, case_name), promotes=['*'])

    #Define solver type and tolerance for MDA
    mda.nl_solver = NLGaussSeidel()
    # mda.nl_solver.options['maxiter'] = 0
    mda.nl_solver.options['rutol'] = 1.e-2 #2 origin
    mda.nl_solver.options['use_aitken'] = True
    mda.nl_solver.options['aitken_alpha_min'] = 0.1
    mda.nl_solver.options['aitken_alpha_max'] = 1.5

    mda.ln_solver = ScipyGMRES()

    root.add('mda_group', mda, promotes=['*'])

    #Recorder
    recorder = SqliteRecorder('mda.sqlite3')
    recorder.options['record_metadata'] = False
    # recorder.options['includes'] =
    top.root.mda_group.nl_solver.add_recorder(recorder)

    #Define solver type
    root.ln_solver = ScipyGMRES()
    
    start1 = time.time()
    top.setup()
    end1 = time.time()
    
    start2 = time.time()
    top.run()
    end2 = time.time()
    
    print("Set up time = " + str(end1 - start1))
    print("Run time = " + str(end2 - start2))
