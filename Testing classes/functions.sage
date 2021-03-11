#!/usr/bin/python36

import numpy as np

import itertools

import pickle

from fractions import Fraction

import math

from scipy import linalg

from scipy.spatial import ConvexHull

#TODO add docstrings in sage format

def mult_by_lcm(list1):
    r"""
    Return the list multiplied by least common multiple of denominators of its list elements.

    INPUT:

    - ``list1`` -- list; this should be a list of fractions or ints

    OUTPUT: the list multiplied by the lcm

    EXAMPLES:

    This example illustrates the basic function of mult_by_lcm ::

        sage: testl = [1/3, 3/5, 2/3, 4/3]
        sage: mult_by_lcm(testl)
        [5, 9, 10, 20]

    We now test for a case where all denominators are different ::

        sage: testl = [1/2, 1/3, 1/4, 1/5]
        sage: mult_by_lcm(testl)
        [30, 20, 15, 12]

    It is an error to use a list with floats in it ::

        sage: testl = [1.3, 3.5, 2.7]
        Traceback (most recent call last):
        ...
        AttributeError: 'sage.rings.real_mpfr.RealLiteral' object has no attribute 'denominator'


    TESTS::

        sage: testl = [1, 2, 3, 4, 5]  # Check for case where all elements are ints
        sage: mult_by_lcm(testl)
        [1, 2, 3, 4, 5]
    """
    
    denominator_list = [list1[i].denominator() for i in range(len(list1))]
    lcm = denominator_list[0]
    for d in denominator_list[1:]:
        lcm = lcm / gcd(lcm, d) * d
    new_elem = [x * lcm for x in list1]
    return new_elem


def element_wise_multiplication(list1, list2):
    r"""
    Return the list with elements the multiples of list1 by elements of list2.

    INPUT:

    - ``list1`` -- list; contains floats or ints

    - ``list2`` -- list; contains floats or ints

    OUTPUT: the product of the lists as a list

    EXAMPLES:

    This example illustrates a basic list multiplication ::

        sage: test1 = [1, 2, 3, 4]; test2 = [5, 6, 7, 8]
        sage: element_wise_multiplication(test1, test2)
        [5, 12, 21, 32]

    """
    return [list1[i] * list2[i] for i in range(len(list1))]


def dot_product(list1, list2):
    r"""
    Return the dot product of list1 and list2`.

    INPUT:

    - ``list1`` -- list; contains floats or ints

    - ``list2`` -- list; contains floats or ints

    OUTPUT: the dot product as a fraction or int

    EXAMPLES:

    This example illustrates a basic dot product ::

        sage: test1 = [1, 2, 3, 4]; test2 = [5, 6, 7, 8]
        sage: dot_product(test1, test2)
        70

    We now compute a dot product that is a fraction ::

        sage: test1 = [1, 2, 3, 4]; test2 = [1.3, 3.5, 2.7]
        sage: dot_product(test1, test2)
        163/60

    """
    return sum(element_wise_multiplication(list1, list2))


def ordertest(seq):
    r"""
    Return True or False if seq is ordered in a descending order`.

    INPUT:

    - ``seq`` -- list; contains floats or ints

    OUTPUT: True or False

    EXAMPLES:

    This example illustrates a non ordered list ::

        sage: test1 = [1, 2, 3, 4]
        sage: ordertest(test1)
        False

    This example illustrates an ordered list ::

        sage: test1 = [10, 9, 8, 7, 6, 5, 2]
        sage: ordertest(test1)
        True

    """
    
    return all(earlier >= later for earlier, later in zip(seq, seq[1:]))


def gamma_bigger_e(list1, list2, gamma):
    r"""
    Return True or False if list2 is bigger in the monomial order than list1`.

    INPUT:

    - ``list1`` -- list; contains ints, corresponding to a monomial

    - ``list2`` -- list; contains ints, corresponding to a monomial
    
    - ``gamma`` -- list; contains ints, corresponding to a one-parameter subgroup.


    OUTPUT: True or False

    EXAMPLES:

    This example illustrates a monomial which is bigger or equal with respect to the order for specific one-parameter subgroup [1, 1, -1, -1] ::

        sage: ops = [1, 1, -1, -1]; mon1 = [2, 0, 0, 0]; mon2 = [0, 2, 0, 0]
        sage: gamma_bigger_e(mon2, mon1, ops)
        True

    This example illustrates a monomial which is not bigger or equal with respect to the order for specific one-parameter subgroup [1, 1, -1, -1] ::

        sage: ops = [1, 1, -1, -1]; mon1 = [2, 0, 0, 0]; mon2 = [0, 1, 0, 1]
        sage: gamma_bigger_e(mon1, mon2, ops)
        False

    Any monomial is bigger or equal than itself ::

        sage: ops = [1, 1, -1, -1]; mon1 = [2, 0, 0, 0]
        sage: gamma_bigger_e(mon1, mon1, ops)
        True

    """
    
    prod1 = dot_product(list1, gamma)
    prod2 = dot_product(list2, gamma)
    if prod1 != prod2:
        return prod1 < prod2
    else:
        return list1 <= list2


def equal_listoflists(listof1, listof2):
    r"""
    Return True or False if listof1 has the same elements as listof1`.

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
    """

    @param listoflistoflistvm_walls: a list of list of lists corresponding to the destabilizing families of vm at the walls
    @param listoflistoflistvm_chambers: a list of list of lists corresponding to the destabilizing families of vm at the chambers
    @param listoflistoflistbm_walls: a list of list of lists corresponding to the destabilizing families of vm at the walls
    @param listoflistoflistbm_chambers: a list of list of lists corresponding to the destabilizing families of bm at the chambers
    @param listoflistoflistbhm_walls: a list of list of lists corresponding to the destabilizing families of bhm at the walls
    @param listoflistoflistbhm_chambers: a list of list of lists corresponding to the destabilizing families of bhm at the chambers
    @param hyp_no: int, the number of hypersurfaces in the complete intersection
    @return: True if all chambers are contained in the walls, false if otherwise
    """
    counter = 0
    r = hyp_no - 1 #TODO try to see if it is possible to encorporate for r != 1
    for i in range(len(listoflistoflistvm_walls)):
        for j in range(len(listoflistoflistvm_chambers)):  # need to incorporate for different k here first attempt
            #if r != 1:
             #   for k in range(r):
             #   if equal_listoflists(listoflistoflistvm_walls[i], listoflistoflistvm_chambers[j]) and equal_listoflists(listoflistoflistbhm_walls[i], listoflistoflistbhm_chambers[j]) and equal_listoflists(listoflistoflistbm_walls[k][i], listoflistoflistbm_chambers[k][j]):
#                    counter2 = 0
#                    for k in range(r):
#                        if equal_listoflists(listoflistoflistbm_walls[k][i], listoflistoflistbm_chambers[k][j]):
#                            counter2 = counter2 + 1
#                    if counter2 == r:
#                        counter = counter + 1
           # else:
            if equal_listoflists(listoflistoflistvm_walls[i], listoflistoflistvm_chambers[j]) and equal_listoflists(listoflistoflistbhm_walls[i], listoflistoflistbhm_chambers[j]) and equal_listoflists(listoflistoflistbm_walls[i], listoflistoflistbm_chambers[j]):
                counter = counter + 1
    if len(listoflistoflistvm_walls) >= len(listoflistoflistvm_chambers):
        return counter >= len(listoflistoflistvm_chambers)
    if len(listoflistoflistvm_chambers) > len(listoflistoflistvm_walls):
        return counter >= len(listoflistoflistvm_walls)

    # The following define some methods on lists in order to display the $N^-$ as functions


def to_the_power(list1, list2):
    r"""
    Return the powers of elements of list1 with respect to the elements of list2`.

    INPUT:

    - ``list1`` -- list; contains floats or ints

    - ``list2`` -- list; contains floats or ints

    OUTPUT: the list of raised powers

    EXAMPLES:

    This example illustrates a basic operations ::

        sage: test1 = [1, 2, 3, 4]; test2 = [5, 6, 7, 8]
        sage: to_the_power(test1, test2)
        [1, 64, 2187, 65536]

    This also works with symbols ::

        sage: test1 = [1, 2, 3, 4]; x = var('x', n=4)
        sage: dot_product(x, test1)
        [x0, x1^2, x2^3, x3^4]

    """
    return [a ** b for a, b in zip(list1, list2)]


def mult_list(list1):
    r"""
    Return the multiple of all elements of list1`.

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


def sum_of_tuples(tuple1, tuple2):
    r"""
    Return the sum of tuple1 and tuple1`.

    INPUT:

    - ``list1`` -- tuple or list; contains floats or ints

    - ``list1`` -- tuple or list; contains floats or ints



    OUTPUT: list of the sum 

    EXAMPLES:

    This example illustrates a basic sum of tuples ::

        sage: test1 = (1,2,3,4); test2 = (5,6,7,8)
        sage: sum_of_tuples(test1, test2)
        [6, 8, 10, 12]

    """
    return [a+b for a, b in zip(tuple1, tuple2)]


def max_monomial(monomial_list, gamma):
    r"""
    Return the max monomial of the monomial list with respect to the one-parameter subgroup gamma`.

    INPUT:

    - ``list1`` -- list of lists; contains lists of ints, corresponding to a list of monomials

    - ``gamma`` -- list; corresponding to a one-parameter subgroup


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
            if gamma_bigger_e(monomial2, monomial1, gamma):
                counter = counter + 1
        counter_list.append(counter)
    for i in range(len(counter_list)):
        if counter_list[i] == len(monomial_list):
            return monomial_list[i]


# This defines the centroid criterion

def alpha_map(listvm, listbm, listbhm, t, gamma, hyp_no, dim):
    """

    @param listvm: a list of lists corresponding to the destabilizing families of vm, where each sublist corresponds to a monomial
    @param listbm: a list of lists corresponding to the destabilizing families of bm, where each sublist corresponds to a monomial
    @param listbhm: a list of lists corresponding to the destabilizing families of bhm, where each sublist corresponds to a monomial
    @param t: a float, corresponding to a wall/chamber
    @param gamma: a list corresponding to a one-parameter subgroup
    @param hyp_no: number of hypersurfaces in the complete intersection
    @return: the np.arrray gen which is the alpha map of the above parameters
    """
    r = hyp_no - 1
    flag = [1000 for i in range(r)]
    summed = []
    if r == 1:
        zipped_list = list(itertools.product(listvm, listbm))
        filtered = list(filter(lambda el: el[0] != el[1], zipped_list))
        summed = list(map(lambda el: [el1 + el2 for el1, el2 in zip(el[0], el[1])], filtered))
    else:
        all_list = listbm.copy()
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
        summed = []
        for elem in zipped_l:  #sums the elements of each tuple with each other
            sum_l = [0 for i in range(dim+1)]
            for no in range(len(elem)):
                sum_l = [el1 + el2 for el1, el2 in  zip(sum_l, elem[no])]
            summed.append(sum_l)
    if listbhm: #takes the maximal monomial from the hyperplane
        bhm = max_monomial(listbhm, gamma)
        newbhm = [t * elem for elem in bhm]
    else:
        newbhm = []
    vertice = []
    if t != 0 and newbhm != []:  #if t is non zero forms vertices with respect to the above monomial tuples
        for elem1 in summed:
            vertix = [el1 + el2 for (el1, el2) in zip(elem1, newbhm)]
            vertice.append(vertix)
        generator = np.array(vertice)
        return generator #returns the generator that will generate the convex hull
    else:
        gen = np.array(summed)
        return gen


def centroid_criterion(listvm, listbm, listbhm, t, gamma, dim, deg, hyp_no):
    """

        @param listvm: a list of lists corresponding to the destabilizing families of vm, where each sublist corresponds to a monomial
        @param listbm: a list of lists corresponding to the destabilizing families of bm, where each sublist corresponds to a monomial
        @param listbhm: a list of lists corresponding to the destabilizing families of bhm, where each sublist corresponds to a monomial
        @param t: a float, corresponding to a wall/chamber
        @param gamma: a list corresponding to a one-parameter subgroup
        @param dim: an int, the dimension of the embedded projective space
        @param deg: an int, the degree of the hypersurfaces
        @param hyp_no: number of hypersurfaces in the complete intersection
        @return: True if centroid criterion holds, False otherwise
        """
    p1 = alpha_map(listvm, listbm, listbhm, t, gamma, hyp_no, dim)
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


# This defines a not equal method for tuples.

def equal(tuple1, tuple2):
    """

    @param tuple1: a tuple
    @param tuple2: a tuple
    @return: True if the tuples are the same, False otherwise
    """
    for i in range(len(tuple1)):
        if tuple1[i] != tuple2[i]:
            return False
    return True


# This is a function to implement the order where it checks if array2 is bigger than array1 with respect to the $\lambda$-order. (Here I use gamma because lambda is a different thing in python.)


# This defines a method to calculate the GIT walls

def t_walls(monomial_list1, monomial_list2, no_of_hypersurfaces, oneps, dimension, degree):
    """

    @param monomial_list1: list of lists of monomials, corresponding to the monomials of the hypersurfaces
    @param monomial_list2: list of lists of monomials, corresponding to the monomials of the hyperplane
    @param no_of_hypersurfaces: the number of hypersurfaces
    @param oneps: a list corresponding to a one-parameter subgroup
    @param dimension: int, the dimension of the embedded projective space
    @param degree: int, the degree of the hypersurfaces
    @return: list of floats, sorted with ascending order corresponding to the walls with respect to the oneps
    """
    walls = []
    r = no_of_hypersurfaces
    monomial_combinations = itertools.combinations(monomial_list1, int(r))
    for monc in monomial_combinations:
        total_t = [0 for i in range(dimension + 1)]
        for j in range(0, len(monc)):
            total_t = [a + b for a, b in zip(total_t, monc[j])]
        for mon in monomial_list2:
            tnum = dot_product(total_t, oneps)
            tden = dot_product(mon, oneps)
            if tden != 0:
                t = -tnum / tden
                if 0 <= t <= r * degree / dimension:
                    walls.append(t)
    walls = list(dict.fromkeys(walls))
    walls.sort()
    return walls


def all_walls(onepset_list, monomial_list1, monomial_list2, no_of_hypersurfaces, dim, deg):
    """

    @param onepset_list: a list of lists corresponding to a list one-parameter subgroup
    @param monomial_list1: list of lists of monomials, corresponding to the monomials of the hypersurfaces
    @param monomial_list2: corresponding to the monomials of the hyperplane
    @param no_of_hypersurfaces: the number of hypersurfaces
    @param dim: the dimension of the embeded projective space
    @param deg: the degree of the hypersurfaces
    @return: list of floats, sorted with ascending order corresponding to all the walls
    """
    final_walls = []
    for oneps in onepset_list:
        specific_walls = t_walls(monomial_list1, monomial_list2, no_of_hypersurfaces,
                                 oneps, dim, deg)
        final_walls.append(specific_walls)
    final_walls = sum(final_walls, [])
    final_walls = list(dict.fromkeys(final_walls))
    final_walls.sort()
    return final_walls

    # This defines a method to calculate the GIT chambers


def t_chambers(t_wall_list):
    """

    @param t_wall_list: a list of floats, corresponding to all the walls
    @return: a list of floats, corresponding to all the chambers
    """
    chambers = []
    for i in range(len(t_wall_list) - 1):
        tden = t_wall_list[i] + t_wall_list[i + 1]
        tchamb = tden / 2
        chambers.append(tchamb)
    chambers.sort()
    return chambers

def monomials(dimension, degree):
    r"""
    Return the homogeneous monomials of degree d in dimension n`.

    INPUT:

    - ``dimension`` -- int; the dimension of the embeded projective space

    - ``degree`` -- int; the degree of the hypersurfaces


    OUTPUT: a list of lists containing the homogeneous monomials of degree d in dimension n.

    EXAMPLES:

    This example illustrates the construction of monomials of dimension 2 and degree 3 ::

        sage: monomials(2,3)
        [[0, 0, 3],
        [0, 1, 2],
        [1, 0, 2],
        [0, 2, 1],
        [1, 1, 1],
        [2, 0, 1],
        [0, 3, 0],
        [1, 2, 0],
        [2, 1, 0],
        [3, 0, 0]]

    It is wrong to not input integer values dimension and degree ::

        sage: monomials(3,2.5)
        Traceback (most recent call last):
        ...
        TypeError: unsupported operand parent(s) for //: 'Real Field with 53 bits of precision' and 'Real Field with 53 bits of precision'

    """
    return list(WeightedIntegerVectors(degree, [1 for i in range(dimension + 1)]))