# PIR_QUAGLIA_Giovanni

The PIR objective was the design and validation of a Low Fidelity structural model of the NASA CRM wing starting from an original Hgh Fidelity model.
The mesh simplification was performed in MATLAB. The correlation analysis between the fidelity was conducted in Python using the [OpenMDAO framework](https://github.com/OpenMDAO/OpenMDAO1) and in particular the package [aerostructures](https://github.com/mid2SUPAERO/aerostructures).
Aerostructures was modified and the adapted version is present in branch g.quaglia. The aeroelastc problem is solved in a partitioned approach using [Panair](http://www.pdas.com/panair.html) and [Nastran95](https://github.com/nasa/NASTRAN-95).

[Matlab_tool](https://github.com/mid2SUPAERO/PIR_QUAGLIA_Giovanni/tree/master/Matlab_tool) contains MainCreatePlanes.m and MainCreateMesh.m which respectively are used to sort the nodes of the original FEM model and to create the LF model.
[Python_validation_codes](https://github.com/mid2SUPAERO/PIR_QUAGLIA_Giovanni/tree/master/Python_validation_codes) contains nastran_panair_mda_cruise.py and nastran_panair_complete.py used to run the static aeroelastic problem also with geometrical changes.

Tutorials:

- Sorting the CRM wing original model: https://htmlpreview.github.io/?https://github.com/mid2SUPAERO/PIR_QUAGLIA_Giovanni/blob/master/Tutorials/MainCreatePlanes.html

- Design of the LF model: https://htmlpreview.github.io/?https://github.com/mid2SUPAERO/PIR_QUAGLIA_Giovanni/blob/master/Tutorials/MainCreateMesh.html

- Static aeroelastic simulation:
