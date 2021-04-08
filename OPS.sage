def my_import(module_name, func_name='*'):
    import os
    os.system('sage --preparse ' + module_name + '.sage')
    os.system('mv ' + module_name + '.sage.py ' + module_name + '.py')

    from sage.misc.python import Python
    python = Python()
    python.eval('from ' + module_name + ' import ' + func_name, globals())

my_import("functions")
my_import("Monomials")

class OPS(Original):
    r"""
    Wrapper class of Original, contains basic functions to use with OPS.

    EXAMPLES:

        sage: test1 = OPS([1, 2, 3, 4])
        sage: test1
        (1, 2, 3, 4)

    """
    def __init__(self, data):
        self = Original(data)
    

    def ordertest(self):
        r"""
        Return True or False if self is ordered in a descending order.

        INPUT:

        - ``seq`` -- list; contains floats or ints

        OUTPUT: True or False

        EXAMPLES:

        This example illustrates a non ordered list ::

            sage: test1 = OPS([1, 2, 3, 4])
            sage: test1.ordertest()
            False

        This example illustrates an ordered list ::

            sage: test1 = OPS([10, 9, 8, 7, 6, 5, 2])
            sage: test1.ordertest()
            True

        """
    
        return all(earlier >= later for earlier, later in zip(self, self[1:]))


    def mult_by_lcm(self):
        r"""
        Return the list multiplied by least common multiple of denominators of its list elements.

        INPUT:

        - ``self`` -- OPS; this should be a list of fractions or ints

        OUTPUT: the list multiplied by the lcm

        EXAMPLES:

        This example illustrates the basic function of mult_by_lcm ::

            sage: testl = OPS([1/3, 3/5, 2/3, 4/3])
            sage: test1.mult_by_lcm()
            (5, 9, 10, 20)

        We now test for a case where all denominators are different ::

            sage: testl = OPS([1/2, 1/3, 1/4, 1/5])
            sage: test1.mult_by_lcm()
            (30, 20, 15, 12)

        It is an error to use a list with floats in it ::

            sage: testl = OPS([1.3, 3.5, 2.7])
            sage: test1.mult_by_lcm()
            Traceback (most recent call last):
            ...
            AttributeError: 'sage.rings.real_mpfr.RealLiteral' object has no attribute 'denominator'


        TESTS::

            sage: testl = OPS([1, 2, 3, 4, 5])  # Check for case where all elements are ints
            sage: testl.mult_by_lcm()
            (1, 2, 3, 4, 5)
        """
        
        denominator_list = [self[i].denominator() for i in range(len(self))]
        lcm = denominator_list[0]
        for d in denominator_list[1:]:
            lcm = lcm / gcd(lcm, d) * d
        return OPS([x * lcm for x in self])


    @staticmethod
    def ops_set(dim, deg, hyp_no): 
        r"""
        Return the fundamental set of one-parameter subgroups corresponding to dimension, degree and number of hypersurfaces.

        INPUT:

        - ``dim`` -- int; the dimension of the problem

        - ``deg`` -- int; the degree of the complete intersection polynomials
        
        - ``hyp_no`` -- int; the number of hypersurfaces in the complete intersection

        OUTPUT: a list of OPS, corresponding to all the one-parameter subgroups

        EXAMPLES:

        This example illustrates the construction of a simple set of one-parameter subgrpups, of the complete intersection of two quadrics in `\mathbb{P}^2` ::

            sage: dimension = 2; degree = 2; no_of_hypersurfaces = 2
            sage: opset = OPS.ops_set(dimension, degree, no_of_hypersurfaces)
            sage: opset
            [(1, 1, -2), (4, 1, -5), (5, -1, -4), (1, 0, -1), (2, -1, -1)]


        This example illustrates that we can also compute the fundamental set for hypersurfaces in `\mathbb{P}^n`, where here `n=3' ::

            sage: dimension = 3; degree = 2; no_of_hypersurfaces = 1
            sage: opset = OPS.ops_set(dimension, degree, no_of_hypersurfaces)
            sage: opset
            [(9, 1, -3, -7), (5, 1, -3, -3), (1, 1, 1, -3), (7, 3, -1, -9), (3, -1, -1, -1), (1, 1, -1, -1), (1, 0, 0, -1), (3, 1, -1, -3), (3, 3, -1, -5)]


        For complete intersections in `\mathbb{P}^1` there is only one one-parameter subgroup::

            sage: dimension = 1; degree = 9; no_of_hypersurfaces = 4
            sage: opset = OPS.ops_set(dimension, degree, no_of_hypersurfaces)
            sage: opset
            [(1,-1)]

        ALGORITHM::
            
        Let `I_i`, `J_i` with `0 \leq i \leq hyp_no` be monomials of degree d, in dimension n i.e. in `\mathbb{P}^n`. These are represented
        by arrays `(d_{0i}, \dots, d_{ni})` with `\sum_{j=0}^n d_{ji} = d`.
        The fundamental set of one parameter subgroups, where each one-parameter subgroup is a diagonal element of `SL(n+1)`
        and is represented by an array `\lambda = (a_0, \dots, a_n)` with `\sum_{i=0}^n a_i = 0` and `a_i \geq a_{i+1}` corresponds to 
        solutions of the consistent linear systems given by the above conditions (with also assuming `a_0  = 1`) and the following
        `n-1` equations of the form `\sum_{i=0}^{hyp_no} \langle I_i-J_i, \lambda \rangle = 0` with `\langle , \rangle` the inner product.

        Finding the fundamental set requires first to find all possible arrays corresponding to `\sum_{i=0}^{hyp_no} I_i-J_i`. This is achieved by taking
        permutations of the set of monomials of length `2*hyp_no` and subtracting each element in sequence from another. We do this below, and we call all these
        possible arrays eqs_final. We also remove arrays `\gamma` if `\gamma = - \lambda` for some `\lambda \in eqs_final`, as they both generate the same 
        linear system. 

        We then proceed to take combinations of length `n-1` of our arrays in eqs_final in order to construct the linear systems. We construct vector_3 `= (1, \dots, 1)`
        and vector_4 `= (1, 0, \dots, 0)` which correspond to `\sum_{i=0}^n a_i = 0` and `a_0  = 1` respectivelly. We are interested in solving the linear system 
        `A\cdot x = `vector_target with vector_target `= (0, \dots, 0, 1)` and `A` the matrix with rows the `n-1` arrays given as the combinations of different elements of 
        eqs_final and vector_3 and vector_4. These correspond precisely to the linear systems described above that give the fundamental set of one-parameter subgroups.
        We only keep solutions of the consistent linear system that satisfy `a_i \geq a_{i+1}`. We also multiply each solution with the lcm of the denominators 
        of each element so that we obtain a one-parameter subgroup with integer entries.

        WARNING::

        Inputting a high number for deg, dim or hyp_no makes the computation time too long.
                        

        """
        monomial_list = Monomial.monomials(dim, deg)
        dimn = dim + 1
        flag1 = [1000 for i in range(dim+1)]
        r = 2 * hyp_no
        monomial_perms = list(itertools.permutations(monomial_list, int(r)))
        #create permutations of pairs equal to the number of hypersurfaces
        eqs = []
        vector3 = [1 for i in range(dimn)]
        #corresonds to saying that the OPS is in `SL(n+1)`
        vector4 = [0 for i in range(dim)]
        vector4.insert(0, 1)
        #corresponds to setting the first entry in the diagonal to be 1
        vector_f = [vector3, vector4]
        vector_t = [0 for i in range(dim)]
        vector_t.append(1)
        vector_target = vector(vector_t)
        #the vector v in the algorithm
        for perm in monomial_perms:
            total_p = Monomial([0 for i in range(dim + 1)])
            for j in range(len(perm)):
                total_p = perm[j] - total_p
                # This is essentially `\sum I_i - \sum J_i`
            eqs.append(total_p)
        full_eqs = [tuple(eqs[i]) for i in range(len(eqs))]
        final = list(set(full_eqs))
        eqs_final = [list(elem) for elem in final]
        #generates all possible equations using the monomials according to algorithm
        for i in range(len(eqs_final)):
            #removes multiples
            for j in range(len(eqs_final)):
                if eqs_final[i] == [(-1)*eqs_final[j][k] for k in range(len(eqs_final[j]))] and i != j:
                    eqs_final[j] = flag1
        while flag1 in eqs_final:
            eqs_final.remove(flag1)
        #this step discards multiples
        print(len(eqs_final))
        sols = []
        const_ops = [0 for el in range(dim - 1)]
        const_ops.append(-1)
        const_ops.insert(0, 1)
        sols.append(OPS(const_ops))
        if dim > 2:
            combs_list = list(itertools.combinations(eqs_final, int(dim-1)))
            combs_list = [list(el) for el in combs_list]
            #generates the linear system depending on monomials
            for elem in combs_list:
                try:
                    mat_list = elem + vector_f
                    #cop = elem.deepcopy()
                    mat = Matrix(tuple(mat_list))
                    if mat.rank() == dimn:
                        x1 = mat.solve_right(vector_target)
                    #solves the determinable linear systems
                        sols_new = OPS(x1).mult_by_lcm()
                    #transforms solutions from floats to ints
                        sols.append(sols_new)
                except Exception as e:
                    pass
            sols_set = []
            print(len(sols))
            for elem in sols:
                if elem[dim] < 0 and elem.ordertest():
                    #keeps only normalised one-parameter subgroups
                    sols_set.append(elem)
