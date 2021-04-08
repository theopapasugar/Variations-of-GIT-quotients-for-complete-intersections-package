#!/usr/bin/python36
from functions import *

from OPS_set import *




def max_sets_t(onepslist, t, monomial_list1, monomial_list2, hyp_no):
    """
    
    @param onepslist: a list of list of floats, corresponding to a list of one-parameter subgroups
    @param t: float, a wall/chamber
    @param monomial_list1: a list of list of floats, corresponding to a list of monomials in hypersurface
    @param monomial_list2: a list of list of floats, corresponding to a list of monomials in hyperplane
    @param hyp_no: int, the number of hypersurfaces
    @return: a list containing all the destabilizing families with respect to the specific t
    """
    # monomial_list1 corresponds to monomials in hypersurface, monomial_list2 corresponds to monomials in hyperplane

    flag = [1000]
    r = hyp_no-1
    mon_combins = monomial_list1
    if r != 1:
        mon_combins = list(itertools.combinations(monomial_list1, int(r)))
    maximal_dest_vmt = []
    maximal_dest_bmt = []
    if r != 1:
        maximal_dest_bmt = [[] for i in range(r)]
    maximal_dest_bhmt = []
    support_monomialst = []
    if r != 1:
        support_monomialst = [[] for i in range(r)]
    support_monomialsht = []
    gammat = []
    for gamma in onepslist:
        for moni in mon_combins:
            for monxj in monomial_list2:
                bhm = []
                vm = []
                bm = []
                if r != 1:
                    bm = [[] for i in range(r)]
                for mon in monomial_list1:
                    summed = moni
                    if r != 1:
                        summed = []
                        for elem in moni:
                            summed = [el1+el2 for el1, el2 in zip(elem, summed)]
                    if dot_product(mon, gamma) + dot_product(summed, gamma) + t*dot_product(monxj, gamma) <= 0:
                        #checks the H-M criterion
                        vm.append(mon)
                        #generates the vm
                    if r != 1:  #generates the bm if hyp_no>2
                        for i in range(r):
                            if gamma_bigger_e(mon, moni[i], gamma):
                                bm[i].append(mon)
                    else:  #generates the bm if hyp_no == 2
                        if gamma_bigger_e(mon, moni, gamma):
                            bm.append(mon)
                if t != 0:  #generates the bm for the hyperplane if t !=0
                    for monxi in monomial_list2:
                        if gamma_bigger_e(monxi, monxj, gamma):
                            bhm.append(monxi)
                else:
                    bhm = []
                if r != 1:
                    for m in range(r):
                        if not bm[m]:
                            continue
                if len(maximal_dest_vmt) == 0:
                    # if vm not in maximal_dest_vmt and bm[i] not in maximal_dest_bmt[i] and bhm not in maximal_dest_bhmt:
                    maximal_dest_vmt.append(vm)
                    if r != 1:
                        for i in range(r):
                            maximal_dest_bmt[i].append(bm[i])
                    else:
                        maximal_dest_bmt.append(bm)
                    maximal_dest_bhmt.append(bhm)
                    if r != 1:
                        for i in range(r):
                            support_monomialst[i].append(moni[i])
                    else:
                        support_monomialst.append(moni)
                    support_monomialsht.append(monxj)
                    gammat.append(gamma)
                else:  #this tests whether the (vm,bm,bhm) has been added before and if it has it passes it
                    test_indices1 = []
                    test_indices2 = []
                    if r != 1:
                        test_indices2 = [[] for i in range(r)]
                    test_indices3 = []
                    intersections = []
                    for i in range(len(maximal_dest_vmt)):
                        test1 = all(elem in maximal_dest_vmt[i] for elem in vm)  #tests if all vm is in maximal_dest_vmt
                        if test1:
                            test_indices1.append(i)
                    if test_indices1:
                        for no in test_indices1:
                            if hyp_no == 2:
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
                        if r != 1:
                            for i in range(r):
                                maximal_dest_bmt[i].append(bm[i])
                        else:
                            maximal_dest_bmt.append(bm)
                        maximal_dest_bhmt.append(bhm)
                        if r != 1:
                            for i in range(r):
                                support_monomialst[i].append(moni[i])
                        else:
                            support_monomialst.append(moni)
                        support_monomialsht.append(monxj)
                        gammat.append(gamma)
                        continue
                    for i in range(r):
                        if test_indices2[i]:
                            for j in range(r):
                                if j > i:
                                    if test_indices2[j]:
                                        intersections.append(list(set(test_indices2[i]).intersection(test_indices2[j])))
                            if isinstance(intersections[0], list):
                                flat_list = [item for sublist in intersections for item in sublist]
                                intersections = list(set(flat_list))
                        else:
                            maximal_dest_vmt.append(vm)
                            if r != 1:
                                for m in range(r):
                                    maximal_dest_bmt[m].append(bm[m])
                            else:
                                maximal_dest_bmt.append(bm)
                            maximal_dest_bhmt.append(bhm)
                            if r != 1:
                                for k in range(r):
                                    support_monomialst[k].append(moni[i])
                            else:
                                support_monomialst.append(moni)
                            support_monomialsht.append(monxj)
                            gammat.append(gamma)
                            continue
                    if not intersections:
                        maximal_dest_vmt.append(vm)
                        if r != 1:
                            for i in range(r):
                                maximal_dest_bmt[i].append(bm[i])
                        else:
                            maximal_dest_bmt.append(bm)
                        maximal_dest_bhmt.append(bhm)
                        if r != 1:
                            for i in range(r):
                                support_monomialst[i].append(moni[i])
                        else:
                            support_monomialst.append(moni)
                        support_monomialsht.append(monxj)
                        gammat.append(gamma)
                        continue
                    else:
                        for j in intersections:
                            test3 = all(elem in maximal_dest_bhmt[j] for elem in bhm)
                            if test3:
                                test_indices3.append(j)
                    if test_indices3:
                        continue
                    else:
                        maximal_dest_vmt.append(vm)
                        if r != 1:
                            for i in range(r):
                                maximal_dest_bmt[i].append(bm[i])
                        else:
                            maximal_dest_bmt.append(bm)
                        maximal_dest_bhmt.append(bhm)
                        if r != 1:
                            for i in range(r):
                                support_monomialst[i].append(moni[i])
                        else:
                            support_monomialst.append(moni)
                        support_monomialsht.append(monxj)
                        gammat.append(gamma)
                        continue
    for j in range(len(maximal_dest_vmt)):  #removes all extra elements not detected by method above
        for k in range(len(maximal_dest_vmt)):
            test1 = all(elem in maximal_dest_vmt[j] for elem in maximal_dest_vmt[k])
            test2 = True
            if r == 1:
                test2 = all(elem in maximal_dest_bmt[j] for elem in maximal_dest_bmt[k])
            if r != 1:
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
                if r != 1:
                    for i in range(r):
                        maximal_dest_bmt[i][k] = flag
                else:
                    maximal_dest_bmt[k] = flag
                maximal_dest_bhmt[k] = flag
                if r != 1:
                    for i in range(r):
                        support_monomialst[i][k] = flag
                else:
                    support_monomialst[k] = flag
                support_monomialsht[k] = flag
                gammat[k] = flag
    while flag in maximal_dest_vmt:
        maximal_dest_vmt.remove(flag)
    if r != 1:
        for i in range(r):
            while flag in maximal_dest_bmt[i]:
                maximal_dest_bmt[i].remove(flag)
    else:
        while flag in maximal_dest_bmt:
            maximal_dest_bmt.remove(flag)
    while flag in maximal_dest_bhmt:
        maximal_dest_bhmt.remove(flag)
    if r != 1:
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
