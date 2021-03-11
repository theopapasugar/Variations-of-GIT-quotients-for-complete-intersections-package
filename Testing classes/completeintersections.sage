#!/usr/bin/python36

from functions import *

from VGIT import *

#User to add their Dimension +degree and number of hypersurfaces in complete intersection

dimension = 1
degree = 4
no_of_hypersurfaces = 2

#TODO add distinction if user wants to run simple GIT problem
#TODO add possibly case for no_of_hypersurfaces = 1

#monomial_hypersurface = [[2, 0, 0, 0], [1, 1, 0, 0], [1, 0, 1, 0], [1, 0, 0, 1], [0, 2, 0, 0], [0, 1, 1, 0], [0, 1, 0, 1], [0, 0, 2, 0], [0, 0, 1, 1], [0, 0, 0, 2]]
#monomial_hyperplane = [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]]

#User to call the following depending on the dimension/degree of their choosing

monomial_hypersurface = monomials(dimension, degree)
monomial_hyperplane = monomials(dimension, 1)

#opset generates the fundamental set of one-parameter subgroups

opset = Problem.ops_set(monomial_hypersurface,dimension, no_of_hypersurfaces)

#printout prints all families for each wall t for the specific VGIT problem of given dimension, degree and number of hypersurfaces

Problem.printout(opset, dimension, degree, no_of_hypersurfaces)

#if you want to run only classical GIT case, i.e. t=0 run the following:

#wall_1 = Problem.max_sets_t(opset, 0, monomial_hypersurface, monomial_hyperplane, no_of_hypersurfaces)

#this generates the sets. If no_of_hypersurfaces == 2 and you want to print the families do this:
#f = open("GIT_output_intersections.txt", "a")
#vms = wall_1[0]
#bms = wall_1[1]
#supp_mons = wall_1[3]
#gammas = wall_1[5]
#for i in range(len(vms)):
#	print('Fammily', i, file=f)
#	print('Vm:', file=f)
#	print(vms[i], file=f)
#	print('Bm:', file=f)
#	print(bms[i], file=f)
#	print('Support monomial', file=f)
#	print(supp_mons[i], file=f)
#	print('One-parameter subgroup:', file=f)
#	print(gammas[i], file=f)
#	print('##############################', file=f)


