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
    """docstring for OPS"""
    def __init__(self, data):
        self = Original(data)
    

    def ordertest(self):
        r"""
        Return True or False if self is ordered in a descending order`.

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
    def ops_set(dim, deg, hyp_no): #need to write comments for SAGE here +include math to make it clearer what is happening
        """

        @param monomial_list: a list of list of floats, corresponding to all the monomials of the hyperpsurface. DEFAULT: the monomial list of given dimension and degree
        @param self.dim: int, the dimension of the embedded projective space
        @param self.hyp_no: the number of hypersurfaces
        @return: a list of list of floats, corresponding to all the one-parameter subgroups
        """
        monomial_list = Monomial.monomials(dim, deg)
        dimn = dim + 1
        flag1 = [1000 for i in range(dim+1)]
        r = 2 * hyp_no
        monomial_combs = list(itertools.combinations(monomial_list, int(r)))
        eqs = []
        vector3 = [1 for i in range(dimn)]
        vector4 = [0 for i in range(dim)]
        vector4.insert(0, 1)
        vector_f = [vector3, vector4]
        vector_t = [0 for i in range(dim)]
        vector_t.append(1)
        vector_target = vector(vector_t)
        for perm in monomial_combs:
            total_p = Monomial([0 for i in range(dim + 1)])
            for j in range(len(perm)):
                #total_p = [a-b for a, b in zip(perm[j], total_p)]
                total_p = perm[j] - total_p
            eqs.append(total_p)
        full_eqs = [tuple(eqs[i]) for i in range(len(eqs))]
        final = list(set(full_eqs))
        eqs_final = [list(elem) for elem in final]
        #generates all possible equations using the monomials
        for i in range(len(eqs_final)):
            #removes multiples
            for j in range(len(eqs_final)):
                if eqs_final[i] == [(-1)*eqs_final[j][k] for k in range(len(eqs_final[j]))] and i != j:
                    eqs_final[j] = flag1
        while flag1 in eqs_final:
            eqs_final.remove(flag1)
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
            for elem in sols:
                if elem[dim] < 0 and elem.ordertest():
                    #keeps only normalised one-parameter subgroups
                    sols_set.append(elem)
#            full_solution = [tuple(elem) for elem in sols_set]
#            final_set = list(set(full_solution))  #removes duplicates
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
