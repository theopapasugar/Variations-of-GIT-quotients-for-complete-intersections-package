#!/usr/bin/python36

import numpy as np

import itertools

import pickle

from fractions import Fraction

import math

from scipy import linalg

from scipy.spatial import ConvexHull


def my_import(module_name, func_name='*'):
    import os
    os.system('sage --preparse ' + module_name + '.sage')
    os.system('mv ' + module_name + '.sage.py ' + module_name + '.py')

    from sage.misc.python import Python
    python = Python()
    python.eval('from ' + module_name + ' import ' + func_name, globals())


my_import("Monomials")

my_import("OPS")

#TODO add docstrings in sage format



def equal_listoflists(listof1, listof2):
    r"""
    Return True or False if listof1 has the same elements as listof1.

    INPUT:

    - ``listof1`` -- list of lists; contains lists of ints, representing monomials

    - ``listof2`` -- list of lists; contains lists of ints, representing monomials

    OUTPUT: True or False

    EXAMPLES:

    This example illustrates two equal lists of lists ::

        sage: test1 = [[1, 1, 0, 0], [1, 0 , 0 , 1], [2, 0, 0, 0]]; test2 = [[2, 0, 0, 0], [1, 1, 0, 0], [1, 0 , 0 , 1]]
        sage: equal_listoflists(test1, test2)
        True

    This example illustrates two non equal lists of lists ::

        sage: test1 = [[1, 1, 0, 0], [1, 0 , 0 , 1], [2, 0, 0, 0]]; test2 = [[1, 0, 1, 0], [0, 0, 0, 2]]
        sage: equal_listoflists(test1, test2)
        False
    """
    first_set = set(map(tuple, listof1))
    secnd_set = set(map(tuple, listof2))
    equality_test = list(first_set.symmetric_difference(secnd_set))
    return equality_test == []


def maxsets_comparison(listoflistoflistvm_walls, listoflistoflistvm_chambers, listoflistoflistbm_walls,
                       listoflistoflistbm_chambers, listoflistoflistbhm_walls, listoflistoflistbhm_chambers, hyp_no):
    r"""
    Return True or False if listoflistoflistvm_walls and listoflistoflistvm_chambers and listoflistoflistbm_walls and listoflistoflistbm_chambers and listoflistoflistbhm_walls and listoflistoflistbhm_chambers contain the same elements.

    INPUT:

    - ``listoflistoflistvm_walls`` -- list of lists of Monomials; contains lists of lists of Monomials, representing the max families in a wall for the complete intersection

    - ``listoflistoflistvm_chambers`` -- list of lists of Monomials; contains lists of lists of Monomials, representing the max families in a chamber for the complete intersection

    - ``listoflistoflistbm_walls`` -- list of lists of Monomials; contains lists of lists of Monomials, representing the max families in a wall for the complete intersection
    
    - ``listoflistoflistvm_chambers`` -- list of lists of Monomials; contains lists of lists of Monomials, representing the max families in a chamber for the complete intersection

    - ``listoflistoflistbhm_walls`` -- list of lists of Monomials; contains lists of lists of Monomials, representing the max families in a wall for the hyperplane

    - ``listoflistoflistbhm_chambers`` -- list of lists of Monomials; contains lists of lists of Monomials, representing the max families in a chamber for the hyperplane

    - ``hyp_no`` -- int; the number of hypersurfaces


    OUTPUT: True or False

    EXAMPLES:

    This example illustrates an equality ::

        sage: max_vm_wall = [[(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)], [(0, 0, 2)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0)], [(0, 0, 2), (0, 1, 1), (0, 2, 0)]]
        sage: max_vm_chamber =  [[(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)], [(0, 0, 2)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)], [(0, 0, 2), (0, 1, 1), (0, 2, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0)]]
        sage: max_bm_wall = [[(0, 0, 2)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)], [(0, 0, 2), (0, 1, 1), (0, 2, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0)]]
        sage: max_bm_chamber = [[(0, 0, 2)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0)], [(0, 0, 2), (0, 1, 1), (0, 2, 0)]]
        sage: max_bhm_wall = [[(1, 0 , 0), (0, 1, 0)], [(0, 1, 0)], [(1, 0 , 0), (0, 0, 1)], [(1, 0, 0)], [(0, 1, 0), (0, 1, 0)]]
        sage: max_bhm_chamber = [[(1, 0 , 0), (0, 1, 0)], [(0, 1, 0)], [(1, 0 , 0), (0, 0, 1)], [(0, 1, 0), (0, 1, 0)], [(1, 0, 0)]]
        sage: hyp_numb = 2
        sage: maxsets_comparison(max_vm_wall, max_vm_chamber, max_bm_wall, max_bm_chamber, max_bhm_wall, max_bhm_chamber, hyp_numb)
        True

    This example illustrates a falsehood ::

        sage: max_vm_wall = [[(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)], [(0, 0, 2)], [(0, 0, 2), (0, 1, 1), (0, 2, 0)], [(0, 0, 2), (1, 0, 1), (0, 2, 0), (1, 1, 0)], [(0, 0, 2), (0, 1, 1), (0, 2, 0)]]
        sage: max_vm_chamber =  [[(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)], [(0, 0, 2)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)], [(0, 0, 2), (0, 1, 1), (0, 2, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0)]]
        sage: max_bm_wall = [[(0, 0, 2)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)], [(0, 0, 2), (0, 1, 1), (0, 2, 0)], [(1, 1, 0)]]
        sage: max_bm_chamber = [[(0, 0, 2)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0)], [(0, 0, 2), (0, 1, 1), (0, 2, 0)]]
        sage: max_bhm_wall = [[(1, 0 , 0), (0, 1, 0)], [(0, 1, 0)], [(1, 0 , 0), (0, 0, 1)], [(1, 0, 0)], [(0, 1, 0), (0, 1, 0)]]
        sage: max_bhm_chamber = [[(1, 0 , 0), (0, 1, 0)], [(0, 1, 0)], [(1, 0 , 0), (0, 0, 1)], [(0, 1, 0), (0, 1, 0)], [(1, 0, 0)]]
        sage: hyp_numb = 2
        sage: maxsets_comparison(max_vm_wall, max_vm_chamber, max_bm_wall, max_bm_chamber, max_bhm_wall, max_bhm_chamber, hyp_numb)
        False
    """
    counter = 0
    r = hyp_no - 1 #TODO try to see if it is possible to encorporate for r != 1
    for i in range(len(listoflistoflistvm_walls)):
        for j in range(len(listoflistoflistvm_chambers)):  # need to incorporate for different k here first attempt
            if r > 1:
                if equal_listoflists(listoflistoflistvm_walls[i], listoflistoflistvm_chambers[j]) and equal_listoflists(listoflistoflistbhm_walls[i], listoflistoflistbhm_chambers[j]):
                    counter2 = 0
                    for k in range(r):
                        if equal_listoflists(listoflistoflistbm_walls[k][i], listoflistoflistbm_chambers[k][j]):
                            counter2 = counter2 + 1
                    if counter2 == r:
                        counter = counter + 1
            elif r ==1:
                if equal_listoflists(listoflistoflistvm_walls[i], listoflistoflistvm_chambers[j]) and equal_listoflists(listoflistoflistbhm_walls[i], listoflistoflistbhm_chambers[j]) and equal_listoflists(listoflistoflistbm_walls[i], listoflistoflistbm_chambers[j]):
                    counter = counter + 1
            elif r == 0:
                if equal_listoflists(listoflistoflistvm_walls[i], listoflistoflistvm_chambers[j]) and equal_listoflists(listoflistoflistbhm_walls[i], listoflistoflistbhm_chambers[j]):
                    counter = counter + 1
    if len(listoflistoflistvm_walls) >= len(listoflistoflistvm_chambers):
        return counter >= len(listoflistoflistvm_chambers)
    if len(listoflistoflistvm_chambers) > len(listoflistoflistvm_walls):
        return counter >= len(listoflistoflistvm_walls)

    


