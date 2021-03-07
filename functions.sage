#!/usr/bin/python36

import numpy as np

import itertools

import pickle

from fractions import Fraction

import math

from scipy import linalg

from scipy.spatial import ConvexHull

#TODO add docstrings in sage format

def denom(float_value):
    """

    @param float_value: float parameter
    @return: the denominator of float written as a fraction.
    """
    frac = Fraction(float_value).limit_denominator(1000000000000000)
    den = frac.denominator
    return den


def mult_by_lcm(list1):
    """

    @param list1: list of floats
    @return: list multiplied by least common multiple of denominators of list elements.
    """
    denominator_list = [numb.q for numb in list1 if numb.p != 0]
    lcm = denominator_list[0]
    for d in denominator_list[1:]:
        lcm = lcm * d // math.gcd(lcm, d)
    new_elem = [lcm * frac for frac in list1]
    return new_elem


def element_wise_multiplication(list1, list2):
    """

    @param list1: a list
    @param list2: a list
    @return: list with elements the multiples of list1 by elements of list2
    """
    return [list1[i] * list2[i] for i in range(len(list1))]


def dot_product(list1, list2):
    """

    @param list1: a list
    @param list2: a list
    @return: the inner product of the two lists
    """
    return sum(element_wise_multiplication(list1, list2))


def ordertest(seq):
    """

    @param seq: a list which is a sequence of numbers
    @return: True or False depending on whether the list is ordered
    """
    return all(earlier >= later for earlier, later in zip(seq, seq[1:]))


def gamma_bigger_e(array1, array2, gamma):
    """

    @param array1: a list corresponding to a monomial
    @param array2: a list corresponding to a monomial
    @param gamma: a list corresponding to a one-parameter subgroup
    @return: True if array2 is greater or equal than array1 with respect to the gamma-order, False otherwise
    """
    prod1 = dot_product(array1, gamma)
    prod2 = dot_product(array2, gamma)
    if prod1 != prod2:
        return prod1 < prod2
    else:
        return array1 <= array2


def equal_listoflists(listof1, listof2):
    """

    @param listof1: a list of lists corresponding to a list of monomials
    @param listof2: a list of lists corresponding to a list of monomials
    @return: True if listof1 == listof2, False otherwise
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


def to_the_power(array1, array2):
    """

    @param array1: an array
    @param array2: an array
    @return: a list with elements the elements of array1 raised to the power of an element of array2
    """
    return [a ** b for a, b in zip(array1, array2)]


def mult_list(list1):
    """

    @param list1: a list
    @return: the multiplication of all the elements of list1
    """
    total = 1
    for i in range(len(list1)):
        total = total * list1[i]
    return total


def sum_of_tuples(tuple1, tuple2):
    """

    @param tuple1: a tuple
    @param tuple2: a tuple
    @return: a list tuple1+tuple2
    """
    return [a+b for a, b in zip(tuple1, tuple2)]


def max_monomial(monomial_list, gamma):
    """

    @param monomial_list: a list of lists corresponding to a list of monomials
    @param gamma: a list corresponding to a one-parameter subgroup
    @return: the maximal monomial of monomial_list with respect to the gamma-order
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
    """

    :param dimension: int, the dimension of the embeded projective space
    :param degree: int, the degree of the hypersurfaces
    :return: a list of lists containing the homogeneous monomials of degree d in dimension n.
    """
    return list(WeightedIntegerVectors(degree, [1 for i in range(dimension + 1)]))
