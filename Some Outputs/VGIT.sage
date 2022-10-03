#from functions import *
def my_import(module_name, func_name='*'):
    import os
    os.system('sage --preparse ' + module_name + '.sage')
    os.system('mv ' + module_name + '.sage.py ' + module_name + '.py')

    from sage.misc.python import Python
    python = Python()
    python.eval('from ' + module_name + ' import ' + func_name, globals())

my_import("functions")
my_import("Monomials")
my_import("OPS")

#todo add docstrings
#todo maybe break problem in two classes, one parent class Problem, one subclass Printout


class Problem:
    r"""
    Class that details the VGIT problem. Takes dimension, degree and number of hypersurfaces.

    EXAMPLES:

        sage: dimension = 2; degree = 2; no_of_hypersurfaces = 2
        sage: params = Problem(dimension, degree, no_of_hypersurfaces)
        sage: params
        (2,2,2)

    """
    def __init__(self, dim, deg, hyp_no):
        self.dim = dim
        self.deg = deg
        self.hyp_no = hyp_no


    def t_walls(self, oneps):
        r"""
        Return all the walls corresponding to a specific dimension, degree and number of hypersurfaces and one-parameter subgroup.

        INPUT:

        - ``self`` -- Problem; the dimension, degree and number of hypersurfaces for the problem
        - ``oneps`` -- OPS; an OPS of fractions or ints

        OUTPUT: a list of floats corresponding to the walls

        EXAMPLES:

        The walls given a specific one parameter subgroup (1, 0, -1) in `n = 2` ::

            sage: dimension = 2; degree = 2; no_of_hypersurfaces = 2; oneps = OPS([1, 0, -1])
            sage: params = Problem(dimension, degree, no_of_hypersurfaces)
            sage: walls = params.t_walls(oneps)
            sage: walls
            [0, 1, 2]

        """
        monomial_list1 = Monomial.monomials(self.dim, self.deg)
        monomial_list2 = Monomial.monomials(self.dim, 1)
        walls = []
        r = self.hyp_no
        d = self.dim + 1
        max_wall = r * self.deg / self.dim
        monomial_combinations = itertools.combinations(monomial_list1, int(r))
        for monc in monomial_combinations:
            total_t = Monomial([0 for i in range(d)])
            for j in range(0, len(monc)):
                total_t =  monc[j] + total_t
            for mon in monomial_list2:
                tnum = Monomial(total_t).dot_product(oneps)
                tden = mon.dot_product(oneps)
                if tden != 0:
                    t = -tnum / tden
                    if 0 <= t <= max_wall:
                        walls.append(t)
        if 0 not in walls: #ensures extremal walls are added
            walls.append(0)
        if max_wall not in walls:
            walls.append(max_wall)
        walls = list(dict.fromkeys(walls))
        walls.sort()
        return walls


    def all_walls(self, onepset_list=None):
        r"""
        Return all the walls corresponding to a specific dimension, degree and number of hypersurfaces.

        INPUT:

        - ``self`` -- Problem; the dimension, degree and number of hypersurfaces for the problem
        - ``onepset_list`` -- list of OPS; a list of OPS of fractions or ints

        OUTPUT: a list of floats corresponding to the walls

        EXAMPLES:

        The walls given a specific dimension = 2; degree = 2; no_of_hypersurfaces = 2 ::

            sage: dimension = 2; degree = 2; no_of_hypersurfaces = 2; opset = [OPS((1, 1, -2)), OPS((4, 1, -5)), OPS((5, -1, -4)), OPS((1, 0, -1)), OPS((2, -1, -1))]
            sage: params = Problem(dimension, degree, no_of_hypersurfaces)
            sage: walls = params.all_walls(opset)
            sage: walls
            [0, 1/5, 1/2, 4/5, 1, 5/4, 7/5, 2]

        """
        if onepset_list == None:
            onepset_list = OPS.ops_set(self.dim, self.deg, self.hyp_no)
        monomial_list1 = Monomial.monomials(self.dim, self.deg)
        monomial_list2 = Monomial.monomials(self.dim, 1)
        final_walls = []
        for oneps in onepset_list:
            specific_walls = self.t_walls(oneps)
            final_walls.append(specific_walls)
        final_walls = sum(final_walls, [])
        final_walls = list(dict.fromkeys(final_walls))
        final_walls.sort()
        return final_walls

        # This defines a method to calculate the GIT chambers

    @staticmethod
    def t_chambers(t_wall_list):
        r"""
        Return all the chambers corresponding to a specific dimension, degree and number of hypersurfaces.

        INPUT:

        - ``t_wall_list`` -- list of floats; a list of walls

        OUTPUT: a list of floats corresponding to the chambers

        EXAMPLES:

        The chambers given a specific dimension = 2; degree = 2; no_of_hypersurfaces = 2 ::

            sage: dimension = 2; degree = 2; no_of_hypersurfaces = 2; opset = [OPS((1, 1, -2)), OPS((4, 1, -5)), OPS((5, -1, -4)), OPS((1, 0, -1)), OPS((2, -1, -1))]
            sage: params = Problem(dimension, degree, no_of_hypersurfaces)
            sage: walls = params.all_walls(opset)
            sage: chambers = Problem.t_chambers(walls)
            sage: chambers
            [1/10, 7/20, 13/20, 9/10, 9/8, 53/40, 17/10]

        """
        
        chambers = []
        for i in range(len(t_wall_list) - 1):
            tden = t_wall_list[i] + t_wall_list[i + 1]
            tchamb = tden / 2
            chambers.append(tchamb)
        chambers.sort()
        return chambers



    def max_semi_dest_sets(self, onepslist):
        r"""
        Return the vgit non stable elements for all walls. If onepslist=None then the program generates the fundamental set of one-parameter subgroups.

        INPUT:

        - ``self`` -- Problem; the dimension, degree and number of hypersurfaces for the problem
        - ``onepset_list`` -- list of OPS; a list of OPS of fractions or ints

        OUTPUT: a list of 14 elements each correpsonfing to The maximal families of the complete intersection for all walls (maximal_dest_vm_walls, maximal_dest_bm_walls) and chambers, the maximal families of the hyperplane section for all walls (maximal_dest_bhm_walls) and chambers (maximal_dest_bhm_chambers), the support monomials for the complete intersection and the hyperplane section and each destabilizing gammat and wall/chamber.

        EXAMPLES:

        The full VGIT picture given a specific dimension = 2; degree = 2; no_of_hypersurfaces = 2 ::

            sage: dimension = 2; degree = 2; no_of_hypersurfaces = 2
            sage: params = Problem(dimension, degree, no_of_hypersurfaces)
            sage: vgit_problem = params.max_semi_dest_sets()
            sage: vgit_problem
            [[[[(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)], [(0, 0, 2)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0)], [(0, 0, 2), (0, 1, 1), (0, 2, 0)]], [[(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0)], [(0, 0, 2), (0, 1, 1), (0, 2, 0)]], [[(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)]], [[(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)]]], [[[(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)], [(0, 0, 2)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0)], [(0, 0, 2), (0, 1, 1), (0, 2, 0)]], [[(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0)], [(0, 0, 2), (0, 1, 1), (0, 2, 0)]], [[(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)]]], [[[(0, 0, 2)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)], [(0, 0, 2), (0, 1, 1), (0, 2, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0)]], [[(0, 0, 2), (0, 1, 1), (1, 0, 1)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)], [(0, 0, 2), (0, 1, 1), (0, 2, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0)]], [[(0, 0, 2), (0, 1, 1), (1, 0, 1)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0)]], [[(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)]]], [[[(0, 0, 2)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)], [(0, 0, 2), (0, 1, 1), (0, 2, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0)]], [[(0, 0, 2), (0, 1, 1), (1, 0, 1)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)], [(0, 0, 2), (0, 1, 1), (0, 2, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0)]], [[(0, 0, 2), (0, 1, 1), (1, 0, 1)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0)]]], [[[], [], [], [], []], [[(0, 0, 1)], [(0, 0, 1)], [(0, 0, 1)], [(0, 0, 1)], [(0, 0, 1)]], [[(0, 0, 1)], [(0, 0, 1)], [(0, 0, 1)], [(0, 0, 1)]], [[(0, 0, 1)]]], [[[(0, 0, 1)], [(0, 0, 1)], [(0, 0, 1)], [(0, 0, 1)], [(0, 0, 1)]], [[(0, 0, 1)], [(0, 0, 1)], [(0, 0, 1)], [(0, 0, 1)], [(0, 0, 1)]], [[(0, 0, 1)], [(0, 0, 1)], [(0, 0, 1)], [(0, 0, 1)]]], [[(0, 0, 2), (2, 0, 0), (1, 0, 1), (0, 2, 0), (1, 1, 0)], [(1, 0, 1), (2, 0, 0), (1, 0, 1), (0, 2, 0), (1, 1, 0)], [(1, 0, 1), (2, 0, 0), (1, 0, 1), (1, 1, 0)], [(2, 0, 0)]], [[(0, 0, 2), (2, 0, 0), (1, 0, 1), (0, 2, 0), (1, 1, 0)], [(1, 0, 1), (2, 0, 0), (0, 2, 0), (0, 2, 0), (1, 1, 0)], [(1, 0, 1), (2, 0, 0), (0, 2, 0), (1, 1, 0)]], [[(0, 0, 1), (0, 0, 1), (0, 0, 1), (0, 0, 1), (0, 0, 1)], [(0, 0, 1), (0, 0, 1), (0, 0, 1), (0, 0, 1), (0, 0, 1)], [(0, 0, 1), (0, 0, 1), (0, 0, 1), (0, 0, 1)], [(0, 0, 1)]], [[(0, 0, 1), (0, 0, 1), (0, 0, 1), (0, 0, 1), (0, 0, 1)], [(0, 0, 1), (0, 0, 1), (0, 0, 1), (0, 0, 1), (0, 0, 1)], [(0, 0, 1), (0, 0, 1), (0, 0, 1), (0, 0, 1)]], [[(1, 1, -2), (1, 1, -2), (1, 0, -1), (2, -1, -1), (2, -1, -1)], [(1, 1, -2), (1, 1, -2), (5, -1, -4), (5, -1, -4), (5, -1, -4)], [(1, 1, -2), (1, 1, -2), (1, 0, -1), (1, 0, -1)], [(1, 1, -2)]], [[(1, 1, -2), (1, 1, -2), (1, 0, -1), (2, -1, -1), (2, -1, -1)], [(1, 1, -2), (1, 1, -2), (4, 1, -5), (5, -1, -4), (5, -1, -4)], [(1, 1, -2), (1, 1, -2), (4, 1, -5), (4, 1, -5)]], [0, 1/2, 1, 2], [7/20, 9/10, 17/10]]
        
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
        
        if onepslist == None:
            onepslist = OPS.ops_set(self.dim, self.deg, self.hyp_no)
        flag = [1000]
        r = self.hyp_no-1
        tden = self.deg * self.hyp_no / self.dim
        monomial_hypersurface = Monomial.monomials(self.dim, self.deg)
        monomial_hyperplane = Monomial.monomials(self.dim, 1)
        newflag = 1000
        allwalls = self.all_walls(onepslist) #generates all possible walls
        print('The number of walls is ', len(allwalls))
        allchambers = Problem.t_chambers(allwalls)  #generates all possible chambers
        maximal_dest_vm_walls = []
        maximal_dest_bm_walls = []
        if r > 1:
            maximal_dest_bm_walls = [[] for i in range(r)]
        maximal_dest_bhm_walls = []
        support_monomials_walls = []
        if r > 1:
            support_monomials_walls = [[] for i in range(r)]
        support_monomialsh_walls = []
        set_value = -10
        for i in range(len(allwalls)):
            if allwalls[i] == tden:
                set_value = i
        gamma_walls = []
        for wall in allwalls:  #generates the de-stabilizing families for each wall
            set_t = self.max_sets_t(onepslist, wall)
            maximal_dest_vm_walls.append(set_t[0])
            if r > 1:
                for i in range(r):
                    maximal_dest_bm_walls[i].append(set_t[1][i])
            else:
                maximal_dest_bm_walls.append(set_t[1])
            maximal_dest_bhm_walls.append(set_t[2])
            if r > 1:
                for i in range(r):
                    support_monomials_walls[i].append(set_t[3][i])
            else:
                support_monomials_walls.append(set_t[3])
            support_monomialsh_walls.append(set_t[4])
            gamma_walls.append(set_t[5])
        maximal_dest_vm_chambers = []
        maximal_dest_bm_chambers = []
        if r > 1:
            maximal_dest_bm_chambers = [[] for i in range(r)]
        maximal_dest_bhm_chambers = []
        support_monomials_chambers = []
        if r > 1:
            support_monomials_chambers = [[] for i in range(r)]
        support_monomialsh_chambers = []
        gamma_chambers = []
        for cham in allchambers:  #generates the de-stabilizing families for each chamber
            set_t = self.max_sets_t(onepslist, cham)
            maximal_dest_vm_chambers.append(set_t[0])
            if r > 1:
                for i in range(r):
                    maximal_dest_bm_chambers[i].append(set_t[1][i])
            else:
                maximal_dest_bm_chambers.append(set_t[1])
            maximal_dest_bhm_chambers.append(set_t[2])
            if r > 1:
                for i in range(r):
                    support_monomials_chambers[i].append(set_t[3][i])
            else:
                support_monomials_chambers.append(set_t[3])
            support_monomialsh_chambers.append(set_t[4])
            gamma_chambers.append(set_t[5])
        discarded_positions_walls = []
        discarded_positions_chambers = [] 
        if r > 1: 
            equality_test1 = []
            equality_test2 = []
            for i in range(len(maximal_dest_vm_chambers)): #checks for false walls
                counter1 = 0
                for m in range(r):
                    equality_test1.append(maxsets_comparison(maximal_dest_vm_walls[i + 1], maximal_dest_vm_chambers[i], maximal_dest_bm_walls[m][i + 1], maximal_dest_bm_chambers[m][i], maximal_dest_bhm_walls[i + 1], maximal_dest_bhm_chambers[i], self.hyp_no))
                    if i < len(maximal_dest_vm_chambers) - 1:
                        equality_test2.append(maxsets_comparison(maximal_dest_vm_walls[i + 1], maximal_dest_vm_chambers[i + 1], maximal_dest_bm_walls[m][i + 1], maximal_dest_bm_chambers[m][i + 1], maximal_dest_bhm_walls[i + 1], maximal_dest_bhm_chambers[i + 1], self.hyp_no))
                        if (equality_test1[m] == True) and (equality_test2[m] == True):
                            counter1 = counter1 + 1
                if counter1 == r: #maybe this removes too much
                    discarded_positions_walls.append(i + 1)
                    discarded_positions_chambers.append(i)
        else:
            for i in range(len(maximal_dest_vm_chambers)):
                equality_test1 = maxsets_comparison(maximal_dest_vm_walls[i+1], maximal_dest_vm_chambers[i], maximal_dest_bm_walls[i+1], maximal_dest_bm_chambers[i], maximal_dest_bhm_walls[i+1], maximal_dest_bhm_chambers[i], self.hyp_no)
                if i < len(maximal_dest_vm_chambers)-1:
                    equality_test2 = maxsets_comparison(maximal_dest_vm_walls[i+1], maximal_dest_vm_chambers[i+1], maximal_dest_bm_walls[i+1], maximal_dest_bm_chambers[i+1], maximal_dest_bhm_walls[i+1], maximal_dest_bhm_chambers[i+1], self.hyp_no)
                    if equality_test1 and equality_test2:
                        discarded_positions_walls.append(i+1)
                        discarded_positions_chambers.append(i)
        while set_value in discarded_positions_walls:
            discarded_positions_chambers.remove(set_value - 1)
            discarded_positions_walls.remove(set_value)
        for i in discarded_positions_walls:  #sets to discard false walls/chambers
            maximal_dest_vm_walls[i]= flag
            if r > 1:
                for k in range(r):
                    maximal_dest_bm_walls[k][i] = flag
            else:
                maximal_dest_bm_walls[i] = flag
            maximal_dest_bhm_walls[i] = flag
            if r > 1:
                for k in range(r):
                    support_monomials_walls[k][i] = flag
            else:
                support_monomials_walls[i] = flag
            support_monomialsh_walls[i] = flag
            gamma_walls[i] = flag
        while flag in maximal_dest_vm_walls:
            maximal_dest_vm_walls.remove(flag)
        if r > 1:
            for k in range(r):
                while flag in maximal_dest_bm_walls[k]:
                    maximal_dest_bm_walls[k].remove(flag)
        else:
            while flag in maximal_dest_bm_walls:
                maximal_dest_bm_walls.remove(flag)
        while flag in maximal_dest_bhm_walls:
            maximal_dest_bhm_walls.remove(flag)
        if r > 1:
            for k in range(r):
                while flag in support_monomials_walls[k]:
                    support_monomials_walls[k].remove(flag)
        else:
            while flag in support_monomials_walls:
                support_monomials_walls.remove(flag)
        while flag in support_monomialsh_walls:
            support_monomialsh_walls.remove(flag)
        while flag in gamma_walls:
            gamma_walls.remove(flag)
        for j in discarded_positions_chambers:
            maximal_dest_vm_chambers[j] = flag
            if r > 1:
                for k in range(r):
                    maximal_dest_bm_chambers[k][j] = flag
            else:
                maximal_dest_bm_chambers[j] = flag
            maximal_dest_bhm_chambers[j] = flag
            if r > 1:
                for k in range(r):
                    support_monomials_chambers[k][j] = flag
            else:
                support_monomials_chambers[j] = flag
            support_monomialsh_chambers[j] = flag
            gamma_chambers[j] = flag
        while flag in maximal_dest_vm_chambers:
            maximal_dest_vm_chambers.remove(flag)
        if r > 1:
            for k in range(r):
                while flag in maximal_dest_bm_chambers[k]:
                    maximal_dest_bm_chambers[k].remove(flag)
        else:
            while flag in maximal_dest_bm_chambers:
                maximal_dest_bm_chambers.remove(flag)
        while flag in maximal_dest_bhm_chambers:
            maximal_dest_bhm_chambers.remove(flag)
        if r > 1:
            for k in range(r):
                while flag in support_monomials_chambers[k]:
                    support_monomials_chambers[k].remove(flag)
        else:
            while flag in support_monomials_chambers:
                support_monomials_chambers.remove(flag)
        while flag in support_monomialsh_chambers:
            support_monomialsh_chambers.remove(flag)
        while flag in gamma_chambers:
            gamma_chambers.remove(flag)
        used_walls = allwalls.copy()
        used_chambers = allchambers.copy()
        for k in discarded_positions_walls:
            used_walls[k] = newflag
        while newflag in used_walls:
            used_walls.remove(newflag)
        for numb in discarded_positions_chambers:
            used_chambers[numb] = newflag
        while newflag in used_chambers:
            used_chambers.remove(newflag)  #writes families to txt files
        # with open("maximal_dest_vm_walls.txt", "wb") as fp:   #Pickling
        #     pickle.dump(maximal_dest_vm_walls, fp)
        # with open("maximal_dest_vm_chambers.txt", "wb") as fp:   #Pickling
        #     pickle.dump(maximal_dest_vm_chambers, fp)
        # with open("maximal_dest_bm_walls.txt", "wb") as fp:   #Pickling
        #     pickle.dump(maximal_dest_bm_walls, fp)
        # with open("maximal_dest_bm_chambers.txt", "wb") as fp:   #Pickling
        #     pickle.dump(maximal_dest_bm_chambers, fp)
        # with open("maximal_dest_bhm_walls.txt", "wb") as fp:   #Pickling
        #     pickle.dump(maximal_dest_bhm_walls, fp)
        # with open("maximal_dest_bhm_chambers.txt", "wb") as fp:   #Pickling
        #     pickle.dump(maximal_dest_bhm_chambers, fp)
        # with open("support_monomials_walls.txt", "wb") as fp:   #Pickling
        #     pickle.dump(support_monomials_walls, fp)
        # with open("support_monomials_chambers.txt", "wb") as fp:   #Pickling
        #     pickle.dump(support_monomials_chambers, fp)
        # with open("support_monomialsh_walls.txt", "wb") as fp:   #Pickling
        #     pickle.dump(support_monomialsh_walls, fp)
        # with open("support_monomialsh_chambers.txt", "wb") as fp:   #Pickling
        #     pickle.dump(support_monomialsh_chambers, fp)
        # with open("gamma_walls.txt", "wb") as fp:   #Pickling
        #     pickle.dump(gamma_walls, fp)
        # with open("gamma_chambers.txt", "wb") as fp:   #Pickling
        #     pickle.dump(gamma_chambers, fp)
        # with open("used_walls.txt", "wb") as fp:   #Pickling
        #     pickle.dump(used_walls, fp)
        # with open("used_chambers.txt", "wb") as fp:   #Pickling
        #     pickle.dump(used_chambers, fp) #todo maybe add return and not rely on pickle
        return [maximal_dest_vm_walls, maximal_dest_vm_chambers, maximal_dest_bm_walls, maximal_dest_bm_chambers, maximal_dest_bhm_walls, maximal_dest_bhm_chambers, support_monomials_walls, support_monomials_chambers, support_monomialsh_walls, support_monomialsh_chambers, gamma_walls, gamma_chambers, used_walls, used_chambers]


    def max_sets_t(self, onepslist, t=0):
        r"""
        Return the vgit non stable elements for a specific wall. The default value is t=0 which corresponds to a GIT problem. If onepslist=None then the program generates the fundamental set of one-parameter subgroups.

        INPUT:

        - ``self`` -- Problem; the dimension, degree and number of hypersurfaces for the problem
        - ``onepset_list`` -- list of OPS; a list of OPS of fractions or ints, Default None
        - ``t`` -- float; a wall, Default 0

        OUTPUT: a list of 6 elements each correpsonfing to The maximal families of the complete intersection (maximal_dest_vmt, maximal_dest_bmt), the maximal families of the hyperplane section (if t is non-zero) (maximal_dest_bhmt), the support monomials for the complete intersection and the hyperplane section (support_monomialst, support_monomialsht), and each destabilizing gammat

        EXAMPLES:

        The maximal destabilizing families given a specific dimension = 2; degree = 2; no_of_hypersurfaces = 2 ::

            sage: dimension = 2; degree = 2; no_of_hypersurfaces = 2
            sage: params = Problem(dimension, degree, no_of_hypersurfaces)
            sage: git_problem = params.max_sets_t()
            sage: git_problem
            [[[(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)], [(0, 0, 2)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0)], [(0, 0, 2), (0, 1, 1), (0, 2, 0)]], [[(0, 0, 2)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)], [(0, 0, 2), (0, 1, 1), (0, 2, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0)]], [[], [], [], [], []], [(0, 0, 2), (2, 0, 0), (1, 0, 1), (0, 2, 0), (1, 1, 0)], [(0, 0, 1), (0, 0, 1), (0, 0, 1), (0, 0, 1), (0, 0, 1)], [(1, 1, -2), (1, 1, -2), (1, 0, -1), (2, -1, -1), (2, -1, -1)]]
        
        TEST:

        The maximal destabilizing families given a specific dimension = 1; degree = 4; no_of_hypersurfaces = 2 ::

            sage: dimension = 1; degree = 4; no_of_hypersurfaces = 2
            sage: params = Problem(dimension, degree, no_of_hypersurfaces)
            sage: git_problem = params.max_sets_t()
            sage: git_problem
            [[[(0, 4), (1, 3), (2, 2), (3, 1), (4, 0)], [(0, 4), (1, 3), (2, 2), (3, 1)], [(0, 4), (1, 3), (2, 2)], [(0, 4), (1, 3)], [(0, 4)]], [[(0, 4)], [(0, 4), (1, 3)], [(0, 4), (1, 3), (2, 2)], [(0, 4), (1, 3), (2, 2), (3, 1)], [(0, 4), (1, 3), (2, 2), (3, 1), (4, 0)]], [[], [], [], [], []], [(0, 4), (1, 3), (2, 2), (3, 1), (4, 0)], [(0, 1), (0, 1), (0, 1), (0, 1), (0, 1)], [(1, -1), (1, -1), (1, -1), (1, -1), (1, -1)]]

        ALGORITHM:

        We set `r` support monomials where `r = hyp_no - 1` and a support monomial for the hyperplane and we for each one-parameter subgroup in the fundamental set, we check the Hilbert-Mumford 
        numerical criterion for all the monomials of the hypersurface. For each monomial that satisfies the Hilbert- Mumford numerical criterion we add them to the list vm. For each support monomial
        we also check which of the monomials in the hypersurface and the hyperplane respectively are less with respect to the monomial order for the given one-parameter subgroup `\gamma`. We add these
        to the lists bm and bhm where the [vm, bm] correspond to the maximal destabilizing families for the complete intersection (bm here is a list of `r` families) where each of these correspond to one polynomial in
        the complete intersection. bhm corresponds to the maximal destabilizing family of the hyperplane. If for two different tuples `vm_i, bm_i, bhm_i` and `vm_j, bm_j, bhm_j` we have `vm_i \susbeteq vm_j`,
        `bm_i \susbeteq bm_j` and `bhm_i \susbeteq bhm_j` we only add the tuple `vm_j, bm_j, bhm_j` to our list of families (this is achieved via inclusion_condition()), which is the necessary condition that 
        the families are maximal. We further remove any duplicate families and then we append each part of the tuple to the necessary list of families. We also keep that support monomials and destabilizing one-parameter
        subgroups used, for convenience (and for checking whether the families are strictly semistable).

        """
    
        # monomial_list1 corresponds to monomials in hypersurface, monomial_list2 corresponds to monomials in hyperplane
        if onepslist == None:
            onepslist = OPS.ops_set(self.dim, self.deg, self.hyp_no)
        monomial_list1 = Monomial.monomials(self.dim, self.deg)
        monomial_list2 = Monomial.monomials(self.dim, 1)
        flag = [1000]
        r = self.hyp_no-1
        mon_combins = monomial_list1
        if r > 1:
            mon_combins = list(itertools.combinations(monomial_list1, int(r)))
        maximal_dest_vmt = []
        maximal_dest_bmt = []
        if r > 1:
            maximal_dest_bmt = [[] for i in range(r)]
        maximal_dest_bhmt = []
        support_monomialst = []
        if r > 1:
            support_monomialst = [[] for i in range(r)]
        support_monomialsht = []
        gammat = []
        for gamma in onepslist:   #checks H-M for all one-parameter subgroups
            for moni in mon_combins:   #the support monomial(s) for the hypersurface
                for monxj in monomial_list2:   #the support monomial for the hyperplane
                    cond = hilbert_mumford(moni, monxj, gamma, monomial_list1, monomial_list2,self.dim, self.hyp_no, t)
                    if cond: #checks Hilbert-Mumford numerical criterion
                        vm = cond[0] #generates the maximal destablizing families
                        bm = cond[1]
                        bhm = cond[2]
                    else:
                        continue
                    incl =  inclusion_condition(gamma, t, vm, bm, bhm, moni, monxj, self.hyp_no, maximal_dest_vmt, maximal_dest_bmt, maximal_dest_bhmt, support_monomialst, support_monomialsht, gammat) 
                    maximal_dest_vmt = incl[0]
                    maximal_dest_bmt = incl[1]
                    maximal_dest_bhmt  = incl[2]
                    support_monomialst = incl[3]
                    support_monomialsht  = incl[4]
                    gammat = incl[5] #adds recursively all families in a list of families
        for j in range(len(maximal_dest_vmt)):  #removes all extra elements not detected by method above - maybe also implement into seperate function?
            for k in range(len(maximal_dest_vmt)):
                test1 = all(elem in maximal_dest_vmt[j] for elem in maximal_dest_vmt[k])
                test2 = True
                if r == 1:
                    test2 = all(elem in maximal_dest_bmt[j] for elem in maximal_dest_bmt[k])
                if r > 1:
                    test_for_bs = [0 for i in range(r)]
                    new_counter = 0
                    for m in range(r):
                        test_for_bs[m] = all(elem in maximal_dest_bmt[m][j] for elem in maximal_dest_bmt[m][k])
                        if test_for_bs[m]:
                            new_counter = new_counter + 1
                    if new_counter == r:
                        test2 = True
                    else:
                        test2 = False
                test3 = all(elem in maximal_dest_bhmt[j] for elem in maximal_dest_bhmt[k])
                if test1 and test2 and test3 and j != k:
                    maximal_dest_vmt[k] = flag
                    if r > 1:
                        for i in range(r):
                            maximal_dest_bmt[i][k] = flag
                    else:
                        maximal_dest_bmt[k] = flag
                    maximal_dest_bhmt[k] = flag
                    if r > 1:
                        for i in range(r):
                            support_monomialst[i][k] = flag
                    else:
                        support_monomialst[k] = flag
                    support_monomialsht[k] = flag
                    gammat[k] = flag
        while flag in maximal_dest_vmt:
            maximal_dest_vmt.remove(flag)
        if r > 1:
            for i in range(r):
                while flag in maximal_dest_bmt[i]:
                    maximal_dest_bmt[i].remove(flag)
        else:
            while flag in maximal_dest_bmt:
                maximal_dest_bmt.remove(flag)
        while flag in maximal_dest_bhmt:
            maximal_dest_bhmt.remove(flag)
        if r > 1:
            for i in range(r):
                while flag in support_monomialst[i]:
                    support_monomialst[i].remove(flag)
        else:
            while flag in support_monomialst:
                support_monomialst.remove(flag)
        while flag in support_monomialsht:
            support_monomialsht.remove(flag)
        while flag in gammat:
            gammat.remove(flag)
        print('Max sets generated')
        return [maximal_dest_vmt, maximal_dest_bmt, maximal_dest_bhmt, support_monomialst, support_monomialsht, gammat]


    def max_semi_sets_t(self, onepslist, t=0):
        r"""
        Return the vgit unstable elements for a specific wall. The default value is t=0 which corresponds to a GIT problem. If onepslist=None then the program generates the fundamental set of one-parameter subgroups.

        INPUT:

        - ``self`` -- Problem; the dimension, degree and number of hypersurfaces for the problem
        - ``onepset_list`` -- list of OPS; a list of OPS of fractions or ints, Default None
        - ``t`` -- float; a wall, Default 0

        OUTPUT: a list of 6 elements each correpsonfing to The maximal families of the complete intersection (maximal_semidest_vominust, maximal_semidest_bominust), the maximal families of the hyperplane section (if t is non-zero) (maximal_semidest_bhominust), the support monomials for the complete intersection and the hyperplane section (support_monomialst, support_monomialsht), and each destabilizing gammat

        EXAMPLES:

        The maximal destabilizing families given a specific dimension = 2; degree = 2; no_of_hypersurfaces = 2 ::

            sage: dimension = 2; degree = 2; no_of_hypersurfaces = 2
            sage: params = Problem(dimension, degree, no_of_hypersurfaces)
            sage: git_problem = params.max_sets_t()
            sage: git_problem
            [[[(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)], [(0, 0, 2)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0)], [(0, 0, 2), (0, 1, 1), (0, 2, 0)]], [[(0, 0, 2)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)], [(0, 0, 2), (0, 1, 1), (0, 2, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0)]], [[], [], [], [], []], [(0, 0, 2), (2, 0, 0), (1, 0, 1), (0, 2, 0), (1, 1, 0)], [(0, 0, 1), (0, 0, 1), (0, 0, 1), (0, 0, 1), (0, 0, 1)], [(1, 1, -2), (1, 1, -2), (1, 0, -1), (2, -1, -1), (2, -1, -1)]]
        
        
        ALGORITHM:

        We set `r` support monomials where `r = hyp_no - 1` and a support monomial for the hyperplane and we for each one-parameter subgroup in the fundamental set, we check the Hilbert-Mumford 
        numerical criterion for all the monomials of the hypersurface. For each monomial that satisfies the Hilbert- Mumford numerical criterion we add them to the list vominus. For each support monomial
        we also check which of the monomials in the hypersurface and the hyperplane respectively are less with respect to the monomial order for the given one-parameter subgroup `\gamma`. We add these
        to the lists bominus and bhominus where the [vominus, bominus] correspond to the maximal destabilizing families for the complete intersection (bominus here is a list of `r` families) where each of these correspond to one polynomial in
        the complete intersection. bhominus corresponds to the maximal destabilizing family of the hyperplane. If for two different tuples `vominus_i, bominus_i, bhominus_i` and `vominus_j, bominus_j, bhominus_j` we have `vominus_i \susbeteq vominus_j`,
        `bominus_i \susbeteq bominus_j` and `bhominus_i \susbeteq bhominus_j` we only add the tuple `vominus_j, bominus_j, bhominus_j` to our list of families (this is achieved via inclusion_condition()), which is the necessary condition that 
        the families are maximal. We further remove any duplicate families and then we append each part of the tuple to the necessary list of families. We also keep that support monomials and destabilizing one-parameter
        subgroups used, for convenience (and for checking whether the families are strictly semistable).

        """

        # monomial_list1 corresponds to monomials in hypersurface, monomial_list2 corresponds to monomials in hyperplane
        if onepslist == None:
            onepslist = OPS.ops_set(self.dim, self.deg, self.hyp_no)
        monomial_list1 = Monomial.monomials(self.dim, self.deg)
        monomial_list2 = Monomial.monomials(self.dim, 1)
        flag = [1000]
        r = self.hyp_no-1
        mon_combins = monomial_list1
        if r > 1:
            mon_combins = list(itertools.combinations(monomial_list1, int(r)))
        maximal_semidest_vominust = []
        maximal_semidest_bominust = []
        if r > 1:
            maximal_semidest_bominust = [[] for i in range(r)]
        maximal_semidest_bhominust = []
        support_monomialst = []
        if r > 1:
            support_monomialst = [[] for i in range(r)]
        support_monomialsht = []
        gammat = []
        for gamma in onepslist:   #checks H-M for all one-parameter subgroups
            for moni in mon_combins:   #the support monomial(s) for the hypersurface
                for monxj in monomial_list2:   #the support monomial for the hyperplane
                    cond = hilbert_mumford_not_equal(moni, monxj, gamma, monomial_list1, monomial_list2,self.dim, self.hyp_no, t)
                    if cond: #checks Hilbert-Mumford numerical criterion
                        vominus = cond[0] #generates the maximal destablizing families
                        bominus = cond[1]
                        bhominus = cond[2]
                    else:
                        continue
                    incl =  inclusion_condition(gamma, t, vominus, bominus, bhominus, moni, monxj, self.hyp_no, maximal_semidest_vominust, maximal_semidest_bominust, maximal_semidest_bhominust, support_monomialst, support_monomialsht, gammat) 
                    maximal_semidest_vominust = incl[0]
                    maximal_semidest_bominust = incl[1]
                    maximal_semidest_bhominust  = incl[2]
                    support_monomialst = incl[3]
                    support_monomialsht  = incl[4]
                    gammat = incl[5] #adds recursively all families in a list of families
        for j in range(len(maximal_semidest_vominust)):  #removes all extra elements not detected by method above - maybe also implement into seperate function?
            for k in range(len(maximal_semidest_vominust)):
                test1 = all(elem in maximal_semidest_vominust[j] for elem in maximal_semidest_vominust[k])
                test2 = True
                if r == 1:
                    test2 = all(elem in maximal_semidest_bominust[j] for elem in maximal_semidest_bominust[k])
                if r > 1:
                    test_for_bs = [0 for i in range(r)]
                    new_counter = 0
                    for m in range(r):
                        test_for_bs[m] = all(elem in maximal_semidest_bominust[m][j] for elem in maximal_semidest_bominust[m][k])
                        if test_for_bs[m]:
                            new_counter = new_counter + 1
                    if new_counter == r:
                        test2 = True
                    else:
                        test2 = False
                test3 = all(elem in maximal_semidest_bhominust[j] for elem in maximal_semidest_bhominust[k])
                if test1 and test2 and test3 and j != k:
                    maximal_semidest_vominust[k] = flag
                    if r > 1:
                        for i in range(r):
                            maximal_semidest_bominust[i][k] = flag
                    else:
                        maximal_semidest_bominust[k] = flag
                    maximal_semidest_bhominust[k] = flag
                    if r > 1:
                        for i in range(r):
                            support_monomialst[i][k] = flag
                    else:
                        support_monomialst[k] = flag
                    support_monomialsht[k] = flag
                    gammat[k] = flag
        while flag in maximal_semidest_vominust:
            maximal_semidest_vominust.remove(flag)
        if r > 1:
            for i in range(r):
                while flag in maximal_semidest_bominust[i]:
                    maximal_semidest_bominust[i].remove(flag)
        else:
            while flag in maximal_semidest_bominust:
                maximal_semidest_bominust.remove(flag)
        while flag in maximal_semidest_bhominust:
            maximal_semidest_bhominust.remove(flag)
        if r > 1:
            for i in range(r):
                while flag in support_monomialst[i]:
                    support_monomialst[i].remove(flag)
        else:
            while flag in support_monomialst:
                support_monomialst.remove(flag)
        while flag in support_monomialsht:
            support_monomialsht.remove(flag)
        while flag in gammat:
            gammat.remove(flag)
        print('Max sets generated')
        return [maximal_semidest_vominust, maximal_semidest_bominust, maximal_semidest_bhominust, support_monomialst, support_monomialsht, gammat]

