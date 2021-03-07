#!/usr/bin/python36
from functions import *
from OPS_set import *
from Walls import *

#monomial_hypersurface = [[2, 0, 0, 0], [1, 1, 0, 0], [1, 0, 1, 0], [1, 0, 0, 1], [0, 2, 0, 0], [0, 1, 1, 0], [0, 1, 0, 1], [0, 0, 2, 0], [0, 0, 1, 1], [0, 0, 0, 2]]
#monomial_hyperplane = [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]]



def max_semi_dest_sets(onepslist, dim, deg, hyp_no):
    """

    @param onepslist:a list of list of floats, corresponding to a list of one-parameter subgroups
    @param dim: int, the dimension of the embedded projective space
    @param deg: an int, the degree of the hypersurfaces
    @param hyp_no: int, the number of hypersurfaces
    @return: Generates all walls/chambers and finds the destabilizing families, which then writes into distinct txt files, while discarding false walls/chambers
    """
    flag = [1000]
    r = hyp_no-1
    tden = deg*hyp_no/dim
    monomial_hypersurface = monomials(dim, deg)
    monomial_hyperplane = monomials(dim, 1)
    newflag = 1000
    allwalls = all_walls(onepslist, monomial_hypersurface, monomial_hyperplane, hyp_no, dim, deg) #generates all possible walls
    print('The number of walls is ', len(allwalls))
    allchambers = t_chambers(allwalls)  #generates all possible chambers
    maximal_dest_vm_walls = []
    maximal_dest_bm_walls = []
    if r != 1:
        maximal_dest_bm_walls = [[] for i in range(r)]
    maximal_dest_bhm_walls = []
    support_monomials_walls = []
    if r != 1:
        support_monomials_walls = [[] for i in range(r)]
    support_monomialsh_walls = []
    set_value = -10
    for i in range(len(allwalls)):
        if allwalls[i] == tden:
            set_value = i
    gamma_walls = []
    for wall in allwalls:  #generates the de-stabilizing families for each wall
        set_t = max_sets_t(onepslist, wall, monomial_hypersurface, monomial_hyperplane, hyp_no)
        maximal_dest_vm_walls.append(set_t[0])
        if r != 1:
            for i in range(r):
                maximal_dest_bm_walls[i].append(set_t[1][i])
        else:
            maximal_dest_bm_walls.append(set_t[1])
        maximal_dest_bhm_walls.append(set_t[2])
        if r != 1:
            for i in range(r):
                support_monomials_walls[i].append(set_t[3][i])
        else:
            support_monomials_walls.append(set_t[3])
        support_monomialsh_walls.append(set_t[4])
        gamma_walls.append(set_t[5])
    maximal_dest_vm_chambers = []
    maximal_dest_bm_chambers = []
    if r != 1:
        maximal_dest_bm_chambers = [[] for i in range(r)]
    maximal_dest_bhm_chambers = []
    support_monomials_chambers = []
    if r != 1:
        support_monomials_chambers = [[] for i in range(r)]
    support_monomialsh_chambers = []
    gamma_chambers = []
    for cham in allchambers:  #generates the de-stabilizing families for each chamber
        set_t = max_sets_t(onepslist, cham, monomial_hypersurface, monomial_hyperplane, hyp_no)
        maximal_dest_vm_chambers.append(set_t[0])
        if r != 1:
            for i in range(r):
                maximal_dest_bm_chambers[i].append(set_t[1][i])
        else:
            maximal_dest_bm_chambers.append(set_t[1])
        maximal_dest_bhm_chambers.append(set_t[2])
        if r != 1:
            for i in range(r):
                support_monomials_chambers[i].append(set_t[3][i])
        else:
            support_monomials_chambers.append(set_t[3])
        support_monomialsh_chambers.append(set_t[4])
        gamma_chambers.append(set_t[5])
    discarded_positions_walls = []
    discarded_positions_chambers = []
    if r != 1:
        equality_test1 = []
        equality_test2 = []
        for i in range(len(maximal_dest_vm_chambers)):
            counter1 = 0
            for m in range(r):
                equality_test1.append(maxsets_comparison(maximal_dest_vm_walls[i + 1], maximal_dest_vm_chambers[i], maximal_dest_bm_walls[m][i + 1], maximal_dest_bm_chambers[m][i], maximal_dest_bhm_walls[i + 1], maximal_dest_bhm_chambers[i], hyp_no))
                if i < len(maximal_dest_vm_chambers) - 1:
                    equality_test2.append(maxsets_comparison(maximal_dest_vm_walls[i + 1], maximal_dest_vm_chambers[i + 1], maximal_dest_bm_walls[m][i + 1], maximal_dest_bm_chambers[m][i + 1], maximal_dest_bhm_walls[i + 1], maximal_dest_bhm_chambers[i + 1], hyp_no))
                    if (equality_test1[m] == True) and (equality_test2[m] == True):
                        counter1 = counter1 + 1
            if counter1 == r: #maybe this removes too much
                discarded_positions_walls.append(i + 1)
                discarded_positions_chambers.append(i)
    else:
        for i in range(len(maximal_dest_vm_chambers)):
            equality_test1 = maxsets_comparison(maximal_dest_vm_walls[i+1], maximal_dest_vm_chambers[i], maximal_dest_bm_walls[i+1], maximal_dest_bm_chambers[i], maximal_dest_bhm_walls[i+1], maximal_dest_bhm_chambers[i], hyp_no)
            if i < len(maximal_dest_vm_chambers)-1:
                equality_test2 = maxsets_comparison(maximal_dest_vm_walls[i+1], maximal_dest_vm_chambers[i+1], maximal_dest_bm_walls[i+1], maximal_dest_bm_chambers[i+1], maximal_dest_bhm_walls[i+1], maximal_dest_bhm_chambers[i+1], hyp_no)
                if equality_test1 and equality_test2:
                    discarded_positions_walls.append(i+1)
                    discarded_positions_chambers.append(i)
    while set_value in discarded_positions_walls:
        discarded_positions_chambers.remove(set_value - 1)
        discarded_positions_walls.remove(set_value)
    for i in discarded_positions_walls:  #sets to discard false walls/chambers
        maximal_dest_vm_walls[i]= flag
        if r != 1:
            for k in range(r):
                maximal_dest_bm_walls[k][i] = flag
        else:
            maximal_dest_bm_walls[i] = flag
        maximal_dest_bhm_walls[i] = flag
        if r != 1:
            for k in range(r):
                support_monomials_walls[k][i] = flag
        else:
            support_monomials_walls[i] = flag
        support_monomialsh_walls[i] = flag
        gamma_walls[i] = flag
    while flag in maximal_dest_vm_walls:
        maximal_dest_vm_walls.remove(flag)
    if r != 1:
        for k in range(r):
            while flag in maximal_dest_bm_walls[k]:
                maximal_dest_bm_walls[k].remove(flag)
    else:
        while flag in maximal_dest_bm_walls:
            maximal_dest_bm_walls.remove(flag)
    while flag in maximal_dest_bhm_walls:
        maximal_dest_bhm_walls.remove(flag)
    if r != 1:
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
        if r != 1:
            for k in range(r):
                maximal_dest_bm_chambers[k][j] = flag
        else:
            maximal_dest_bm_chambers[j] = flag
        maximal_dest_bhm_chambers[j] = flag
        if r != 1:
            for k in range(r):
                support_monomials_chambers[k][j] = flag
        else:
            support_monomials_chambers[j] = flag
        support_monomialsh_chambers[j] = flag
        gamma_chambers[j] = flag
    while flag in maximal_dest_vm_chambers:
        maximal_dest_vm_chambers.remove(flag)
    if r != 1:
        for k in range(r):
            while flag in maximal_dest_bm_chambers[k]:
                maximal_dest_bm_chambers[k].remove(flag)
    else:
        while flag in maximal_dest_bm_chambers:
            maximal_dest_bm_chambers.remove(flag)
    while flag in maximal_dest_bhm_chambers:
        maximal_dest_bhm_chambers.remove(flag)
    if r != 1:
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
    with open("maximal_dest_vm_walls.txt", "wb") as fp:   #Pickling
        pickle.dump(maximal_dest_vm_walls, fp)
    with open("maximal_dest_vm_chambers.txt", "wb") as fp:   #Pickling
        pickle.dump(maximal_dest_vm_chambers, fp)
    with open("maximal_dest_bm_walls.txt", "wb") as fp:   #Pickling
        pickle.dump(maximal_dest_bm_walls, fp)
    with open("maximal_dest_bm_chambers.txt", "wb") as fp:   #Pickling
        pickle.dump(maximal_dest_bm_chambers, fp)
    with open("maximal_dest_bhm_walls.txt", "wb") as fp:   #Pickling
        pickle.dump(maximal_dest_bhm_walls, fp)
    with open("maximal_dest_bhm_chambers.txt", "wb") as fp:   #Pickling
        pickle.dump(maximal_dest_bhm_chambers, fp)
    with open("support_monomials_walls.txt", "wb") as fp:   #Pickling
        pickle.dump(support_monomials_walls, fp)
    with open("support_monomials_chambers.txt", "wb") as fp:   #Pickling
        pickle.dump(support_monomials_chambers, fp)
    with open("support_monomialsh_walls.txt", "wb") as fp:   #Pickling
        pickle.dump(support_monomialsh_walls, fp)
    with open("support_monomialsh_chambers.txt", "wb") as fp:   #Pickling
        pickle.dump(support_monomialsh_chambers, fp)
    with open("gamma_walls.txt", "wb") as fp:   #Pickling
        pickle.dump(gamma_walls, fp)
    with open("gamma_chambers.txt", "wb") as fp:   #Pickling
        pickle.dump(gamma_chambers, fp)
    with open("used_walls.txt", "wb") as fp:   #Pickling
        pickle.dump(used_walls, fp)
    with open("used_chambers.txt", "wb") as fp:   #Pickling
        pickle.dump(used_chambers, fp)