def mult_list(list1): #maybe add this also to class?
    r"""
    Return the multiple of all elements of list1.

    INPUT:

    - ``list1`` -- list; contains floats or ints


    OUTPUT: float or int 

    EXAMPLES:

    This example illustrates a basic operations ::

        sage: test1 = [1, 2, 3, 4]
        sage: mult_list(test1)
        24

    This also works with symbols ::

        sage: x = var('x', n=4)
        sage: mult_list(x)
        x0*x1*x2*x3

    """
    total = 1
    for i in range(len(list1)):
        total = total * list1[i]
    return total




def max_monomial(monomial_list, gamma):
    r"""
    Return the max monomial of the monomial list with respect to the one-parameter subgroup `gamma`.

    INPUT:

    - ``list1`` -- list of Monomials; contains lists of ints, corresponding to a list of monomials

    - ``gamma`` -- OPS; corresponding to a one-parameter subgroup


    OUTPUT: list which is the max monomial

    EXAMPLES:

    This example illustrates the max monomial of the monomial list test1 ::

        sage: test1 = [[1, 1, 0, 0], [1, 0 , 0 , 1], [2, 0, 0, 0]]; ops  =  [1, 1, -1, -1]
        sage: max_monomial(test1, ops)
        [2, 0, 0, 0]

    This example illustrates the max monomial of the monomial list test1 ::

        sage: test1 = [[1, 1, 0, 0], [1, 0 , 0 , 1]]; ops  =  [1, 1, -1, -1]
        sage: max_monomial(test1, ops)
        [1, 1, 0, 0]

    """
    counter_list = []
    for monomial1 in monomial_list:
        counter = 0
        for monomial2 in monomial_list:
            if monomial2.gamma_bigger_e(monomial1, gamma):
                counter = counter + 1
        counter_list.append(counter)
    for i in range(len(counter_list)):
        if counter_list[i] == len(monomial_list):
            return monomial_list[i]



def alpha_map(listvm, listbm, listbhm, t, gamma, hyp_no, dim):
    r"""
    Returns a np array which is the ouptut of the alpha map.

    INPUT:

    - ``listvm`` -- list of Monomials; contains lists of Monomials, representing the max family for the complete intersection for a specific wall 

    - ``listbm`` -- list of Monomials; contains lists of Monomials, representing the max family for the complete intersection for a specific wall

    - ``listbhm`` -- list of Monomials; contains lists of Monomials, representing the max family for the hyperplane section for a specific wall

    - ``t`` -- float; the wall

    - ``gamma`` -- OPS; a one-parameter subgroup

    - ``hyp_no`` -- int; the number of hypersurfaces in the complete intersection

    - ``dim`` -- int; the dimension of the problem

    OUTPUT: numpy array 

    EXAMPLES:

    This example illustrates a generator in dimension 2 with hyp_no 2 ::

        sage: dimension = 2; degree = 2; no_of_hypersurfaces = 2; t = 1/2; gamma = OPS((1, 1, -2))
        sage: listvm = [(0, 0, 2), (0, 1, 1), (1, 0, 1)]
        sage: listbm = [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)]
        sage: listbhm = [(0, 0, 1)]
        sage: alpha_map(listvm, listbm, listbhm, t, gamma, no_of_hypersurfaces, dimension)
        [[0.  1.  3.5]
         [1.  0.  3.5]
         [0.  2.  2.5]
         [1.  1.  2.5]
         [2.  0.  2.5]
         [0.  1.  3.5]
         [1.  1.  2.5]
         [0.  3.  1.5]
         [1.  2.  1.5]
         [2.  1.  1.5]
         [1.  0.  3.5]
         [1.  1.  2.5]
         [1.  2.  1.5]
         [2.  1.  1.5]
         [3.  0.  1.5]]

    This is a further example ::
        sage: dimension = 2; degree = 2; no_of_hypersurfaces = 2; t = 1/2; gamma = OPS((5, -1, -4))
        sage: listvm = [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)]
        sage: listbm = [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)]
        sage: listbhm = [(0, 0, 1)]
        sage: alpha_map(listvm, listbm, listbhm, t, gamma, no_of_hypersurfaces, dimension) 
         [[0.  1.  3.5]
          [1.  0.  3.5]
          [0.  2.  2.5]
          [0.  1.  3.5]
          [1.  1.  2.5]
          [0.  3.  1.5]
          [1.  0.  3.5]
          [1.  1.  2.5]
          [1.  2.  1.5]
          [0.  2.  2.5]
          [0.  3.  1.5]
          [1.  2.  1.5]]



    ALGORITHM:

    For each monomial `I \in ` listvm, `J \in ` listbm with `I \neq J' and `x_i \in ` listbhm the maximal monomial with respect to the one-parameter subgroup 
    gamma, the alpha map is defined as A(listvm, listbm, listbhm, t) = all possible `I + J + t*x_i`. As such, we find all different possible `I + J` from listvm
    listbm that are different monomials, and we add the maximal monomial `x_i` times the wall t.
    """
    r = hyp_no - 1
    flag = [1000 for i in range(r)]
    summed = []
    if r == 0:
        summed = listvm
    elif r == 1:
        zipped_list = list(itertools.product(listvm, listbm))
        filtered = list(filter(lambda el: el[0] != el[1], zipped_list))
        summed = list(map(lambda el: [el1 + el2 for el1, el2 in zip(el[0], el[1])], filtered))
    else:
        all_list = listbm.copy() #might be an error here
        all_list.append(listvm)
        zipped_list = list(itertools.product(*all_list)) #creates tuples of monomials via product of length equal to hyp_no
        zipped_l = [list(el) for el in zipped_list]
        indices = []
        for m in range(len(zipped_l)):
            cond = 0
            for a in range(hyp_no):
                for b in range(hyp_no):
                    if zipped_l[m][a] == zipped_l[m][b] and a != b:
                        cond = 1
            if cond == 1:
                indices.append(m)
        for i in indices:
            zipped_l[i] = flag
        while flag in zipped_l:
            zipped_l.remove(flag)  #removes tuples where one monomial is repeated
        if not zipped_l:
            return np.array([])
        summed = []
        for elem in zipped_l:  #sums the elements of each tuple with each other
            sum_l = Monomial([0 for i in range(dim+1)])
            for no in range(len(elem)):
                sum_l = Monomial(elem[no]) + Monomial(sum_l)
            summed.append(sum_l)
        sum_zip = [tuple(el) for el in summed] #removes extra elements, turns list into a set
        summed_tuples = list(set(sum_zip))
        summed = [Monomial(el) for el in summed_tuples]
    if listbhm: #takes the maximal monomial from the hyperplane
        bhm = max_monomial(listbhm, gamma)
        newbhm = Monomial([t * elem for elem in bhm])
    else:
        newbhm = []
    vertice = []
    if t != 0 and newbhm != []:  #if t is non zero forms vertices with respect to the above monomial tuples
        for elem1 in summed:
            vertix = newbhm + Monomial(elem1)
            vertice.append(vertix)
        generator = np.array(vertice)
        return generator #returns the generator that will generate the convex hull
    else:
        gen = np.array(summed)
        return gen


def centroid_criterion(listvm, listbm, listbhm, t, gamma, dim, deg, hyp_no):
    r"""
    Returns True or False if the centroid criterion is satisfied.

    INPUT:

    - ``listvm`` -- list of Monomials; contains lists of Monomials, representing the max family for the complete intersection for a specific wall 

    - ``listbm`` -- list of Monomials; contains lists of Monomials, representing the max family for the complete intersection for a specific wall

    - ``listbhm`` -- list of Monomials; contains lists of Monomials, representing the max family for the hyperplane section for a specific wall

    - ``t`` -- float; the wall

    - ``gamma`` -- OPS; a one-parameter subgroup

    - ``dim`` -- int; the dimension of the problem

    - ``deg`` -- int; the degree of the polynomials in the complete intersection

    - ``hyp_no`` -- int; the number of hypersurfaces in the complete intersection

    OUTPUT: True or False 

    EXAMPLES:

    This example illustrates a False centroid ::

        sage: dimension = 2; degree = 2; no_of_hypersurfaces = 2; t = 1/2; gamma = OPS((1, 1, -2))
        sage: listvm = [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)]
        sage: listbm = [(0, 0, 2), (0, 1, 1), (1, 0, 1)]
        sage: listbhm = [(0, 0, 1)]
        sage: centroid_criterion(listvm, listbm, listbhm, t, gamma, dimension, degree, no_of_hypersurfaces)
        False

    ALGORITHM:

    Checks if the convex hull generated by the alpha map above contains the point `(\frac{hyp_no*deg +t}{dim}, \dots, \frac{hyp_no*deg +t}{dim})`.
    
    """
    empty = np.array([])
    generator = alpha_map(listvm, listbm, listbhm, t, gamma, hyp_no, dim)
    if len(generator) < dim + 2:
        return False
    # print(alpha_map(listvm, listbm, listbhm, t, gamma, hyp_no, dim))
    else:
        p1 = generator
        p1c = ConvexHull(p1, qhull_options='QJ')
        cent_den = deg * hyp_no + t
        cent_nom = dim + 1
        cent = cent_den / cent_nom
        centroid = [cent for elem in range(dim + 1)]
        p2 = np.append(p1, [centroid], axis=0)
        p2c = ConvexHull(p2, qhull_options='QJ')
        vertices1 = tuple(tuple(el) for el in p1[p1c.vertices].tolist())
        vertices2 = tuple(tuple(el) for el in p2[p2c.vertices].tolist())
        vert1 = set(vertices1)
        vert2 = set(vertices2)
        return vert1 == vert2







def hilbert_mumford(moni, monxj, gamma, monomial_list1, monomial_list2, dim, hyp_no, t): #moni comes from mon_combs, monxj is supp mon from monomials of hyperplane
    r"""
    Checks the Hilbert-Mumford numerical criterion and generates the maximal destabilizing families depending on support monomials moni and monxj

    INPUT:

    - ``moni`` -- single or list of Monomials; contains lists of Monomials, representing the support monomials of the hypersurface - is a list if hyp_no > 2 

    - ``monxj`` -- Monomial; Monomial representing the support monomials of the hyperplane 

    - ``gamma`` -- OPS; a one-parameter subgroup

    - ``monomial_list1`` -- list of Monomials; contains lists of Monomials, representing the monomials of the hypersurface 

    - ``monomial_list2`` -- list of Monomials; contains lists of Monomials, representing the monomials of the hyperplane 

    - ``dim`` -- int; the dimension of the problem

    - ``hyp_no`` -- int; the number of hypersurfaces in the complete intersection

    - ``t`` -- float; the wall

    OUTPUT: a list of three elements  

    EXAMPLES:

    This example illustrates the construction of the maximal families given certain support monomials ::

        sage: dimension = 2; degree = 2; no_of_hypersurfaces = 2; t = 1/2; gamma = OPS((1, 1, -2))
        sage: supp_mon_hypersurface = Monomial((1, 0, 1))
        sage: supp_mon_hyperplane = Monomial((0, 0, 1))
        sage: monomial_hypersurface = Monomial.monomials(dimension, degree); monomial_hyperplane = Monomial.monomials(dimension, 1)
        sage: hilbert_mumford(supp_mon_hypersurface, supp_mon_hyperplane, gamma, monomial_hypersurface, monomial_hyperplane, dimension, no_of_hypersurfaces, t)
        [[(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1)], [(0, 0, 1)]]
        

    ALGORITHM:

    For all monomials I in monomial_list_2 it checks whether `\langle I + moni + t*monxj, gamma\rangle \leq 0` and if it does it adds I to the list vm. Then we add 
    all monomials in monomial_list_1 which are less than moni with respect to the monomial order and adds them to bm. Similarily it checks all monomials  in 
    monomial_list2 which are less than monxj with respect to the monomial order and adds them to bhm.
    
    """
    # monomial_list1 = Monomial.monomials(self.dim, self.deg)
    # monomial_list2 = Monomial.monomials(self.dim, 1)
    flag = [1000]
    d = dim + 1
    r = hyp_no-1
    bhm = []
    vm = []
    bm = []
    if r > 1:
        bm = [[] for i in range(r)]
    if r > 0:
        for mon in monomial_list1:
            summed = moni
            if r > 1:
                summed = Monomial([0 for i in range(d)]) 
                for elem in moni:
                    summed = elem + summed 
            if Monomial(mon).dot_product(OPS(gamma)) + Monomial(summed).dot_product(OPS(gamma)) + t * Monomial(monxj).dot_product(OPS(gamma)) <= 0:
                #checks the H-M criterion
                vm.append(mon)
                #generates the vm
            if r > 1:  #generates the bm if self.hyp_no>2
                for i in range(r):
                    if mon.gamma_bigger_e(moni[i], gamma):
                        bm[i].append(mon)
            else:  #generates the bm if self.hyp_no == 2
                if mon.gamma_bigger_e(moni, gamma):
                    bm.append(mon)
        if t != 0:  #generates the bm for the hyperplane if t !=0
            for monxi in monomial_list2:
                if Monomial(monxi).gamma_bigger_e(Monomial(monxj), gamma):
                    bhm.append(monxi)
        else:
            bhm = []
        if r > 1:
            for m in range(r):
                if not bm[m]:
                    pass

        else:
            if not bm: #guarantees no empty things are added
                pass
    else:
        for mon in monomial_list1:
            if mon.dot_product(OPS(gamma)) + t * monxj.dot_product(OPS(gamma)) <= 0:
                #checks the H-M criterion
                vm.append(mon)
                #generates the vm
        if t != 0:  #generates the bm for the hyperplane if t !=0
            for monxi in monomial_list2:
                if monxi.gamma_bigger_e(monxj, gamma):
                    bhm.append(monxi)
        else:
            bhm = []
    if not vm: #guarantees no empty things are added
        pass
    else:
        return [vm, bm, bhm]


def inclusion_condition(gamma, t, vm, bm, bhm, moni, monxj, hyp_no, maximal_dest_vmt, maximal_dest_bmt, maximal_dest_bhmt, support_monomialst, support_monomialsht, gammat): 
    r"""
    Checks the whether vm is in maximal_dest_vmt, bm is in maximal_dest_bmt, and bhm is in maximal_dest_bhmt and if not all three belong to the repsective lists they are added and the maximal lists are returned.

    INPUT:

    - ``gamma`` -- OPS; a one-parameter subgroup

    - ``t`` -- float; the wall

    - ``vm`` -- list of Monomials; contains different monomials, corresponding to a maximal family of the hypersurface

    - ``bm`` -- list of Monomials; contains different monomials, corresponding to a maximal family of the hypersurface

    - ``bhm`` -- list of Monomials; contains different monomials, corresponding to a maximal family of the hyperplane

    - ``moni`` -- single or list of Monomials; contains lists of Monomials, representing the support monomials of the hypersurface - is a list if hyp_no > 2 

    - ``monxj`` -- Monomial; Monomial representing the support monomials of the hyperplane 

    - ``hyp_no`` -- int; the number of hypersurfaces in the complete intersection

    - ``maximal_dest_vmt`` -- list of lists Monomials; contains all lists of Monomials, corresponding to all families of the hypersurface

    - ``maximal_dest_bmt`` -- list of lists Monomials; contains all lists of Monomials, corresponding to all families of the hypersurface

    - ``maximal_dest_bhmt`` -- list of lists Monomials; contains all lists of Monomials, corresponding to all families of the hyperplane

    - ``support_monomialst`` -- list of Monomials; contains lists of Monomials, corresponding to all support monomials of the hypersurface

    - ``support_monomialsht`` -- list of Monomials; contains lists of Monomials, corresponding to all support monomials of the hyperplane

    - ``gammat`` -- list of OPS; contains OPS, corresponding to all destabilizing OPS for each family
        

    OUTPUT: a list of six elements containing the families 

    EXAMPLES:

    This example illustrates some destabilizing families which don't belong in the maximal families, and are added ::


    sage: dimension = 2; degree = 2; no_of_hypersurfaces = 2; t = 1/2; gamma = OPS((5, -1, -4))
    sage: supp_mon_hypersurface = Monomial((1, 0, 1))
    sage: supp_mon_hyperplane = Monomial((0, 0, 1))
    sage: max_vmt = [[(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)]]
    sage: max_bmt = [[(0, 0, 2), (0, 1, 1), (1, 0, 1)]]
    sage: max_bhmt = [[(0, 0, 1)]]
    sage: vm = [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)]
    sage: bm = [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)]
    sage: bhm = [(0, 0, 1)]
    sage: support_monomials_t = [Monomial((1, 0, 1))]
    sage: support_monomialsh_t = [Monomial((0, 0, 1))]
    sage: gammat = [OPS((1, 1, -2))]
    sage: inclusion_condition(gamma, t, vm, bm, bhm, supp_mon_hypersurface, supp_mon_hyperplane, no_of_hypersurfaces, max_vmt, max_bmt, max_bhmt, support_monomialst, support_monomialsht, gammat)
    [[[(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)],[(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)]], [[(0, 0, 2), (0, 1, 1), (1, 0, 1)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)]], [[(0, 0, 1)], [(0, 0, 1)]], [(1, 0, 1), (1, 0, 1)], [(1, 1, -2), (5, -1, -4)]]

    This example illustrates some destabilizing families which do belong in the maximal families, and are not added ::

    sage: dimension = 2; degree = 2; no_of_hypersurfaces = 2; t = 1/2; gamma = OPS((5, -1, -4))
    sage: supp_mon_hypersurface = Monomial((1, 0, 1))
    sage: supp_mon_hyperplane = Monomial((0, 0, 1))
    sage: max_vmt = [[(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)]]
    sage: max_bmt = [[(0, 0, 2), (0, 1, 1), (1, 0, 1)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)]]
    sage: max_bhmt = [[(0, 0, 1)], [(0, 0, 1)]]
    sage: vm = [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)]
    sage: bm = [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)]
    sage: bhm = [(0, 0, 1)]
    sage: support_monomials_t = [Monomial((1, 0, 1))]
    sage: support_monomialsh_t = [Monomial((0, 0, 1))]
    sage: gammat = [OPS((1, 1, -2))]
    sage: inclusion_condition(gamma, t, vm, bm, bhm, supp_mon_hypersurface, supp_mon_hyperplane, no_of_hypersurfaces, max_vmt, max_bmt, max_bhmt, support_monomialst, support_monomialsht, gammat)
    [[[(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0), (1, 1, 0), (2, 0, 0)],[(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)]], [[(0, 0, 2), (0, 1, 1), (1, 0, 1)], [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)]], [[(0, 0, 1)], [(0, 0, 1)]], [(1, 0, 1), (1, 0, 1)], [(1, 1, -2), (5, -1, -4)]]
        
    
    """
    r = hyp_no-1
    if len(maximal_dest_vmt) == 0:
        # if vm not in maximal_dest_vmt and bm[i] not in maximal_dest_bmt[i] and bhm not in maximal_dest_bhmt:
        maximal_dest_vmt.append(vm)
        if r > 1: 
            for i in range(r):
                maximal_dest_bmt[i].append(bm[i])
        else:
            maximal_dest_bmt.append(bm)
        maximal_dest_bhmt.append(bhm)
        if r > 1:
            for i in range(r):
                support_monomialst[i].append(moni[i])
        else:
            support_monomialst.append(moni)
        support_monomialsht.append(monxj)
        gammat.append(gamma)
        return [maximal_dest_vmt, maximal_dest_bmt, maximal_dest_bhmt, support_monomialst, support_monomialsht, gammat]
    else:  #this tests whether the (vm,bm,bhm) has been added before and if it has it passes it
        test_indices1 = []
        test_indices2 = []
        if r > 1:
            test_indices2 = [[] for i in range(r)]
        test_indices3 = [] #include statement with break here for the case r == 0
        if r == 0:
            for i in range(len(maximal_dest_vmt)):
                test1 = all(elem in maximal_dest_vmt[i] for elem in vm)  #tests if all vm is in maximal_dest_vmt
                if test1:
                    test_indices1.append(i)
            if test_indices1:
                if t != 0:
                    for no in test_indices1:
                        test2 = all(elem in maximal_dest_bhmt[no] for elem in bhm)
                        if test2:
                            test_indices3.append(test2)
                else:
                    return [maximal_dest_vmt, maximal_dest_bmt, maximal_dest_bhmt, support_monomialst, support_monomialsht, gammat]
            else:
                maximal_dest_vmt.append(vm)
                maximal_dest_bmt.append([])
                maximal_dest_bhmt.append(bhm)
                support_monomialst.append([])
                support_monomialsht.append(monxj)
                gammat.append(gamma)
                return [maximal_dest_vmt, maximal_dest_bmt, maximal_dest_bhmt, support_monomialst, support_monomialsht, gammat]
            if test_indices3:
                return [maximal_dest_vmt, maximal_dest_bmt, maximal_dest_bhmt, support_monomialst, support_monomialsht, gammat]
            else:
                maximal_dest_vmt.append(vm)
                maximal_dest_bmt.append([])
                maximal_dest_bhmt.append(bhm)
                support_monomialst.append([])
                support_monomialsht.append(monxj)
                gammat.append(gamma)
                return [maximal_dest_vmt, maximal_dest_bmt, maximal_dest_bhmt, support_monomialst, support_monomialsht, gammat]
        intersections = []
        for i in range(len(maximal_dest_vmt)):
            test1 = all(elem in maximal_dest_vmt[i] for elem in vm)  #tests if all vm is in maximal_dest_vmt
            if test1:
                test_indices1.append(i)
        if test_indices1:
            for no in test_indices1:
                if r == 1:
                    testsb = all(elem in maximal_dest_bmt[no] for elem in bm)  #tests if bm is in maximal_dest_bmt
                    if testsb:
                        test_indices2.append(no)
                else:
                    testsb = []
                    for m in range(r):
                        testsb.append(all(elem in maximal_dest_bmt[m][no] for elem in bm[m]))
                        if testsb[m]:
                            test_indices2[m].append(no)
        else:
            maximal_dest_vmt.append(vm)
            if r > 1:
                for i in range(r):
                    maximal_dest_bmt[i].append(bm[i])
            else:
                maximal_dest_bmt.append(bm)
            maximal_dest_bhmt.append(bhm)
            if r > 1:
                for i in range(r):
                    support_monomialst[i].append(moni[i])
            else:
                support_monomialst.append(moni)
            support_monomialsht.append(monxj)
            gammat.append(gamma)
            return [maximal_dest_vmt, maximal_dest_bmt, maximal_dest_bhmt, support_monomialst, support_monomialsht, gammat]
        if r > 1: 
            for i in range(r): #this needs fixing
                if test_indices2[i]:
                    for j in range(r):
                        if j > i and test_indices2[j]:
                            intersections.append(set(test_indices2[i]).intersection(set(test_indices2[j])))
                    #if isinstance(intersections[0], list):
                    #    flat_list = [item for sublist in intersections for item in sublist]
                else:
                    maximal_dest_vmt.append(vm)
                    for m in range(r):
                        maximal_dest_bmt[m].append(bm[m])
                    maximal_dest_bhmt.append(bhm)
                    for k in range(r):
                        support_monomialst[k].append(moni[i])
                    support_monomialsht.append(monxj)
                    gammat.append(gamma)
                    return [maximal_dest_vmt, maximal_dest_bmt, maximal_dest_bhmt, support_monomialst, support_monomialsht, gammat]
            flat_list = [item for sublist in intersections for item in sublist]
            intersections = list(set(flat_list))
            if not intersections:
                maximal_dest_vmt.append(vm)
                for i in range(r):
                    maximal_dest_bmt[i].append(bm[i])
                maximal_dest_bhmt.append(bhm)
                for i in range(r):
                    support_monomialst[i].append(moni[i])
                support_monomialsht.append(monxj)
                gammat.append(gamma)
                return [maximal_dest_vmt, maximal_dest_bmt, maximal_dest_bhmt, support_monomialst, support_monomialsht, gammat]
            else:
                for j in intersections:
                    test3 = all(elem in maximal_dest_bhmt[j] for elem in bhm)
                    if test3:
                        test_indices3.append(j)
            if test_indices3:
                return [maximal_dest_vmt, maximal_dest_bmt, maximal_dest_bhmt, support_monomialst, support_monomialsht, gammat]
            else:
                maximal_dest_vmt.append(vm)
                if r > 1:
                    for i in range(r):
                        maximal_dest_bmt[i].append(bm[i])
                else:
                    maximal_dest_bmt.append(bm)
                maximal_dest_bhmt.append(bhm)
                if r > 1:
                    for i in range(r):
                        support_monomialst[i].append(moni[i])
                else:
                    support_monomialst.append(moni)
                support_monomialsht.append(monxj)
                gammat.append(gamma)
                return [maximal_dest_vmt, maximal_dest_bmt, maximal_dest_bhmt, support_monomialst, support_monomialsht, gammat]
        else:
            if test_indices2:
                for no in test_indices1:
                    testsb = all(elem in maximal_dest_bmt[no] for elem in bm)  #tests if bm is in maximal_dest_bmt
                    if testsb:
                        test_indices3.append(no)
            else:
                maximal_dest_vmt.append(vm)
                maximal_dest_bmt.append(bm)
                maximal_dest_bhmt.append(bhm)
                support_monomialst.append(moni)
                support_monomialsht.append(monxj)
                gammat.append(gamma)
                return [maximal_dest_vmt, maximal_dest_bmt, maximal_dest_bhmt, support_monomialst, support_monomialsht, gammat]
            if test_indices3:
                return [maximal_dest_vmt, maximal_dest_bmt, maximal_dest_bhmt, support_monomialst, support_monomialsht, gammat]
            else:
                maximal_dest_vmt.append(vm)
                maximal_dest_bmt.append(bm)
                maximal_dest_bhmt.append(bhm)
                support_monomialst.append(moni)
                support_monomialsht.append(monxj)
                gammat.append(gamma)
                return [maximal_dest_vmt, maximal_dest_bmt, maximal_dest_bhmt, support_monomialst, support_monomialsht, gammat]
            

