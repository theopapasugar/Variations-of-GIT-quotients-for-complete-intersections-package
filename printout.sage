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
my_import("VGIT")

import pickle


class Printout(Problem):
    r"""
    Wrapper Class of Problem. Takes dimension, degree and number of hypersurfaces and is used to printout the results more elegantly.

    EXAMPLES:

        sage: dimension = 2; degree = 2; no_of_hypersurfaces = 2
        sage: params = Printout(dimension, degree, no_of_hypersurfaces)
        sage: params
        (2,2,2)

    """
    def __init__(self, dim, deg, hyp_no):
        super().__init__(dim, deg, hyp_no)
        

    def printout(self):
        r"""
        Printout the vgit non stable elements for all walls in a txt file.

        INPUT:

        - ``self`` -- Printout; the dimension, degree and number of hypersurfaces for the problem

        OUTPUT: None

        EXAMPLES:

        The full VGIT picture given a specific dimension = 2; degree = 2; no_of_hypersurfaces = 3 ::

            sage: dimension = 2; degree = 2; no_of_hypersurfaces = 3
            sage: params = Printout(dimension, degree, no_of_hypersurfaces)
            sage: params.printout()
            Solving for complete intersection of degree 2 with 3 hypersurfaces and hyperplane section in P^ 2
            Found false walls
            The walls are [0, 1, 3/2, 2, 3]
            The chambers are [1/2, 5/4, 7/4, 5/2]
            Solving for wall 0
            Case 1
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (0, 1, 1)
            1-ps:  (2, -1, -1)
            This is a strictly t-semistable family
            Potential closed orbit
            V^0 =  d0*x0^2
            The B^0 are: 
            e1*x1*x2 + e0*x2^2
            e4*x1^2 + e1*x1*x2 + e3*x1*x2 + e0*x2^2 + e2*x2^2
            #######################################################
            Case 2
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (1, 0, 1)
            1-ps:  (2, -1, -1)
            This is a strictly t-semistable family
            Potential closed orbit
            V^0 =  d0*x0*x1 + d1*x0*x2
            The B^0 are: 
            e0*x0*x2
            e0*x1^2
            #######################################################
            Case 3
            V^- =  d2*x1^2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (1, 1, 0)
            1-ps:  (2, -1, -1)
            This is a strictly t-semistable family
            Potential closed orbit
            V^0 =  d2*x1^2 + d0*x1*x2 + d1*x2^2
            The B^0 are: 
            e0*x0*x2
            e2*x0*x1 + e0*x0*x2 + e1*x0*x2
            #######################################################
            Case 4
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Support monomials for the hypersurfaces: 
            0
            (0, 2, 0)
            1
            (1, 1, 0)
            1-ps:  (2, -1, -1)
            This is a strictly t-semistable family
            Potential closed orbit
            V^0 =  d0*x0*x1 + d1*x0*x2
            The B^0 are: 
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            e1*x0*x1 + e0*x0*x2
            #######################################################
            Case 5
            V^- =  d2*x1^2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Support monomials for the hypersurfaces: 
            0
            (0, 2, 0)
            1
            (2, 0, 0)
            1-ps:  (2, -1, -1)
            This is a strictly t-semistable family
            Potential closed orbit
            V^0 =  d2*x1^2 + d0*x1*x2 + d1*x2^2
            The B^0 are: 
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            e0*x0^2
            #######################################################
            Case 6
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (1, 0, 1)
            1-ps:  (1, 0, -1)
            This is a strictly t-semistable family
            Potential closed orbit
            V^0 =  d0*x0^2
            The B^0 are: 
            e0*x2^2
            e1*x1^2 + e0*x0*x2
            #######################################################
            Case 7
            V^- =  d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Support monomials for the hypersurfaces: 
            0
            (2, 0, 0)
            1
            (2, 0, 0)
            1-ps:  (1, 0, -1)
            This is a strictly t-semistable family
            Potential closed orbit
            V^0 =  d0*x1^2 + d1*x0*x2
            The B^0 are: 
            e0*x2^2
            e0*x0^2
            #######################################################
            Case 8
            V^- =  d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (2, 0, 0)
            1-ps:  (1, 0, -1)
            This is a strictly t-semistable family
            Potential closed orbit
            V^0 =  d0*x2^2
            The B^0 are: 
            e1*x1^2 + e0*x0*x2
            e0*x0^2
            #######################################################
            Solving for wall 1
            Case 1
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (0, 2, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 2
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (0, 2, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 3
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (0, 2, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 4
            V^- =  d2*x1^2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (0, 2, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 5
            V^- =  d2*x1^2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 6
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 2, 0)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 7
            V^- =  d2*x1^2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 2, 0)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 8
            V^- =  d2*x1^2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 2, 0)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 9
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (0, 1, 1)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 10
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (1, 0, 1)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 11
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (1, 0, 1)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 12
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 1, 0)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 13
            V^- =  d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 14
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (2, 0, 0)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 15
            V^- =  d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 16
            V^- =  d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 17
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (1, 0, 1)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 18
            V^- =  d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (1, 0, 1)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 19
            V^- =  d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 20
            V^- =  d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 21
            V^- =  d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 22
            V^- =  d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 23
            V^- =  d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 24
            V^- =  d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 25
            V^- =  d0*x2^2
            The B^- are:
            0
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 1, 0)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Solving for wall 3/2
            Case 1
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (0, 2, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 2
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (0, 2, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 3
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (0, 2, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 4
            V^- =  d2*x1^2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (0, 2, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 5
            V^- =  d2*x1^2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 6
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 2, 0)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 7
            V^- =  d2*x1^2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 2, 0)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 8
            V^- =  d2*x1^2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 2, 0)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 9
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (1, 0, 1)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 10
            V^- =  d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (1, 0, 1)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 11
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 1, 0)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 12
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (2, 0, 0)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 13
            V^- =  d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 14
            V^- =  d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 15
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (1, 0, 1)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 16
            V^- =  d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 17
            V^- =  d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 18
            V^- =  d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 19
            V^- =  d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 20
            V^- =  d0*x2^2
            The B^- are:
            0
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 1, 0)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Solving for wall 2
            Case 1
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (0, 2, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 2
            V^- =  d2*x1^2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (0, 2, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 3
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (0, 2, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 4
            V^- =  d2*x1^2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 5
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 2, 0)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 6
            V^- =  d2*x1^2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 2, 0)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 7
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (0, 1, 1)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 8
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (1, 0, 1)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 9
            V^- =  d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (1, 0, 1)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 10
            V^- =  d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 11
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (2, 0, 0)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 12
            V^- =  d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 13
            V^- =  d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 14
            V^- =  d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (1, 0, 1)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 15
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 16
            V^- =  d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 17
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 18
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (1, 0, 1)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 19
            V^- =  d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (0, 2, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 20
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 21
            V^- =  d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 22
            V^- =  d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 23
            V^- =  d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 1, 0)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Solving for wall 3
            Case 1
            V^- =  d2*x1^2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (0, 2, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 2
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (0, 2, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            This is a strictly t-semistable family
            Potential closed orbit
            V^0 =  d0*x0^2
            The B^0 are: 
            e0*x0*x2
            e0*x1^2
            B^0_h =  g1*x1 + g0*x2
            #######################################################
            Case 3
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 4
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 2, 0)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 5
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 2, 0)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 6
            V^- =  d2*x1^2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 1, 0)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 7
            V^- =  d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (0, 1, 1)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 8
            V^- =  d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (1, 0, 1)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 9
            V^- =  d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 10
            V^- =  d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (1, 0, 1)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 11
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 12
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            This is a strictly t-semistable family
            Potential closed orbit
            V^0 =  d0*x0^2
            The B^0 are: 
            e1*x1^2 + e0*x0*x2
            e0*x0*x1
            B^0_h =  g0*x2
            #######################################################
            Case 13
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            This is a strictly t-semistable family
            Potential closed orbit
            V^0 =  d0*x0*x1
            The B^0 are: 
            e1*x1^2 + e0*x0*x2
            e0*x0^2
            B^0_h =  g0*x2
            #######################################################
            Case 14
            V^- =  d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 1, 0)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            This is a strictly t-semistable family
            Potential closed orbit
            V^0 =  d0*x1^2 + d1*x0*x2
            The B^0 are: 
            e0*x0*x1
            e0*x0^2
            B^0_h =  g0*x2
            #######################################################
            Solving for chamber 1/2
            Case 1
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (0, 2, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 2
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (0, 2, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 3
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (0, 2, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 4
            V^- =  d2*x1^2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (0, 2, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 5
            V^- =  d2*x1^2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 6
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 2, 0)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 7
            V^- =  d2*x1^2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 2, 0)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 8
            V^- =  d2*x1^2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 2, 0)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 9
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (0, 1, 1)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 10
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (1, 0, 1)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 11
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (1, 0, 1)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 12
            V^- =  d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 13
            V^- =  d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 14
            V^- =  d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 15
            V^- =  d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (1, 0, 1)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 16
            V^- =  d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 17
            V^- =  d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 18
            V^- =  d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Solving for chamber 5/4
            Case 1
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (0, 2, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 2
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (0, 2, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 3
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (0, 2, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 4
            V^- =  d2*x1^2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (0, 2, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 5
            V^- =  d2*x1^2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 6
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 2, 0)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 7
            V^- =  d2*x1^2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 2, 0)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 8
            V^- =  d2*x1^2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 2, 0)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 9
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (1, 0, 1)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 10
            V^- =  d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (1, 0, 1)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 11
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 1, 0)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 12
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (2, 0, 0)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 13
            V^- =  d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 14
            V^- =  d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 15
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (1, 0, 1)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 16
            V^- =  d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 17
            V^- =  d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 18
            V^- =  d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 19
            V^- =  d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 20
            V^- =  d0*x2^2
            The B^- are:
            0
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 1, 0)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Solving for chamber 7/4
            Case 1
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (0, 2, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 2
            V^- =  d2*x1^2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (0, 2, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 3
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (0, 2, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 4
            V^- =  d2*x1^2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 5
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 2, 0)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 6
            V^- =  d2*x1^2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 2, 0)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 7
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (0, 1, 1)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 8
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (1, 0, 1)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 9
            V^- =  d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (1, 0, 1)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 10
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 1, 0)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 11
            V^- =  d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 12
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (2, 0, 0)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 13
            V^- =  d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 14
            V^- =  d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 15
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (1, 0, 1)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 16
            V^- =  d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (1, 0, 1)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 17
            V^- =  d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 18
            V^- =  d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 19
            V^- =  d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (0, 2, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 20
            V^- =  d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 21
            V^- =  d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 22
            V^- =  d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 23
            V^- =  d0*x2^2
            The B^- are:
            0
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 1, 0)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Solving for chamber 5/2
            Case 1
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (0, 2, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 2
            V^- =  d2*x1^2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (0, 2, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 3
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (0, 2, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 4
            V^- =  d2*x1^2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 5
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 2, 0)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 6
            V^- =  d2*x1^2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 2, 0)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (2, -1, -1)
            Not strictly t-semistable
            #######################################################
            Case 7
            V^- =  d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (0, 1, 1)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 8
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (1, 0, 1)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 9
            V^- =  d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (1, 0, 1)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 10
            V^- =  d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 11
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (2, 0, 0)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 12
            V^- =  d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 0, 2)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 13
            V^- =  d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g2*x0 + g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (1, 0, 1)
            Support monomial hyperplane:  (1, 0, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 14
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 15
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (0, 1, 1)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 16
            V^- =  d5*x0^2 + d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e2*x1^2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (1, 0, 1)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 17
            V^- =  d4*x0*x1 + d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 18
            V^- =  d3*x1^2 + d2*x0*x2 + d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 19
            V^- =  d0*x2^2
            The B^- are:
            0
            e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g1*x1 + g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 0, 1)
            1
            (2, 0, 0)
            Support monomial hyperplane:  (0, 1, 0)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
            Case 20
            V^- =  d1*x1*x2 + d0*x2^2
            The B^- are:
            0
            e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            1
            e5*x0^2 + e4*x0*x1 + e3*x1^2 + e2*x0*x2 + e1*x1*x2 + e0*x2^2
            Hyperplane B^- =  g0*x2
            Support monomials for the hypersurfaces: 
            0
            (1, 1, 0)
            1
            (1, 1, 0)
            Support monomial hyperplane:  (0, 0, 1)
            1-ps:  (1, 0, -1)
            Not strictly t-semistable
            #######################################################
        
        TEST:

        The full VGIT picture given a specific dimension = 1; degree = 4; no_of_hypersurfaces = 2 ::

            sage: dimension = 1; degree = 4; no_of_hypersurfaces = 2
            sage: params = Problem(dimension, degree, no_of_hypersurfaces)
            sage: vgit_problem = params.max_semi_dest_sets()
            sage: vgit_problem
            [[[[(0, 4), (1, 3), (2, 2), (3, 1), (4, 0)], [(0, 4), (1, 3), (2, 2), (3, 1)], [(0, 4), (1, 3), (2, 2)], [(0, 4), (1, 3)], [(0, 4)]], [[(0, 4), (1, 3), (2, 2), (3, 1), (4, 0)], [(0, 4), (1, 3), (2, 2), (3, 1)], [(0, 4), (1, 3), (2, 2)], [(0, 4), (1, 3)]], [[(0, 4), (1, 3), (2, 2), (3, 1), (4, 0)], [(0, 4), (1, 3), (2, 2), (3, 1)], [(0, 4), (1, 3), (2, 2)]], [[(0, 4), (1, 3), (2, 2), (3, 1), (4, 0)], [(0, 4), (1, 3), (2, 2), (3, 1)]], [[(0, 4), (1, 3), (2, 2), (3, 1), (4, 0)]]], [[[(0, 4), (1, 3), (2, 2), (3, 1), (4, 0)], [(0, 4), (1, 3), (2, 2), (3, 1)], [(0, 4), (1, 3), (2, 2)], [(0, 4), (1, 3)], [(0, 4)]], [[(0, 4), (1, 3), (2, 2), (3, 1), (4, 0)], [(0, 4), (1, 3), (2, 2), (3, 1)], [(0, 4), (1, 3), (2, 2)], [(0, 4), (1, 3)]], [[(0, 4), (1, 3), (2, 2), (3, 1), (4, 0)], [(0, 4), (1, 3), (2, 2), (3, 1)], [(0, 4), (1, 3), (2, 2)]], [[(0, 4), (1, 3), (2, 2), (3, 1), (4, 0)], [(0, 4), (1, 3), (2, 2), (3, 1)]]], [[[(0, 4)], [(0, 4), (1, 3)], [(0, 4), (1, 3), (2, 2)], [(0, 4), (1, 3), (2, 2), (3, 1)], [(0, 4), (1, 3), (2, 2), (3, 1), (4, 0)]], [[(0, 4), (1, 3)], [(0, 4), (1, 3), (2, 2)], [(0, 4), (1, 3), (2, 2), (3, 1)], [(0, 4), (1, 3), (2, 2), (3, 1), (4, 0)]], [[(0, 4), (1, 3), (2, 2)], [(0, 4), (1, 3), (2, 2), (3, 1)], [(0, 4), (1, 3), (2, 2), (3, 1), (4, 0)]], [[(0, 4), (1, 3), (2, 2), (3, 1)], [(0, 4), (1, 3), (2, 2), (3, 1), (4, 0)]], [[(0, 4), (1, 3), (2, 2), (3, 1), (4, 0)]]], [[[(0, 4)], [(0, 4), (1, 3)], [(0, 4), (1, 3), (2, 2)], [(0, 4), (1, 3), (2, 2), (3, 1)], [(0, 4), (1, 3), (2, 2), (3, 1), (4, 0)]], [[(0, 4), (1, 3)], [(0, 4), (1, 3), (2, 2)], [(0, 4), (1, 3), (2, 2), (3, 1)], [(0, 4), (1, 3), (2, 2), (3, 1), (4, 0)]], [[(0, 4), (1, 3), (2, 2)], [(0, 4), (1, 3), (2, 2), (3, 1)], [(0, 4), (1, 3), (2, 2), (3, 1), (4, 0)]], [[(0, 4), (1, 3), (2, 2), (3, 1)], [(0, 4), (1, 3), (2, 2), (3, 1), (4, 0)]]], [[[], [], [], [], []], [[(0, 1)], [(0, 1)], [(0, 1)], [(0, 1)]], [[(0, 1)], [(0, 1)], [(0, 1)]], [[(0, 1)], [(0, 1)]], [[(0, 1)]]], [[[(0, 1)], [(0, 1)], [(0, 1)], [(0, 1)], [(0, 1)]], [[(0, 1)], [(0, 1)], [(0, 1)], [(0, 1)]], [[(0, 1)], [(0, 1)], [(0, 1)]], [[(0, 1)], [(0, 1)]]], [[(0, 4), (1, 3), (2, 2), (3, 1), (4, 0)], [(1, 3), (2, 2), (3, 1), (4, 0)], [(2, 2), (3, 1), (4, 0)], [(3, 1), (4, 0)], [(4, 0)]], [[(0, 4), (1, 3), (2, 2), (3, 1), (4, 0)], [(1, 3), (2, 2), (3, 1), (4, 0)], [(2, 2), (3, 1), (4, 0)], [(3, 1), (4, 0)]], [[(0, 1), (0, 1), (0, 1), (0, 1), (0, 1)], [(0, 1), (0, 1), (0, 1), (0, 1)], [(0, 1), (0, 1), (0, 1)], [(0, 1), (0, 1)], [(0, 1)]], [[(0, 1), (0, 1), (0, 1), (0, 1), (0, 1)], [(0, 1), (0, 1), (0, 1), (0, 1)], [(0, 1), (0, 1), (0, 1)], [(0, 1), (0, 1)]], [[(1, -1), (1, -1), (1, -1), (1, -1), (1, -1)], [(1, -1), (1, -1), (1, -1), (1, -1)], [(1, -1), (1, -1), (1, -1)], [(1, -1), (1, -1)], [(1, -1)]], [[(1, -1), (1, -1), (1, -1), (1, -1), (1, -1)], [(1, -1), (1, -1), (1, -1), (1, -1)], [(1, -1), (1, -1), (1, -1)], [(1, -1), (1, -1)]], [0, 2, 4, 6, 8], [1, 3, 5, 7]]


        ALGORITHM:

        We construct all the walls and chambers and for each of those we find the maximal destabilizing families using max_sets_t(). We call these maximal_dest_vm_walls, maximal_dest_bm_walls and 
        maximal_dest_bhm_walls for each wall and maximal_dest_vm_chambers, maximal_dest_bm_chambers and maximal_dest_bhm_chambers. These are lists where each ith element corresponds to the ith wall.
        We then check if maximal_dest_vm_chambers[i] `\susbeteq` maximal_dest_vm_walls[i+1], maximal_dest_bm_chambers[i] `\susbeteq` maximal_dest_bm_walls[i+1], and 
        if maximal_dest_bhm_chambers[i] `\susbeteq` maximal_dest_bhm_walls[i+1]. If the condition is satisfied, we remove wall i+1 from the list as it is a false wall and chamber i. We keep all the 
        values of true walls/ chambers and append them into a list.

        """
        #I want to check something so I will upload specific opset file
        if 1 == 1:
            with open(r"ops_set_tester.txt", "rb") as input_file:
                onepslist = pickle.load(input_file)  
        else:
            onepslist = OPS.ops_set(self.dim, self.deg, self.hyp_no)
        r = self.hyp_no - 1
        d = self.dim + 1
        f = open("VGIT_output_intersections.txt", "a")
        print('Solving for complete intersection of degree',self.deg, 'with ', self.hyp_no, 'hypersurfaces and hyperplane section in P^', self.dim, file=f)
        fams = self.max_semi_dest_sets(onepslist)  #generates families
        maximal_dest_vm_walls = fams[0]
        maximal_dest_vm_chambers = fams[1]
        maximal_dest_bm_walls = fams[2]
        maximal_dest_bm_chambers = fams[3]
        maximal_dest_bhm_walls = fams[4]
        maximal_dest_bhm_chambers = fams[5]
        support_monomials_walls = fams[6]
        support_monomials_chambers = fams[7]
        support_monomialsh_walls = fams[8]
        support_monomialsh_chambers = fams[9]
        gamma_walls = fams[10]
        gamma_chambers = fams[11]
        used_walls = fams[12]
        used_chambers = fams[13]
        print('Found false walls', file=f)
        # with open("maximal_dest_vm_walls.txt", "rb") as fp:   #Unpickling
        #     maximal_dest_vm_walls = pickle.load(fp)
        # with open("maximal_dest_vm_chambers.txt", "rb") as fp:   #Unpickling
        #     maximal_dest_vm_chambers = pickle.load(fp)
        # with open("maximal_dest_bm_walls.txt", "rb") as fp:   #Unpickling
        #     maximal_dest_bm_walls = pickle.load(fp)
        # with open("maximal_dest_bm_chambers.txt", "rb") as fp:   #Unpickling
        #     maximal_dest_bm_chambers = pickle.load(fp)
        # with open("maximal_dest_bhm_walls.txt", "rb") as fp:   #Unpickling
        #     maximal_dest_bhm_walls = pickle.load(fp)
        # with open("maximal_dest_bhm_chambers.txt", "rb") as fp:   #Unpickling
        #     maximal_dest_bhm_chambers = pickle.load(fp)
        # with open("support_monomials_walls.txt", "rb") as fp:   #Unpickling
        #     support_monomials_walls = pickle.load(fp)
        # with open("support_monomials_chambers.txt", "rb") as fp:   #Unpickling
        #     support_monomials_chambers = pickle.load(fp)
        # with open("support_monomialsh_walls.txt", "rb") as fp:   #Unpickling
        #     support_monomialsh_walls = pickle.load(fp)
        # with open("support_monomialsh_chambers.txt", "rb") as fp:   #Unpickling
        #     support_monomialsh_chambers = pickle.load(fp)
        # with open("gamma_walls.txt", "rb") as fp:   #Unpickling
        #     gamma_walls = pickle.load(fp)
        # with open("gamma_chambers.txt", "rb") as fp:   #Unpickling
        #     gamma_chambers = pickle.load(fp)
        # with open("used_walls.txt", "rb") as fp:   #Unpickling
        #     used_walls = pickle.load(fp)
        # with open("used_chambers.txt", "rb") as fp:   #Unpickling
        #     used_chambers = pickle.load(fp)
        print('The walls are', used_walls, file=f)
        print('The chambers are', used_chambers, file=f)
        tl = var('x', n=d)
        for i in range(len(maximal_dest_vm_walls)): # possibly make lines 393-461 into a single function 
            print('Solving for wall', used_walls[i], file=f)
            for j in range(len(maximal_dest_vm_walls[i])):
                max_dest_bm_walls_needed = [] 
                if r > 1:
                    max_dest_bm_walls_needed = [0 for el in range(r)]
                    for k in range(r):
                        max_dest_bm_walls_needed[k] = maximal_dest_bm_walls[k][i][j]
                else:
                    max_dest_bm_walls_needed = maximal_dest_bm_walls[i][j] #maybe include special condition for wall = 0
                equations = []
                if used_walls[i] == 0:
                    equations = printer(maximal_dest_vm_walls[i][j], max_dest_bm_walls_needed, [], used_walls[i], self.dim, self.hyp_no)
                if used_walls[i] > 0:
                    equations = printer(maximal_dest_vm_walls[i][j], max_dest_bm_walls_needed, maximal_dest_bhm_walls[i][j], used_walls[i], self.dim, self.hyp_no)
                eq_sum_v = equations[0]
                eq_sum_b = equations[1]
                eq_sum_bh = equations[2]
                print('Case', j+1, file=f)
                print('V^- = ', eq_sum_v, file=f)
                if r > 1:
                    print('The B^- are:', file=f)
                    for m in range(r):
                        print(m, file=f)
                        print(eq_sum_b[m], file=f)
                elif r == 1:
                    print('B^- = ', eq_sum_b, file=f)
                if used_walls[i] > 0:
                    print('Hyperplane B^- = ', eq_sum_bh, file=f)
                if r > 1:
                    print('Support monomials for the hypersurfaces: ', file=f)
                    for m in range(r):
                        print(m, file=f)
                        print(support_monomials_walls[m][i][j], file=f)
                elif r == 1:
                    print('Support monomial hypersurface: ', support_monomials_walls[i][j], file=f)
                if used_walls[i] > 0:
                    print('Support monomial hyperplane: ', support_monomialsh_walls[i][j], file=f)
                print('1-ps: ', gamma_walls[i][j], file=f)
                #fix identation here!
                if centroid_criterion(maximal_dest_vm_walls[i][j], max_dest_bm_walls_needed, maximal_dest_bhm_walls[i][j], used_walls[i], gamma_walls[i][j], self.dim, self.deg, self.hyp_no):  #checks if strictly semistable
                    print('This is a strictly t-semistable family', file=f)
                    an = []
                    if used_walls[i] == 0:
                        an = annihilator(maximal_dest_vm_walls[i][j], [], max_dest_bm_walls_needed, gamma_walls[i][j], used_walls[i], self.dim, self.hyp_no)
                    if used_walls[i] > 0:
                        an = annihilator(maximal_dest_vm_walls[i][j], maximal_dest_bhm_walls[i][j], max_dest_bm_walls_needed, gamma_walls[i][j], used_walls[i], self.dim, self.hyp_no)
                    vm0 = an[0]
                    bm0 = an[1]
                    bhm0 = an[2]
                    pr = printer(vm0, bm0, bhm0, used_walls[i], self.dim, self.hyp_no)
                    eq_sum_v0 = pr[0]
                    eq_sum_b0 = pr[1]
                    eq_sum_bh0 = pr[2] 
                    print('Potential closed orbit', file=f)
                    print('V^0 = ', eq_sum_v0, file=f)
                    if r > 0:
                        print('The B^0 are: ', file=f)
                        for m in range(r):
                            print(eq_sum_b0[m], file=f)
                    elif r == 1:
                        print('The B^0 is: ', file=f)
                        print(eq_sum_b0, file=f)
                    if used_walls[i] > 0:
                        print('B^0_h = ', eq_sum_bh0, file=f)
                    print('#######################################################', file=f)
                else:
                    print('Not strictly t-semistable', file=f)
                    print('#######################################################', file=f)
        for i in range(len(maximal_dest_vm_chambers)):
            print('Solving for chamber', used_chambers[i], file=f)
            for j in range(len(maximal_dest_vm_chambers[i])):
                if r > 1:
                    max_dest_bm_chambers_needed = [0 for el in range(r)]
                    for k in range(r):
                        max_dest_bm_chambers_needed[k] = maximal_dest_bm_chambers[k][i][j]
                else:
                    max_dest_bm_chambers_needed = maximal_dest_bm_chambers[i][j]
                equations = printer(maximal_dest_vm_chambers[i][j], max_dest_bm_chambers_needed, maximal_dest_bhm_chambers[i][j], used_chambers[i], self.dim, self.hyp_no)
                eq_sum_v = equations[0]
                eq_sum_b = equations[1]
                eq_sum_bh = equations[2]
                print('Case', j+1, file=f)
                print('V^- = ', eq_sum_v, file=f)
                if r > 1:
                    print('The B^- are:', file=f)
                    for m in range(r):
                        print(m, file=f)
                        print(eq_sum_b[m], file=f)
                else:
                    print('B^- = ', eq_sum_b, file=f)
                print('Hyperplane B^- = ', eq_sum_bh, file=f)
                if r > 1:
                    print('Support monomials for the hypersurfaces: ', file=f)
                    for m in range(r):
                        print(m, file=f)
                        print(support_monomials_chambers[m][i][j], file=f)
                elif r == 1:
                    print('Support monomial hypersurface: ', support_monomials_chambers[i][j], file=f)
                print('Support monomial hyperplane: ', support_monomialsh_chambers[i][j], file=f)
                print('1-ps: ', gamma_chambers[i][j], file=f)
                if centroid_criterion(maximal_dest_vm_chambers[i][j], max_dest_bm_chambers_needed, maximal_dest_bhm_chambers[i][j], used_chambers[i], gamma_chambers[i][j], self.dim, self.deg, self.hyp_no):
                    print('This is a strictly t-semistable family', file=f)
                    an = annihilator(maximal_dest_vm_chambers[i][j], maximal_dest_bhm_chambers[i][j], max_dest_bm_chambers_needed, gamma_chambers[i][j], used_chambers[i], self.dim, self.hyp_no)
                    vm0 = an[0]
                    bm0 = an[1]
                    bhm0 = an[2]
                    pr = printer(vm0, bm0, bhm0, used_chambers[i], self.dim, self.hyp_no)
                    eq_sum_v0 = pr[0]
                    eq_sum_b0 = pr[1]
                    eq_sum_bh0 = pr[2]
                    print('Potential closed orbit', file=f)
                    print('V^0 = ', eq_sum_v0, file=f)
                    if r > 1:
                        print('The B^0 are: ', file=f)
                        for m in range(r):
                            print(m, file=f)
                            print(eq_sum_b0[m], file=f)
                    elif r == 1:
                        print('B^0: ', file=f)
                        print(eq_sum_b0, file=f)
                    print('B^0_h = ', eq_sum_bh0, file=f)
                    print('#######################################################', file=f)
                else:
                    print('Not strictly t-semistable', file=f)
                    print('#######################################################', file=f)
        f.close()


    def printout_wall(self, onepslist, wall=0): 
        r"""
        Printout the vgit non stable elements for specific wall in a txt file.

        INPUT:

        - ``self`` -- Printout; the dimension, degree and number of hypersurfaces for the problem
        - ``onepslist`` -- list of OPS; a list of OPS of fractions or ints, Default None
        - ``wall`` -- float; a specific wall, Default 0

        OUTPUT: None

        EXAMPLES:

        The VGIT picture given a specific dimension = 2; degree = 2; no_of_hypersurfaces = 2 and wall = 0::

            sage: dimension = 2; degree = 2; no_of_hypersurfaces = 2
            sage: params = Printout(dimension, degree, no_of_hypersurfaces)
            sage: params.printout_wall()
            Fammily 0
            Vm:
            [[0, 0, 2], [0, 1, 1], [1, 0, 1], [0, 2, 0], [1, 1, 0]]
            Bm:
            [[0, 0, 2], [0, 1, 1], [0, 2, 0]]
            Support monomial
            [0, 2, 0]
            One-parameter subgroup:
            [2, -1, -1]
            ##############################
            Fammily 1
            Vm:
            [[0, 0, 2], [0, 1, 1], [0, 2, 0]]
            Bm:
            [[0, 0, 2], [0, 1, 1], [1, 0, 1], [0, 2, 0], [1, 1, 0]]
            Support monomial
            [1, 1, 0]
            One-parameter subgroup:
            [2, -1, -1]
            ##############################
            Fammily 2
            Vm:
            [[0, 0, 2], [0, 1, 1], [1, 0, 1], [0, 2, 0], [1, 1, 0], [2, 0, 0]]
            Bm:
            [[0, 0, 2]]
            Support monomial
            [0, 0, 2]
            One-parameter subgroup:
            [1, 1, -2]
            ##############################
            Fammily 3
            Vm:
            [[0, 0, 2], [0, 1, 1], [1, 0, 1]]
            Bm:
            [[0, 0, 2], [0, 1, 1], [1, 0, 1]]
            Support monomial
            [1, 0, 1]
            One-parameter subgroup:
            [1, 1, -2]
            ##############################
            Fammily 4
            Vm:
            [[0, 0, 2]]
            Bm:
            [[0, 0, 2], [0, 1, 1], [1, 0, 1], [0, 2, 0], [1, 1, 0], [2, 0, 0]]
            Support monomial
            [2, 0, 0]
            One-parameter subgroup:
            [1, 1, -2]
            ##############################
        

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
        """
        r = self.hyp_no - 1
        d = self.dim + 1
        tl = var('x', n=d)
        f = open("wall_output_intersections.txt", "a")
        print('Solving problem in P^', self.dim, ' degree ', self.deg, ' and ', self.hyp_no, ' hypersurfaces for wall t=', wall, file=f) 
        opset = onepslist
        if onepslist == None:
            opset = OPS.ops_set(self.dim, self.deg, self.hyp_no)
        families = self.max_sets_t(opset, wall)
        vms = families[0]
        if r > 1:
            bms = [0 for i in range(r)]
            for i in range(r):
                bms[i] = families[1][i]
        else:
            bms = families[1]
        bhms = []
        if wall != 0:
            bhms = families[2]
        if r > 1:
            supp_mons = [0 for i in range(r)]
            for i in range(r):
                supp_mons[i] = families[3][i]
        else:
            supp_mons = families[3]
        supp_mons_h = families[4]    
        gammas = families[5]
        for i in range(len(vms)):
            bms_needed = []
            if r > 1:
                bms_needed = [0 for i in range(r)]
                for m in range(r):
                    bms_needed[m] = bms[m][i]
            else:
                bms_needed = bms[i]
            equations = []
            if wall == 0:
                equations = printer(vms[i], bms_needed, [], wall, self.dim, self.hyp_no)
            if wall > 0:
                equations = printer(vms[i], bms_needed, bhms[i], wall, self.dim, self.hyp_no)
            eq_sum_v = equations[0]
            eq_sum_b = equations[1]
            eq_sum_bh = equations[2]
            print('Family', i, file=f)
            print('Vm:', file=f)
            print(eq_sum_v, file=f)
            if r > 1:
                print('The Bms are:', file=f)
                for k in range(r):
                    print(k, file=f)
                    print(eq_sum_b[k], file=f)
            elif r == 1:
                print('Bms:', file=f)
                print(eq_sum_b, file=f)
            if wall != 0:
                print('Bhm:', file=f)
                print(eq_sum_bh, file=f)
                print('Support monomial hyperplane', file=f)
                print(supp_mons[i], file=f)    
            if r > 1:
                for m in range(r):
                    print('Support monomial', m, file=f)
                    print(supp_mons[m][i], file=f)
            elif r == 1:
                print('Support monomial', file=f)
                print(supp_mons[i], file=f)
            print('One-parameter subgroup:', file=f)
            print(gammas[i], file=f)
            print('##############################', file=f)
                #add if centroid crit + generate annihilator
            if centroid_criterion(vms[i], bms_needed, bhms, wall, gammas[i], self.dim, self.deg, self.hyp_no):
                print('This is a strictly semistable family', file=f)
                an = []
                if wall == 0:
                    an = annihilator(vms[i], [], bms_needed, gammas[i], wall, self.dim, self.hyp_no)
                if wall > 0:
                    an = annihilator(vms[i], bhms[i], bms_needed, gammas[i], wall, self.dim, self.hyp_no)
                vm0 = an[0]
                bm0 = an[1]
                bhm0 = an[2]
                pr = printer(vm0, bm0, bhm0, wall, self.dim, self.hyp_no)
                eq_sum_v0 = pr[0]
                eq_sum_b0 = pr[1]
                eq_sum_bh0 = pr[2] 
                print('Potential closed orbit', file=f)
                print('V^0 = ', eq_sum_v0, file=f)
                if r > 1:
                    print('The B^0 are: ', file=f)
                    for m in range(r):
                        print(m, file=f)
                        print(eq_sum_b0[m], file=f) 
                elif r == 1:
                    print('B^0 = ', eq_sum_b0, file=f)
                if wall != 0:
                    print('B^0_h = ', eq_sum_bh0, file=f)
                print('#######################################################', file=f)
            else:
                print('Not strictly t-semistable', file=f)
                print('#######################################################', file=f)