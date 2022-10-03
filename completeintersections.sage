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

#μy_import("functions")

#my_import("Monomials")

#my_import("OPS")

#my_import("VGIT")

#my_import("printout")

from functions import *

from Monomials import *

from OPS import *

from VGIT import *

from printout import * 

import pickle


#from functions.sage import *

#from VGIT.sage import *

#User to add their Dimension +degree and number of hypersurfaces in complete intersection

dimension = 3
degree = 2
no_of_hypersurfaces = 2

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
print(opset)


# with open(r"ops_set_p4_old.txt", "rb") as input_file:
# 	opset = pickle.load(input_file)	
# print(opset[0])
# print(opset)	
# print(len(opset))

#if you only want to find the walls/ chambers do the below
#walls = params.all_walls(opset)
#chambers = Problem.t_chambers(walls)
#print(walls)
#print(chambers)

#git_problem = params.max_sets_t()
#print(git_problem)

#vgit_problem = params.max_semi_dest_sets()
#print(vgit_problem)

#printout prints all families for each wall t for the specific VGIT problem of given dimension, degree and number of hypersurfaces

#Problem.printout(opset, dimension, degree, no_of_hypersurfaces)

# params.printout()

#if you want to run only classical GIT case, i.e. t=0 run the following:
#print(opset)
# params.printout_wall(opset, 0)

#To find walls and chambers for a particular problem run the below
#walls = params.all_walls(opset)
#chambers = Problem.t_chambers(walls)


#if you want to run only for specific wall t=a run the following:

# p4_walls_chambers = [0, 37/228, 1/6, 327/1162, 2/7, 113/304, 3/8, 1039/1914, 6/11, 355/534, 2/3, 37/38, 1] 
p3_walls_chambers = [0, 74/171, 4/9, 37/57, 2/3, 31/40, 4/5, 33/34, 1, 74/57, 4/3]

for wall in p3_walls_chambers:
	params.printout_wall(opset, wall)

# params.printout_wall(opset, 0)

# if you want to find unstable elements for a wall t = a run the following:

# params.printout_wall_semi(opset,0)

def GIT(dim, deg, hyp_no):
	r"""
	Prints the maximal destabilizing sets for the GIT of the complete intersection of `r = hyp_no` hypersurfaces of degree deg in P^ dim.

	INPUT:

	- ``dim`` -- int; the dimension of the problem

	- ``deg`` -- int; the degree of the complete intersection polynomials
	
	- ``hyp_no`` -- int; the number of hypersurfaces in the complete intersection

	OUTPUT: None

	EXAMPLES:

		See the documentation of printout_wall()
	
	TEST:

	The GIT picture given a specific dimension = 1; degree = 4; no_of_hypersurfaces = 2 ::

	    sage: dimension = 1; degree = 4; no_of_hypersurfaces = 2
	    sage: params = Printout(dimension, degree, no_of_hypersurfaces)
	    sage: params.printout_wall()
	    Solving problem in dimension  1  degree  4  and  2  hypersurfaces for wall t= 0
	    Family 0
	    Vm:
	    d4*x0^4 + d3*x0^3*x1 + d2*x0^2*x1^2 + d1*x0*x1^3 + d0*x1^4
	    Bms:
	    e0*x1^4
	    Support monomial
	    (0, 4)
	    One-parameter subgroup:
	    (1, -1)
	    ##############################
	    This is a strictly semistable family
	    Potential closed orbit
	    V^0 =  d0*x0^4
	    B^0 =  e0*x1^4
	    #######################################################
	    Family 1
	    Vm:
	    d3*x0^3*x1 + d2*x0^2*x1^2 + d1*x0*x1^3 + d0*x1^4
	    Bms:
	    e1*x0*x1^3 + e0*x1^4
	    Support monomial
	    (1, 3)
	    One-parameter subgroup:
	    (1, -1)
	    ##############################
	    This is a strictly semistable family
	    Potential closed orbit
	    V^0 =  d0*x0^3*x1
	    B^0 =  e0*x0*x1^3
	    #######################################################
	    Family 2
	    Vm:
	    d2*x0^2*x1^2 + d1*x0*x1^3 + d0*x1^4
	    Bms:
	    e2*x0^2*x1^2 + e1*x0*x1^3 + e0*x1^4
	    Support monomial
	    (2, 2)
	    One-parameter subgroup:
	    (1, -1)
	    ##############################
	    Not strictly t-semistable
	    #######################################################
	    Family 3
	    Vm:
	    d1*x0*x1^3 + d0*x1^4
	    Bms:
	    e3*x0^3*x1 + e2*x0^2*x1^2 + e1*x0*x1^3 + e0*x1^4
	    Support monomial
	    (3, 1)
	    One-parameter subgroup:
	    (1, -1)
	    ##############################
	    This is a strictly semistable family
	    Potential closed orbit
	    V^0 =  d0*x0*x1^3
	    B^0 =  e0*x0^3*x1
	    #######################################################
	    Family 4
	    Vm:
	    d0*x1^4
	    Bms:
	    e4*x0^4 + e3*x0^3*x1 + e2*x0^2*x1^2 + e1*x0*x1^3 + e0*x1^4
	    Support monomial
	    (4, 0)
	    One-parameter subgroup:
	    (1, -1)
	    ##############################
	    This is a strictly semistable family
	    Potential closed orbit
	    V^0 =  d0*x1^4
	    B^0 =  e0*x0^4	 

	WARNING::

	Inputting a high number for deg, dim or hyp_no makes the computation time too long.
	                

	"""
	params = Printout(dim, deg, hyp_no)
	params.printout_wall()
	return None



def VGIT(dim, deg, hyp_no):
	r"""
	Prints the maximal destabilizing sets for the VGIT of the complete intersection of `r = hyp_no` hypersurfaces of degree deg in P^ dim and a hyperplane section.

	INPUT:

	- ``dim`` -- int; the dimension of the problem

	- ``deg`` -- int; the degree of the complete intersection polynomials
	
	- ``hyp_no`` -- int; the number of hypersurfaces in the complete intersection

	OUTPUT: a list of OPS, corresponding to all the one-parameter subgroups

	EXAMPLES:

		See the documentation of printout()
	
	WARNING::

	Inputting a high number for deg, dim or hyp_no makes the computation time too long.
	                

	"""
	params = Printout(dim, deg, hyp_no)
	params.printout()
	return None



#GIT(dimension, degree, no_of_hypersurfaces)

