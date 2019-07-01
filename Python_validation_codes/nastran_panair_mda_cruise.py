# -*- coding: utf-8 -*-
"""
Created on Tue Mar 29 10:50:10 2016

@author: © Joan Mas Colomer
"""

from __future__ import print_function

import numpy as np

from openmdao.api import Problem, Group, IndepVarComp, ScipyGMRES, SqliteRecorder

from aerostructures import NastranStatic, DisplacementTransfer, Panair, LoadTransfer, Interpolation, StaticStructureProblemDimensions, StaticStructureProblemParams, AeroProblemDimensions, AeroProblemParams, NLGaussSeidel, GeometricalProperties

import time

if __name__ == "__main__":

    #Interpolation function type and setup
    #function_type = 'thin_plate'
    function_type = 'linear'
    bias = (1.,100.,1.)

    #Symmetry plane index
    sym_plane_index = 2

    case_name = 'alpha_c'

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

    na = aero_problem_dimensions.na
    network_info = aero_problem_dimensions.network_info

    node_coord = structure_problem_params.node_coord
    node_coord_all = structure_problem_params.node_coord_all

    apoints_coord = aero_problem_params.apoints_coord
    
    geom_propts = GeometricalProperties(Ln,Vn,tn,an,sn,t_0,l_0,s_0_tot,Ix_0_tot,Iy_0_tot)
    
    t = geom_propts.t
    a = geom_propts.a
    s = geom_propts.s
    Ix = geom_propts.Ix
    Iy = geom_propts.Iy
        
    top = Problem()
    top.root = root = Group()

    #Add independent variables
    root.add('wing_area', IndepVarComp('Sw', Sw), promotes=['*'])
    root.add('airspeed', IndepVarComp('V', V), promotes=['*'])
    root.add('air_density', IndepVarComp('rho_a', rho_a), promotes=['*'])
    root.add('Mach_number', IndepVarComp('Mach', Mach), promotes=['*'])
    root.add('angle_of_attack', IndepVarComp('alpha', alpha), promotes=['*'])
    root.add('wing_span', IndepVarComp('b', b), promotes=['*'])
    root.add('wing_chord', IndepVarComp('c', c), promotes=['*'])
    root.add('s_coord', IndepVarComp('node_coord', node_coord), promotes=['*'])
    root.add('s_coord_all', IndepVarComp('node_coord_all', node_coord_all), promotes=['*'])
    root.add('a_coord', IndepVarComp('apoints_coord', apoints_coord), promotes=['*'])
    root.add('load_factor', IndepVarComp('n', n), promotes=['*'])
    
    root.add('thicknesses', IndepVarComp('t', t), promotes=['*'])
    if an > 0:
        root.add('rod_sections', IndepVarComp('a', a), promotes=['*'])   
    root.add('bar_sections', IndepVarComp('s', s), promotes=['*'])
    root.add('first_moment_inertia', IndepVarComp('Ix', Ix), promotes=['*'])
    root.add('second_moment_inertia', IndepVarComp('Iy', Iy), promotes=['*'])

    root.add('inter', Interpolation(na, ns, function = function_type, bias = bias), promotes=['*'])

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
