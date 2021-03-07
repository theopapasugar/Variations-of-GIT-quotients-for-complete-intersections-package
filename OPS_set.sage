#!/usr/bin/python36
from functions import *
#todo add sage documentation

def ops_set(monomial_list, dim, hyp_no):
    """

    @param monomial_list: a list of list of floats, corresponding to all the monomials of the hyperpsurface
    @param dim: int, the dimension of the embedded projective space
    @param hyp_no: the number of hypersurfaces
    @return: a list of list of floats, corresponding to all the one-parameter subgroups
    """
    dimn = dim+1
    flag1 = [1000 for i in range(dim+1)]
    r = 2*hyp_no
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
        total_p = [0 for i in range(dim+1)]
        for j in range(len(perm)):
            total_p = [a-b for a, b in zip(perm[j], total_p)]
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
                sols_new = mult_by_lcm(list(x1))
            #transforms solutions from floats to ints
                sols.append(sols_new)
        except Exception as e:
            pass
    sols_set = []
    for elem in sols:
        if elem[dim] < 0 and ordertest(elem):
            #keeps only normalised one-parameter subgroups
            sols_set.append(elem)
    full_solution = [tuple(elem) for elem in sols_set]
    final_set = list(set(full_solution))  #removes duplicates
    final_set1 = [list(elem) for elem in final_set]
    print(len(final_set1))
    with open("ops_set.txt", "wb") as fp:
        #Pickling
        pickle.dump(final_set1, fp)
    return final_set1
