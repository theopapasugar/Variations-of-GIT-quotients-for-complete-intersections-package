#!/usr/bin/python36
from functions import *
from Walls import *
from Families import *
#todo add sage docstrings

def printout(onepslist, dim, deg, hyp_no):
    """

    @param onepslist:a list of list of floats, corresponding to a list of one-parameter subgroups
    @param dim: int, the dimension of the embedded projective space
    @param deg: an int, the degree of the hypersurfaces
    @param hyp_no: int, the number of hypersurfaces
    @return: Prints the destabilizing families for all walls/chambers in a txt file
    """
    r = hyp_no-1
    d = dim+1
    f = open("VGIT_output_intersections.txt", "a")
    print('Solving for complete intersection of degree',deg, 'and hyperplane section in dimension', dim, file=f)
    max_semi_dest_sets(onepslist, dim, deg, hyp_no)  #generates families
    print('Found false walls', file=f)
    with open("maximal_dest_vm_walls.txt", "rb") as fp:   #Unpickling
        maximal_dest_vm_walls = pickle.load(fp)
    with open("maximal_dest_vm_chambers.txt", "rb") as fp:   #Unpickling
        maximal_dest_vm_chambers = pickle.load(fp)
    with open("maximal_dest_bm_walls.txt", "rb") as fp:   #Unpickling
        maximal_dest_bm_walls = pickle.load(fp)
    with open("maximal_dest_bm_chambers.txt", "rb") as fp:   #Unpickling
        maximal_dest_bm_chambers = pickle.load(fp)
    with open("maximal_dest_bhm_walls.txt", "rb") as fp:   #Unpickling
        maximal_dest_bhm_walls = pickle.load(fp)
    with open("maximal_dest_bhm_chambers.txt", "rb") as fp:   #Unpickling
        maximal_dest_bhm_chambers = pickle.load(fp)
    with open("support_monomials_walls.txt", "rb") as fp:   #Unpickling
        support_monomials_walls = pickle.load(fp)
    with open("support_monomials_chambers.txt", "rb") as fp:   #Unpickling
        support_monomials_chambers = pickle.load(fp)
    with open("support_monomialsh_walls.txt", "rb") as fp:   #Unpickling
        support_monomialsh_walls = pickle.load(fp)
    with open("support_monomialsh_chambers.txt", "rb") as fp:   #Unpickling
        support_monomialsh_chambers = pickle.load(fp)
    with open("gamma_walls.txt", "rb") as fp:   #Unpickling
        gamma_walls = pickle.load(fp)
    with open("gamma_chambers.txt", "rb") as fp:   #Unpickling
        gamma_chambers = pickle.load(fp)
    with open("used_walls.txt", "rb") as fp:   #Unpickling
        used_walls = pickle.load(fp)
    with open("used_chambers.txt", "rb") as fp:   #Unpickling
        used_chambers = pickle.load(fp)
    print('The walls are', used_walls, file=f)
    print('The chambers are', used_chambers, file=f)
    tl = var('x', n=d)
    for i in range(len(maximal_dest_vm_walls)):
        print('Solving for wall', used_walls[i], file=f)
        for j in range(len(maximal_dest_vm_walls[i])):
            lv = len(maximal_dest_vm_walls[i][j])
            lb = 0
            if r != 1:
                lb = [0 for i in range(r)]
                for k in range(r):
                    lb[k] = len(maximal_dest_bm_walls[k][i][j])
            else:
                lb = len(maximal_dest_bm_walls[i][j])
            lbh = 0
            if used_walls[i] != 0:
                lbh = len(maximal_dest_bhm_walls[i][j])
            a = var('a', n=lv)
            eq_sum_v = 0
            for k in range(lv):  #generates equation for each Vm
                eq_sum_v = a[k]*mult_list(to_the_power(tl, maximal_dest_vm_walls[i][j][k])) + eq_sum_v
            b = []
            if r != 1:
                b = [0 for i in range(r)]
                for k in range(r):
                    b[k] = var('b', n=lb[k])
            else:
                b = var('b', n=lb)
            eq_sum_b = 0
            if r != 1:
                eq_sum_b = [0 for i in range(r)]
                for m in range(r):
                    for k in range(lb[m]):  #generates equation for each Bm[m]
                        eq_sum_b[m] = b[m][k]*mult_list(to_the_power(tl, maximal_dest_bm_walls[m][i][j][k])) + eq_sum_b[m]
            else:
                eq_sum_b = 0
                for k in range(lb):  #generates equation for each Bm
                    eq_sum_b = b[k]*mult_list(to_the_power(tl, maximal_dest_bm_walls[i][j][k])) + eq_sum_b
            c = var('c', n=lbh)
            eq_sum_bh = 0
            if used_walls[i] > 0:
                for k in range(lbh):  #generates equation for each Bhm
                    eq_sum_bh = c[k]*mult_list(to_the_power(tl, maximal_dest_bhm_walls[i][j][k])) + eq_sum_bh
            print('Case', j+1, file=f)
            print('V^- = ', eq_sum_v, file=f)
            if r != 1:
                print('The B^- are:', file=f)
                for m in range(r):
                    print(m, file=f)
                    print(eq_sum_b[m], file=f)
            else:
                print('B^- = ', eq_sum_b, file=f)
            if used_walls[i] > 0:
                print('Hyperplane B^- = ', eq_sum_bh, file=f)
            if r != 1:
                print('Support monomials for the hypersurfaces: ', file=f)
                for m in range(r):
                    print(m, file=f)
                    print(support_monomials_walls[m][i][j], file=f)
            else:
                print('Support monomial hypersurface: ', support_monomials_walls[i][j], file=f)
            print('Support monomial hyperplane: ', support_monomialsh_walls[i][j], file=f)
            print('1-ps: ', gamma_walls[i][j], file=f)
            max_dest_bm_walls_needed = []
            if r != 1:
                max_dest_bm_walls_needed = [0 for el in range(r)]
                for k in range(r):
                    max_dest_bm_walls_needed[k] = maximal_dest_bm_walls[k][i][j]
                if centroid_criterion(maximal_dest_vm_walls[i][j], max_dest_bm_walls_needed, maximal_dest_bhm_walls[i][j], used_walls[i], gamma_walls[i][j], dim, deg, hyp_no):  #checks if strictly semistable
                    print('This is a strictly t-semistable family', file=f)
                    flag = [10000]
                    vm0 = []
                    bm0 = [[] for i in range(r)]
                    bhm0 = []
                    indices = []
                    zipped_list = list(itertools.product(*max_dest_bm_walls_needed))
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
                    for monv in maximal_dest_vm_walls[i][j]:
                        for monb in products:
                            summ_l = []
                            for el1 in range(r):
                                summ_l = sum_of_tuples(summ_l, monb)
                            for monbh in maximal_dest_bhm_walls[i][j]:
                                if dot_product(monv, gamma_walls[i][j]) + dot_product(summ_l, gamma_walls[i][j]) + used_walls[i]*dot_product(monbh, gamma_walls[i][j]) == 0:
                                    vm0.append(monv)
                                    break
                    zipped_set = set(map(tuple, vm0))
                    vm0 = list(map(list, zipped_set))
                    if len(vm0) == 0:
                        continue
                    flaglist = [[] for m in range(r)]
                    for k in range(r):
                        for el in max_dest_bm_walls_needed[k]:
                            flaglist[k].append(dot_product(el, gamma_walls[i][j]))
                    #Asumming l = [2, 2, 4, 4]
                    map_1 = {}
                    maximum = -10000  # if everything is positive
                    for m in range(r):
                        if len(flaglist[m]) > 1:
                            for d, e in enumerate(flaglist[m]):
                                if e > maximum:
                                    maximum = e
                                    map_1[e] = [d]
                                elif e == maximum:
                                    map_1[maximum].append(d)
                            bm0[m] = [max_dest_bm_walls_needed[m][numb] for numb in map_1[maximum]]
                        else:
                            bm0[m] = max_dest_bm_walls_needed[m]
                    flaglist1 = []
                    if used_walls[i] > 0:
                        for monb1 in maximal_dest_bhm_walls[i][j]:
                            flaglist1.append(dot_product(monb1, gamma_walls[i][j]))
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
                            bhm0 = [maximal_dest_bhm_walls[i][j][numb] for numb in map_2[maximum]]
                        else:
                            bhm0 = maximal_dest_bhm_walls[i][j]
                    else:
                        bhm0 = []
                    l0 = len(vm0)
                    l1 = [0 for i in range(r)]
                    for m in range(r):
                        l1[m] = len(bm0[m])
                    l2 = len(bhm0)
                    d = var('d', n=l0)
                    e = [0 for m in range(r)]
                    for m in range(r):
                        e[m] = var('e', n=l1[m])
                    g = var('g', n=l2)
                    eq_sum_v0 = 0
                    for k in range(len(vm0)):
                        eq_sum_v0 = d[k]*mult_list(to_the_power(tl, vm0[k])) + eq_sum_v0
                    eq_sum_b0 = [0 for i in range(r)]
                    for m in range(r):
                        for k in range(len(bm0[m])):
                            eq_sum_b0[m] = e[m][k]*mult_list(to_the_power(tl, bm0[m][k])) + eq_sum_b0[m]
                    eq_sum_bh0 = 0
                    if used_walls[i] > 0:
                        for k in range(len(bhm0)):
                            eq_sum_bh0 = g[k]*mult_list(to_the_power(tl, bhm0[k])) + eq_sum_bh0
                    print('Potential closed orbit', file=f)
                    print('V^0 = ', eq_sum_v0, file=f)
                    print('The B^0 are: ', file=f)
                    for m in range(r):
                        print(eq_sum_b0[m], file=f)
                    if used_walls[i] > 0:
                        print('B^0_h = ', eq_sum_bh0, file=f)
                    print('#######################################################', file=f)
                else:
                    print('Not strictly t-semistable', file=f)
                    print('#######################################################', file=f)
            else:
                if centroid_criterion(maximal_dest_vm_walls[i][j], maximal_dest_bm_walls[i][j], maximal_dest_bhm_walls[i][j], used_walls[i], gamma_walls[i][j], dim, deg, hyp_no):
                    print('This is a strictly t-semistable family', file=f)
                    vm0 = []
                    bm0 = []
                    bhm0 = []
                    for monv in maximal_dest_vm_walls[i][j]:
                        for monb in maximal_dest_bm_walls[i][j]:
                            for monbh in maximal_dest_bhm_walls[i][j]:
                                if dot_product(monv, gamma_walls[i][j]) + dot_product(monb, gamma_walls[i][j]) + used_walls[i]*dot_product(monbh, gamma_walls[i][j]) == 0:
                                    vm0.append(monv)
                                    break
                    zipped_set = set(map(tuple, vm0))
                    vm0 = list(map(list, zipped_set))
                    if len(vm0) == 0:
                        continue
                    flaglist = []
                    for mon1 in maximal_dest_bm_walls[i][j]:
                        flaglist.append(dot_product(mon1, gamma_walls[i][j]))
                    #Asumming l = [2, 2, 4, 4]
                    map_1 = {}
                    maximum = -10000  # if everything is positive
                    if len(flaglist) > 1:
                        for d, e in enumerate(flaglist):
                            if e > maximum:
                                maximum = e
                                map_1[e] = [d]
                            elif e == maximum:
                                map_1[maximum].append(d)
                        bm0 = [maximal_dest_bm_walls[i][j][numb] for numb in map_1[maximum]]
                    else:
                        bm0 = maximal_dest_bm_walls[i][j]
                    flaglist1 = []
                    if used_walls[i] > 0:
                        for monb1 in maximal_dest_bhm_walls[i][j]:
                            flaglist1.append(dot_product(monb1, gamma_walls[i][j]))
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
                            bhm0 = [maximal_dest_bhm_walls[i][j][numb] for numb in map_2[maximum]]
                        else:
                            bhm0 = maximal_dest_bhm_walls[i][j]
                    else:
                        bhm0 = []
                    l0 = len(vm0)
                    l1 = len(bm0)
                    l2 = len(bhm0)
                    d = var('d', n=l0)
                    e = var('e', n=l1)
                    g = var('f', n=l2)
                    eq_sum_v0 = 0
                    for k in range(len(vm0)):
                        eq_sum_v0 = d[k]*mult_list(to_the_power(tl, vm0[k])) + eq_sum_v0
                    eq_sum_b0 = 0
                    for k in range(len(bm0)):
                        eq_sum_b0 = e[k]*mult_list(to_the_power(tl, bm0[k])) + eq_sum_b0
                    eq_sum_bh0 = 0
                    if used_walls[i] > 0:
                        for k in range(len(bhm0)):
                            eq_sum_bh0 = g[k]*mult_list(to_the_power(tl, bhm0[k])) + eq_sum_bh0
                    print('Potential closed orbit', file=f)
                    print('V^0 = ', eq_sum_v0, file=f)
                    print('B^0 = ', eq_sum_b0, file=f)
                    if used_walls[i] > 0:
                        print('B^0_h = ', eq_sum_bh0, file=f)
                    print('#######################################################', file=f)
                else:
                    print('Not strictly t-semistable', file=f)
                    print('#######################################################', file=f)
    for i in range(len(maximal_dest_vm_chambers)):
        print('Solving for chamber', used_chambers[i], file=f)
        for j in range(len(maximal_dest_vm_chambers[i])):
            lv = len(maximal_dest_vm_chambers[i][j])
            lb = 0
            if r != 1:
                lb = [0 for no in range(r)]
                for k in range(r):
                    lb[k] = len(maximal_dest_bm_chambers[k][i][j])
            else:
                lb = len(maximal_dest_bm_chambers[i][j])
            lbh = len(maximal_dest_bhm_chambers[i][j])
            a = var('a', n=lv)
            eq_sum_v = 0
            for k in range(lv):
                eq_sum_v = a[k]*mult_list(to_the_power(tl, maximal_dest_vm_chambers[i][j][k])) + eq_sum_v
            b = []
            if r != 1:
                b = [0 for i in range(r)]
                for k in range(r):
                    b[k] = var('b', n=lb[k])
            else:
                b = var('b', n=lb)
            eq_sum_b = 0
            if r != 1:
                eq_sum_b = [0 for i in range(r)]
                for m in range(r):
                    for k in range(lb[m]):
                        eq_sum_b[m] = b[m][k]*mult_list(to_the_power(tl, maximal_dest_bm_chambers[m][i][j][k])) + eq_sum_b[m]
            else:
                eq_sum_b = 0
                for k in range(lb):
                    eq_sum_b = b[k]*mult_list(to_the_power(tl, maximal_dest_bm_chambers[i][j][k])) + eq_sum_b
            c = var('c', n=lbh)
            eq_sum_bh = 0
            for k in range(lbh):
                eq_sum_bh = c[k]*mult_list(to_the_power(tl, maximal_dest_bhm_chambers[i][j][k])) + eq_sum_bh
            print('Case', j+1, file=f)
            print('V^- = ', eq_sum_v, file=f)
            if r != 1:
                print('The B^- are:', file=f)
                for m in range(r):
                    print(m, file=f)
                    print(eq_sum_b[m], file=f)
            else:
                print('B^- = ', eq_sum_b, file=f)
            print('Hyperplane B^- = ', eq_sum_bh, file=f)
            if r != 1:
                print('Support monomials for the hypersurfaces: ', file=f)
                for m in range(r):
                    print(m, file=f)
                    print(support_monomials_chambers[m][i][j], file=f)
            else:
                print('Support monomial hypersurface: ', support_monomials_chambers[i][j], file=f)
            print('Support monomial hyperplane: ', support_monomialsh_chambers[i][j], file=f)
            print('1-ps: ', gamma_chambers[i][j], file=f)
            if r != 1:
                max_dest_bm_chambers_needed = [0 for el in range(r)]
                for k in range(r):
                    max_dest_bm_chambers_needed[k] = maximal_dest_bm_chambers[k][i][j]
                if centroid_criterion(maximal_dest_vm_chambers[i][j], max_dest_bm_chambers_needed, maximal_dest_bhm_chambers[i][j], used_chambers[i], gamma_chambers[i][j], dim, deg, hyp_no):
                    print('This is a strictly t-semistable family', file=f)
                    flag = [10000]
                    vm0 = []
                    bm0 = [[] for i in range(r)]
                    bhm0 = []
                    indices = []
                    zipped_list = list(itertools.product(*max_dest_bm_chambers_needed))
                    products = [list(el) for el in zipped_list]
                    for m in range(len(products)):
                        cond = 0
                        for a in range(r):
                            for b in range(r):
                                if products[m][a] == products[m][b] and a != b:
                                    cond = 1
                                    pass
                        if cond == 1:
                            indices.append(m)
                    for numb in indices:
                        products[numb] = flag
                    while flag in products:
                        products.remove(flag)  # implemented summed method
                    for monv in maximal_dest_vm_chambers[i][j]:
                        for monb in products:
                            summ_l = []
                            for el1 in range(r):
                                summ_l = sum_of_tuples(summ_l, monb)
                            for monbh in maximal_dest_bhm_chambers[i][j]:
                                if dot_product(monv, gamma_chambers[i][j]) + dot_product(summ_l, gamma_chambers[i][j]) + used_chambers[i]*dot_product(monbh, gamma_chambers[i][j]) == 0:
                                    vm0.append(monv)
                                    break
                    zipped_set = set(map(tuple, vm0))
                    vm0 = list(map(list, zipped_set))
                    if len(vm0) == 0:
                        continue
                    flaglist = [[] for m in range(r)]
                    for m in range(r):
                        for el in max_dest_bm_chambers_needed[m]:
                            flaglist[m].append(dot_product(el, gamma_chambers[i][j]))
                    #Asumming l = [2, 2, 4, 4]
                    map_1 = {}
                    maximum = -10000  # if everything is positive
                    for m in range(r):
                        if len(flaglist[m]) > 1:
                            for d, e in enumerate(flaglist[m]):
                                if e > maximum:
                                    maximum = e
                                    map_1[e] = [d]
                                elif e == maximum:
                                    map_1[maximum].append(d)
                            bm0[m] = [max_dest_bm_chambers_needed[m][numb] for numb in map_1[maximum]]
                        else:
                            bm0[m] = max_dest_bm_chambers_needed[m]
                    flaglist1 = []
                    for monb1 in maximal_dest_bhm_chambers[i][j]:
                        flaglist1.append(dot_product(monb1, gamma_chambers[i][j]))
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
                        bhm0 = [maximal_dest_bhm_chambers[i][j][numb] for numb in map_2[maximum]]
                    else:
                        bhm0 = maximal_dest_bhm_chambers[i][j]
                    l0 = len(vm0)
                    l1 = [0 for i in range(r)]
                    for m in range(r):
                        l1[m] = len(bm0[m])
                    l2 = len(bhm0)
                    d = var('d', n=l0)
                    e = [[] for m in range(r)]
                    for m in range(r):
                        e[m] = var('e', n=l1[m])
                    g = var('f', n=l2)
                    eq_sum_v0 = 0
                    for k in range(len(vm0)):
                        eq_sum_v0 = d[k]*mult_list(to_the_power(tl, vm0[k])) + eq_sum_v0
                    eq_sum_b0 = [0 for i in range(r)]
                    for m in range(r):
                        for k in range(len(bm0[m])):
                            eq_sum_b0[m] = e[m][k]*mult_list(to_the_power(tl, bm0[m][k])) + eq_sum_b0[m]
                    eq_sum_bh0 = 0
                    for k in range(len(bhm0)):
                        eq_sum_bh0 = g[k]*mult_list(to_the_power(tl, bhm0[k])) + eq_sum_bh0
                    print('Potential closed orbit', file=f)
                    print('V^0 = ', eq_sum_v0, file=f)
                    print('The B^0 are: ', file=f)
                    for m in range(r):
                        print(m, file=f)
                        print(eq_sum_b0[m], file=f)
                    print('B^0_h = ', eq_sum_bh0, file=f)
                    print('#######################################################', file=f)
                else:
                    print('Not strictly t-semistable', file=f)
                    print('#######################################################', file=f)
            else:
                if centroid_criterion(maximal_dest_vm_chambers[i][j], maximal_dest_bm_chambers[i][j], maximal_dest_bhm_chambers[i][j], used_chambers[i], gamma_chambers[i][j], dim, deg, hyp_no):
                    print('This is a strictly t-semistable family', file=f)
                    vm0 = []
                    bm0 = []
                    bhm0 = []
                    for monv in maximal_dest_vm_chambers[i][j]:
                        for monb in maximal_dest_bm_chambers[i][j]:
                            for monbh in maximal_dest_bhm_chambers[i][j]:
                                if dot_product(monv, gamma_chambers[i][j]) + dot_product(monb, gamma_chambers[i][j]) + used_chambers[i]*dot_product(monbh, gamma_chambers[i][j]) == 0:
                                    vm0.append(monv)
                                    break
                    zipped_set = set(map(tuple, vm0))
                    vm0 = list(map(list, zipped_set))
                    if len(vm0) == 0:
                        continue
                    flaglist = []
                    for mon1 in maximal_dest_bm_chambers[i][j]:
                        flaglist.append(dot_product(mon1, gamma_chambers[i][j]))
                    #Asumming l = [2, 2, 4, 4]
                    map_1 = {}
                    maximum = -10000  # if everything is positive
                    if len(flaglist) > 1:
                        for d, e in enumerate(flaglist):
                            if e > maximum:
                                maximum = e
                                map_1[e] = [d]
                            elif e == maximum:
                                map_1[maximum].append(d)
                        bm0 = [maximal_dest_bm_chambers[i][j][numb] for numb in map_1[maximum]]
                    else:
                        bm0 = maximal_dest_bm_chambers[i][j]
                    flaglist1 = []
                    for monb1 in maximal_dest_bhm_chambers[i][j]:
                        flaglist1.append(dot_product(monb1, gamma_chambers[i][j]))
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
                        bhm0 = [maximal_dest_bhm_chambers[i][j][numb] for numb in map_2[maximum]]
                    else:
                        bhm0 = maximal_dest_bhm_chambers[i][j]
                    l0 = len(vm0)
                    l1 = len(bm0)
                    l2 = len(bhm0)
                    d = var('d', n=l0)
                    e = var('e', n=l1)
                    g = var('f', n=l2)
                    eq_sum_v0 = 0
                    for k in range(len(vm0)):
                        eq_sum_v0 = d[k]*mult_list(to_the_power(tl, vm0[k])) + eq_sum_v0
                    eq_sum_b0 = 0
                    for k in range(len(bm0)):
                        eq_sum_b0 = e[k]*mult_list(to_the_power(tl, bm0[k])) + eq_sum_b0
                    eq_sum_bh0 = 0
                    for k in range(len(bhm0)):
                        eq_sum_bh0 = g[k]*mult_list(to_the_power(tl, bhm0[k])) + eq_sum_bh0
                    print('Potential closed orbit', file=f)
                    print('V^0 = ', eq_sum_v0, file=f)
                    print('B^0 = ', eq_sum_b0, file=f)
                    print('B^0_h = ', eq_sum_bh0, file=f)
                    print('#######################################################', file=f)
                else:
                    print('Not strictly t-semistable', file=f)
                    print('#######################################################', file=f)
    f.close()