def annihilator(vm_list, bhm_list, bm_need, ops, wall, dim, hyp_no): 
    r"""
    Checks the Hilbert-Mumford numerical criterion and generates the maximal destabilizing families depending on support monomials moni and monxj

    INPUT:

    - ``vm_list`` -- list of Monomials; contains different monomials, corresponding to a maximal family of the hypersurface

    - ``bm_list`` -- list of Monomials; contains different monomials, corresponding to a maximal family of the hypersurface

    - ``bhm_list`` -- list of Monomials; contains different monomials, corresponding to a maximal family of the hyperplane

    - ``ops`` -- OPS; a one-parameter subgroup

    - ``wall`` -- float; the wall    

    - ``dim`` -- int; the dimension of the problem

    - ``hyp_no`` -- int; the number of hypersurfaces in the complete intersection


    OUTPUT: a list of three elements  

    EXAMPLES: TODO find appropriate example

    This example illustrates the construction of the maximal families given certain support monomials ::

        sage: dimension = 2; degree = 2; no_of_hypersurfaces = 2; t = 1/2; gamma = OPS((1, 1, -2))
        sage: vm = [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)]
        sage: bm = [(0, 0, 2), (0, 1, 1), (1, 0, 1), (0, 2, 0)]
        sage: bhm = [(0, 0, 1)]
        sage: annihilator(vm, bhm, bm, gamma, t, dimension, no_of_hypersurfaces)
        [[(0, 1, 1), (0, 2, 0), (1, 0, 1)], [(0, 2, 0)], [(0, 0, 1)]]
    

    ALGORITHM:

    For all monomials I in vm_list we check checks whether there exist monomials moni in bm_list and monxj in bhm_list such that `\langle I + moni + wall*monxj, ops\rangle = 0`
    and if it does it adds I to the list v0. Then we add all monomials in bm_list which have a less or equal inner product with ops than moni with ops adds those to b0. Similarily 
    we add all monomials in bhm_list which have a less or equal inner product with ops than monxj with ops adds those to bh0. If any of these are empty we return nothing.
    
    """
    d = dim + 1
    r = hyp_no - 1
    flag = [10000]
    vm0 = []
    bm0 = []
    if r > 1:
        bm0 = [[] for i in range(r)]
    bhm0 = []
    indices = []
    products = bm_need
    if r > 1:
        zipped_list = list(itertools.product(*bm_need))
        products = [list(el) for el in zipped_list]
        for mu in range(len(products)):
            cond = 0
            for a in range(r):
                for b in range(r):
                    if products[mu][a] == products[mu][b] and a != b:
                        cond = 1
                        pass
            if cond == 1:
                indices.append(mu)
        for numb in indices:
            products[numb] = flag
        while flag in products:
            products.remove(flag)  # implemented summed method
    if wall > 0:
        for monv in vm_list:
            if r > 1:
                for monb in products:
                    summ_l = Monomial([0 for m in range(d)])
                    for el1 in monb:
                        summ_l = Monomial(el1) + summ_l
                    for monbh in bhm_list:
                        if Monomial(monv).dot_product(ops) + Monomial(summ_l).dot_product(ops) + wall * Monomial(monbh).dot_product(ops) == 0:
                            vm0.append(monv)
                            break
            elif r == 1:
                for monb in products:
                    for monbh in bhm_list:
                        if monv.dot_product(ops) + monb.dot_product(ops) + wall* monbh.dot_product(ops) == 0:
                            vm0.append(monv)
                            break                    
            else:
                for monbh in bhm_list:
                    if monv.dot_product(ops) + wall * monbh.dot_product(ops) == 0:
                        vm0.append(monv)
                        break
    else:
        for monv in vm_list:
            if r > 1:
                for monb in products:
                    summ_l = Monomial([0 for el in range(d)])
                    for el1 in monb:
                        summ_l = Monomial(el1) + summ_l 
                    if Monomial(monv).dot_product(OPS(ops)) + Monomial(summ_l).dot_product(OPS(ops)) == 0:
                        vm0.append(monv)
                        break
            elif r == 1:
                for monb in products:
                    if monv.dot_product(ops) + monb.dot_product(ops) == 0:
                        vm0.append(monv)
                        break                    
            else:
                if monv.dot_product(ops) == 0:
                    vm0.append(monv)
                    break
    zipped_set = set(map(tuple, vm0))
    vm0 = list(map(Monomial, zipped_set))
    if len(vm0) == 0:
        pass
    flaglist = []
    if r > 1:
        flaglist = [[] for m in range(r)]
        for k in range(r):
            for el in bm_need[k]:
                flaglist[k].append(el.dot_product(ops))
    elif r == 1:
        for el in bm_need:
            flaglist.append(el.dot_product(ops))
    else:
        flaglist = []
    if r > 1: 
        #Asumming l = [2, 2, 4, 4]
        map_1 = {} #maybe this can turn into a function
        maximum = -10000  # if everything is positive
        for m in range(r):
            if len(flaglist[m]) > 1:
                for d, e in enumerate(flaglist[m]):
                    if e > maximum:
                        maximum = e
                        map_1[e] = [d]
                    elif e == maximum:
                        map_1[maximum].append(d)
                bm0[m] = [bm_need[m][numb] for numb in map_1[maximum]]
            else:
                bm0[m] = bm_need[m]
    else:
        map_1 = {}
        maximum = -10000  # if everything is positive
        if len(flaglist) > 1:
            for d, e in enumerate(flaglist):
                if e > maximum:
                    maximum = e
                    map_1[e] = [d]
                elif e == maximum:
                    map_1[maximum].append(d)
            bm0 = [bm_need[numb] for numb in map_1[maximum]]
        else:
            bm0 = bm_need
    flaglist1 = []
    if wall > 0:
        for monb1 in bhm_list:
            flaglist1.append(monb1.dot_product(ops))
        #Asumming l = [2, 2, 4, 4]
        map_2 = {}
        maximum = -10000  # if everything is positive
        if len(flaglist1) > 1:
            for d, e in enumerate(flaglist1):
                if e > maximum:
                    maximum = e
                    map_2[e] = [d]
                elif e == maximum:
                    map_2[maximum].append(d)
            bhm0 = [bhm_list[numb] for numb in map_2[maximum]]
        else:
            bhm0 = bhm_list
    else:
        bhm0 = []

    return [vm0, bm0, bhm0]


