#!/usr/bin/python36

#sage --preparse functions.sage

#sage --preparse VGIT.sage


def my_import(module_name, func_name='*'):
    import os
    os.system('sage --preparse ' + module_name + '.sage')
    os.system('mv ' + module_name + '.sage.py ' + module_name + '.py')

    from sage.misc.python import Python
    python = Python()
    python.eval('from ' + module_name + ' import ' + func_name, globals())

#my_import("functions")

#my_import("Monomials")

#my_import("OPS")

# my_import("VGIT")

my_import("Printout")
#from functions.sage import *

#from VGIT.sage import *

#User to add their Dimension +degree and number of hypersurfaces in complete intersection

dimension = 2
degree = 2
no_of_hypersurfaces = 3

#params = Problem(dimension, degree, no_of_hypersurfaces)
params = Printout(dimension, degree, no_of_hypersurfaces)

#monomial_hypersurface = [[2, 0, 0, 0], [1, 1, 0, 0], [1, 0, 1, 0], [1, 0, 0, 1], [0, 2, 0, 0], [0, 1, 1, 0], [0, 1, 0, 1], [0, 0, 2, 0], [0, 0, 1, 1], [0, 0, 0, 2]]
#monomial_hyperplane = [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]]

#User to call the following depending on the dimension/degree of their choosing

#monomial_hypersurface = Monomial.monomials(dimension, degree)
#monomial_hyperplane = Monomial.monomials(dimension, 1)

#print(monomial_hypersurface)
#opset generates the fundamental set of one-parameter subgroups

opset = OPS.ops_set(dimension, degree, no_of_hypersurfaces)

#printout prints all families for each wall t for the specific VGIT problem of given dimension, degree and number of hypersurfaces

#Problem.printout(opset, dimension, degree, no_of_hypersurfaces)

params.printout()

#if you want to run only classical GIT case, i.e. t=0 run the following:

# params.printout_wall(opset, 0)

#To find walls and chambers for a particular problem run the below
#walls = params.all_walls(opset)
#chambers = Problem.t_chambers(walls)


#if you want to run only for specific wall t=a run the following:

#params.printout_wall(opset, a)

