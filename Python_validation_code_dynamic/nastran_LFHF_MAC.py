# -*- coding: utf-8 -*-
"""
Created on Sun Sep 29 08:55:00 2019

@author: Giovanni Quaglia
"""

from __future__ import print_function

import numpy as np

from openmdao.api import Problem, Group, IndepVarComp, ScipyGMRES, ExecComp

from aerostructures import NastranDynamic, Interpolation, AeroProblemParams, AeroProblemDimensions, AllToOuter, ModalFunctions, PlanformGeometry, DynamicStructureProblemDimensions, DynamicStructureProblemParams, DynamicStructureProblemPureParams, GeometricalProperties, InterpolationFidelity, ModeTransfer, PanairMesher, StructureMesher

if __name__ == "__main__":

    user_input = input('Enter the name of the case, please\n')
    #user_input1 = input('Enter the name of the nastran dynamic LF template, please\n')
    user_input1 = 'dynamic_template_LF'
    #user_input2 = input('Enter the name of the nastran dynamic HF template, please\n')
    user_input2 = 'dynamic_template_HF'
    #user_input3 = input('Enter the name of the nastran input geometry, please\n')
    user_input3 = 'mesh_LF'   
    #user_input4 = input('Enter the name of the nastran reference geometry, please\n')
    user_input4 = 'dynamic_HF'
    #user_input5 = input('Enter the name of the nastran output, please\n')
    user_input5 = 'dynamic_LF' + user_input

    #user_input6 = 'results'    
    
    template_file = user_input1 + '.inp'
    template_file_ref = user_input2 + '.inp'
    nastran_geometry = user_input3 + '.inp'
    nastran_geometry_ref = user_input4 + user_input + '.inp'
    output_file = user_input5
    res_file = 'results_' + user_input + '.txt'
    nastran_modal_ref = 'dynamic_HF' + user_input
    
    #Interpolation function type and setup
    bias_morph = (1.,1.,1.)
    
    #Airfoil file
    ref_airfoil_file = 'crm.eta65.unswept31.5deg.sharp.te.txt'
    #Symmetry plane index
    sym_plane_index = 2
    
    #Interpolation parameters
    function_type = 'linear'
    bias = (1.,100.,1.)
    
    #Number of wing sections
    n_sec = 8
    #Position (index) of the wing break
    b_sec = 4

    alpha_0 = 1.340
    
    b_0 = 58.7629
    sweep_0 = 37.16 - 2.5
    
    b_baseline = 58.7629

    #Problem parameters
    Sw = 383.689555
    V = 252.16168
    rho_a = 0.38058496
    Mach = 0.85
    alpha = 1.340
    b = 58.7629
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
    
    M = 30
    N = 10
    eigr = 'INV'
    mass_ratio = 1.
    omega_ratio = 1.
    
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
    
    #Dimensions of the low fidelity model
    structure_problem_dimensions = DynamicStructureProblemDimensions(template_file)
    
    node_id_all = structure_problem_dimensions.node_id_all
    node_id = structure_problem_dimensions.node_id
    ns_all = structure_problem_dimensions.ns_all
    
    ns = structure_problem_dimensions.ns
    tn = structure_problem_dimensions.tn
    mn = structure_problem_dimensions.mn
    sn = structure_problem_dimensions.sn
    an = structure_problem_dimensions.an
    Ln = structure_problem_dimensions.Ln
    Vn = structure_problem_dimensions.Vn
    BC = structure_problem_dimensions.BC
    
    aero_problem_params = AeroProblemParams()

    aero_problem_dimensions = AeroProblemDimensions()

    na = aero_problem_dimensions.na
    na_unique = aero_problem_dimensions.na_unique
    network_info = aero_problem_dimensions.network_info

    #Coordinates of the low fidelity model mesh and reference
    structure_problem_params = DynamicStructureProblemPureParams(node_id,node_id_all,nastran_geometry)
    
    node_coord_all = structure_problem_params.node_coord_all
    node_coord = structure_problem_params.node_coord
    
    #Define geometrical properties for the low fidelity model
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
    
    #Dimensions of the high fidelity model
    structure_problem_dimensions_ref = DynamicStructureProblemDimensions(template_file_ref)
    
    node_id_all_ref = structure_problem_dimensions_ref.node_id_all
    ns_all_ref = structure_problem_dimensions_ref.ns_all
    node_id_ref = structure_problem_dimensions_ref.node_id
    ns_ref = structure_problem_dimensions_ref.ns

    #Coordinates and reference analysis of the high fidelity model
    structure_problem_params_ref = DynamicStructureProblemParams(node_id_ref,node_id_all_ref,N,nastran_geometry_ref,nastran_modal_ref)
    
    node_coord_all_ref = structure_problem_params_ref.node_coord_all
    node_coord_ref = structure_problem_params_ref.node_coord
    phi_ref_all = structure_problem_params_ref.phi_ref_all
    phi_ref = structure_problem_params_ref.phi_ref
    eigval_ref = structure_problem_params_ref.eigval_ref
    mass_ref = structure_problem_params_ref.mass_ref
    
    top = Problem()
    top.root = root = Group()
    
    #Coordinates of aerodynamic and structure matching meshes
    xa_b = aero_problem_params.apoints_coord_unique
    xs_b = structure_problem_params.node_coord_all
    
    #Add independent variables
    #root.add('number_of_normal_modes', IndepVarComp('M', M), promotes=['*'])
    root.add('phi_ref',IndepVarComp('phi_ref',phi_ref), promotes=['*'])
    root.add('BC',IndepVarComp('BC',BC),promotes=['*'])
    root.add('mass_ref',IndepVarComp('mass_ref',mass_ref), promotes=['*'])
    root.add('mass_ratio',IndepVarComp('mass_ratio',mass_ratio), promotes=['*'])
    root.add('omega_ratio',IndepVarComp('omega_ratio',omega_ratio), promotes=['*'])
    root.add('eigval_ref',IndepVarComp('eigval_ref',eigval_ref), promotes=['*'])
    root.add('thicknesses', IndepVarComp('t', t), promotes=['*']) 
    root.add('rod_sections', IndepVarComp('a', a), promotes=['*']) 
    root.add('bar_sections', IndepVarComp('s', s), promotes=['*'])
    root.add('first_moment_inertia', IndepVarComp('Ix', Ix), promotes=['*'])
    root.add('second_moment_inertia', IndepVarComp('Iy', Iy), promotes=['*'])
    root.add('y_leading_edge_baseline', IndepVarComp('y_le_baseline', y_le_baseline), promotes=['*'])
    root.add('base_aerodynamic_mesh', IndepVarComp('xa_b', xa_b), promotes=['*'])
    root.add('base_structure_mesh', IndepVarComp('xs_b', xs_b), promotes=['*'])
    root.add('z_leading_edge', IndepVarComp('z_le', z_le), promotes=['*'])
    root.add('airfoil_thickness', IndepVarComp('th', th), promotes=['*'])
    root.add('camber_chord_ratio', IndepVarComp('camc', camc), promotes=['*'])
    root.add('root_leading_edge_x', IndepVarComp('xr', xr), promotes=['*'])
    root.add('wing_twist', IndepVarComp('theta', theta), promotes=['*'])
    root.add('root_chord', IndepVarComp('cr', cr_0), promotes=['*'])
    root.add('break_chord', IndepVarComp('cb', cb_0), promotes=['*'])
    root.add('tip_chord', IndepVarComp('ct', ct_0), promotes=['*'])
    root.add('sweep_angle', IndepVarComp('sweep', sweep_0), promotes=['*'])
    root.add('wing_span', IndepVarComp('b', b_0), promotes=['*'])
    root.add('angle_of_attack', IndepVarComp('alpha', alpha_0), promotes=['*'])
    root.add('baseline_wing_span', IndepVarComp('b_baseline', b_baseline), promotes=['*'])
    root.add('node_coord_ref',IndepVarComp('node_coord_ref',node_coord_ref),promotes=['*'])

    root.add('y_leading_edge', ExecComp(
        'y_le = b/b_baseline*y_le_baseline', y_le=np.zeros(len(y_le_baseline), dtype=float), y_le_baseline=np.zeros(len(y_le_baseline), dtype=float)), promotes=['*'])
    root.add('tc_ratio', ExecComp(
        'tc = th/chords', tc=np.zeros(n_sec, dtype=float), th=np.zeros(n_sec, dtype=float), chords=np.zeros(n_sec, dtype=float)), promotes=['*'])
    #Interpolation Components
    root.add('interp_struct_morph', Interpolation(ns_all, na_unique, function = function_type, bias = bias_morph))
    #Add disciplines to the group
    root.add('planform_geometry', PlanformGeometry(n_sec, b_sec), promotes=['*'])
    root.add('aerodynamic_mesher', PanairMesher(n_sec, na, na_unique, network_info, ref_airfoil_file), promotes=['*'])
    root.add('structure_mesher', StructureMesher(na_unique, node_id, node_id_all), promotes=['*'])
    #Interpolation matrix H between LF and HF (LFdim = H*HFdim)
    root.add('inter', InterpolationFidelity(ns, ns_ref, function = function_type, bias = bias), promotes=['*'])
    #Nastran
    root.add('structures', NastranDynamic(node_id_all, template_file, output_file, tn, mn, sn, an, M, eigr , 0.,100.), promotes=['*'])
    #Projection of the reference high fidelity modes on the low fidelity space
    root.add('mode_transfer',ModeTransfer(ns_ref,ns,N),promotes=['*'])
    #Reducing LF eigenvectors to the surface
    root.add('all_to_out', AllToOuter(node_id_all,node_id,M),promotes=['*'])
    #Computation of the MAC
    root.add('modal_function',ModalFunctions(ns,N,M,res_file),promotes=['*'])

    #Explicit connections
    root.connect('interp_struct_morph.H', 'G')
    root.connect('xa_b', 'interp_struct_morph.node_coord')
    root.connect('xs_b', 'interp_struct_morph.apoints_coord')
    #Define solver type
    root.ln_solver = ScipyGMRES()

    top.setup()
    top.run()
