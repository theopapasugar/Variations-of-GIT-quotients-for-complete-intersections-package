#!/usr/bin/python36

from functions import *

from OPS_set import *

from Walls import *

from Families import *

from printout import *

#User to add their Dimension +degree and number of hypersurfaces in complete intersection

dimension = 3
degree = 2
no_of_hypersurfaces = 3

#TODO add distinction if user wants to run simple GIT problem
#TODO add possibly case for no_of_hypersurfaces = 1

#monomial_hypersurface = [[2, 0, 0, 0], [1, 1, 0, 0], [1, 0, 1, 0], [1, 0, 0, 1], [0, 2, 0, 0], [0, 1, 1, 0], [0, 1, 0, 1], [0, 0, 2, 0], [0, 0, 1, 1], [0, 0, 0, 2]]
#monomial_hyperplane = [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]]

#User to call the following depending on the dimension/degree of their choosing
#monomial_hypersurface = monomials(dimension, degree)
#monomial_hyperplane = monomials(dimension, 1)

opset = ops_set(monomial_hypersurface,dimension, no_of_hypersurfaces)
printout(opset, dimension, degree, no_of_hypersurfaces)