def printer(vm_list, bm_list, bhm_list, wall, dim, hyp_no): 
    r"""
    Converts lists of Monomials to their corresponding equations for a specific wall, dimension and number of hypersurfaces. 

    INPUT:

    - ``vm_list`` -- list of Monomials; contains different monomials

    - ``bm_list`` -- list of Monomials; contains different monomials

    - ``bhm_list`` -- list of Monomials; contains different monomials

    - ``wall`` -- float; a specific wall

    - ``dim`` -- int; the dimension of the problem

    - ``hyp_no`` -- int; the number of hypersurfaces


    OUTPUT: a list of three elements containing the converted equations

    EXAMPLES:

    This example illustrates a simple convertion in dimension 1 and 2 hypersurfaces ::

        sage: vm = [(4, 0), (3, 1), (2, 2), (1, 3), (0, 4)]; bm = [(0, 4)]; bhm = [(1, 0), (0, 1)]
        sage: printer(vm, bm, bhm, wall, hyps_numb)
        [d4*x0^4 + d3*x0^3*x1 + d2*x0^2*x1^2 + d1*x0*x1^3 + d0*x1^4, e0*x1^4, g0*x0 + g1x1 


    """
    d = dim + 1
    tl = var('x', n=d)
    r = hyp_no - 1
    l0 = len(vm_list)
    l1 = 0
    if r > 1:
        l1 = [0 for i in range(r)]
        for m in range(r):
            l1[m] = len(bm_list[m])
    else:
        l1 = len(bm_list)
    l2 = len(bhm_list)
    d = var('d', n=l0)
    e = 0
    if r > 1:
        e = [0 for m in range(r)]
        for m in range(r):
            e[m] = var('e', n=l1[m])
    elif r == 1:
        e = var('e', n=l1)
    g = 0
    if wall > 0:    
        g = var('g', n=l2)
    eq_sum_v0 = 0
    for k in range(len(vm_list)):
        eq_sum_v0 = d[k]*mult_list(Monomial(vm_list[k]).to_the_power(tl)) + eq_sum_v0
    eq_sum_b0 = 0
    if r > 1:
        eq_sum_b0 = [0 for i in range(r)]
        for m in range(r):
            for k in range(len(bm_list[m])):
                eq_sum_b0[m] = e[m][k]*mult_list(Monomial(bm_list[m][k]).to_the_power(tl)) + eq_sum_b0[m]
    else:
        for k in range(len(bm_list)):
            eq_sum_b0 = e[k]*mult_list(Monomial(bm_list[k]).to_the_power(tl)) + eq_sum_b0
    eq_sum_bh0 = 0
    if wall > 0:
        for k in range(len(bhm_list)):
            eq_sum_bh0 = g[k]*mult_list(Monomial(bhm_list[k]).to_the_power(tl)) + eq_sum_bh0
    return [eq_sum_v0, eq_sum_b0, eq_sum_bh0]