#            full_solution = [tuple(elem) for elem in sols_set]
            final_set = list(set(sols_set))  #removes duplicates
            final_set1 = [OPS(elem) for elem in final_set]
            print(len(final_set1))
            with open("ops_set.txt", "wb") as fp:
                #Pickling
                pickle.dump(final_set1, fp)
            return final_set1
        elif dim == 2:
            for elem in eqs_final:
                try:
                    mat_list = [elem] + vector_f
                    mat = Matrix(tuple(mat_list))
                    if mat.rank() == dimn:
                        x1 = mat.solve_right(vector_target)
                    #solves the determinable linear systems
                        sols_new = OPS(x1).mult_by_lcm()
                    #transforms solutions from floats to ints
                        sols.append(sols_new)
                except Exception as e:
                    pass
            sols_set = []
            for elem in sols:
                if elem[dim] < 0 and elem.ordertest():
                    #keeps only normalised one-parameter subgroups
                    sols_set.append(elem)
            final_set = list(set(sols_set))  #removes duplicates
            final_set1 = [OPS(elem) for elem in final_set]
            print(len(final_set1))
            with open("ops_set.txt", "wb") as fp:
                #Pickling
                pickle.dump(final_set1, fp)
            return final_set1
        else:
            final_set1 = [OPS([1, -1])]
            with open("ops_set.txt", "wb") as fp:
                #Pickling
                pickle.dump(final_set1, fp)
            return final_set1
