#from functions import *
def my_import(module_name, func_name='*'):
    import os
    os.system('sage --preparse ' + module_name + '.sage')
    os.system('mv ' + module_name + '.sage.py ' + module_name + '.py')

    from sage.misc.python import Python
    python = Python()
    python.eval('from ' + module_name + ' import ' + func_name, globals())

my_import("functions")

#todo add docstrings
#todo fix mistake when calling classes

class Problem:
    """docstring for Problem"""
    def __init__(self, dim, deg, hyp_no):
        self.dim = dim
        self.deg = deg
        self.hyp_no = hyp_no


        
    def ops_set(self):
        """

        @param monomial_list: a list of list of floats, corresponding to all the monomials of the hyperpsurface. DEFAULT: the monomial list of given dimension and degree
        @param self.dim: int, the dimension of the embedded projective space
        @param self.hyp_no: the number of hypersurfaces
        @return: a list of list of floats, corresponding to all the one-parameter subgroups
        """
        monomial_list = monomials(self.dim, self.deg)
        dimn = self.dim + 1
        flag1 = [1000 for i in range(self.dim+1)]
        r = 2*self.hyp_no
        monomial_combs = list(itertools.combinations(monomial_list, int(r)))
        eqs = []
        vector3 = [1 for i in range(dimn)]
        vector4 = [0 for i in range(self.dim)]
        vector4.insert(0, 1)
        vector_f = [vector3, vector4]
        vector_t = [0 for i in range(self.dim)]
        vector_t.append(1)
        vector_target = vector(vector_t)
        for perm in monomial_combs:
            total_p = [0 for i in range(self.dim+1)]
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
        if self.dim > 2:
            combs_list = list(itertools.combinations(eqs_final, int(self.dim-1)))
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
                if elem[self.dim] < 0 and ordertest(elem):
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
        elif self.dim == 2:
            for elem in eqs_final:
                try:
                    mat_list = [elem] + vector_f
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
                if elem[self.dim] < 0 and ordertest(elem):
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
        else:
            vector_f = [vector3]
            for elem in eqs_final:
                try:
                    mat_list = [elem] + vector_f
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
                if elem[self.dim] < 0 and ordertest(elem):
                    #keeps only normalised one-parameter subgroups
                    sols_set.append(elem)
            full_solution = [tuple(elem) for elem in sols_set]
            final_set = list(set(full_solution))  #removes duplicates
            final_set1 = [list(elem) for elem in final_set]
            final_set1.append([1,-1])
            print(len(final_set1))
            with open("ops_set.txt", "wb") as fp:
                #Pickling
                pickle.dump(final_set1, fp)
            return final_set1


    def max_semi_dest_sets(self, onepslist):
        """

        @param onepslist:a list of list of floats, corresponding to a list of one-parameter subgroups. DEFAULT: the list of one-parameter subgroups of given dimension and degree and number of hypersurfaces
        @param self.dim: int, the dimension of the embedded projective space
        @param self.deg: an int, the degree of the hypersurfaces
        @param self.hyp_no: int, the number of hypersurfaces
        @return: Generates all walls/chambers and finds the destabilizing families, which then writes into distinct txt files, while discarding false walls/chambers
        """
        #onepslist = ops_set(self)
        flag = [1000]
        r = self.hyp_no-1
        tden = self.deg*self.hyp_no/self.dim
        monomial_hypersurface = monomials(self.dim, self.deg)
        monomial_hyperplane = monomials(self.dim, 1)
        newflag = 1000
        allwalls = all_walls(onepslist, monomial_hypersurface, monomial_hyperplane, self.hyp_no, self.dim, self.deg) #generates all possible walls
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
            set_t = max_sets_t(self, onepslist, wall)
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
            set_t = max_sets_t(self, onepslist, cham)
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


    def max_sets_t(self, onepslist, t=0):
        """
        
        @param onepslist: a list of list of floats, corresponding to a list of one-parameter subgroups. DEFAULT: the list of one-parameter subgroups of given dimension and degree and number of hypersurfaces
        @param t: float, a wall/chamber
        @param monomial_list1: a list of list of floats, corresponding to a list of monomials in hypersurface. DEFAULT: the monomial list of given dimension and degree
        @param monomial_list2: a list of list of floats, corresponding to a list of monomials in hyperplane. DEFAULT: the monomial list of hyperplanes given dimension
        @param self.hyp_no: int, the number of hypersurfaces
        @return: a list containing all the destabilizing families with respect to the specific t
        """
        # monomial_list1 corresponds to monomials in hypersurface, monomial_list2 corresponds to monomials in hyperplane
        #onepslist = ops_set(self)
        monomial_list1 = monomials(self.dim, self.deg)
        monomial_list2 = monomials(self.dim, 1)
        flag = [1000]
        r = self.hyp_no-1
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
                        if r != 1:  #generates the bm if self.hyp_no>2
                            for i in range(r):
                                if gamma_bigger_e(mon, moni[i], gamma):
                                    bm[i].append(mon)
                        else:  #generates the bm if self.hyp_no == 2
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
                        if r != 1: 
                            for i in range(r): #this needs fixing
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
                                    for m in range(r):
                                        maximal_dest_bmt[m].append(bm[m])
                                    maximal_dest_bhmt.append(bhm)
                                    for k in range(r):
                                        support_monomialst[k].append(moni[i])
                                    support_monomialsht.append(monxj)
                                    gammat.append(gamma)
                                    continue
                            if not intersections:
                                maximal_dest_vmt.append(vm)
                                for i in range(r):
                                    maximal_dest_bmt[i].append(bm[i])
                                maximal_dest_bhmt.append(bhm)
                                for i in range(r):
                                    support_monomialst[i].append(moni[i])
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
                                continue
                            if test_indices3:
                                continue
                            else:
                                maximal_dest_vmt.append(vm)
                                maximal_dest_bmt.append(bm)
                                maximal_dest_bhmt.append(bhm)
                                support_monomialst.append(moni)
                                support_monomialsht.append(monxj)
                                gammat.append(gamma)
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


    def printout(self):
        """

        @param onepslist:a list of list of floats, corresponding to a list of one-parameter subgroups. DEFAULT: the list of one-parameter subgroups of given dimension and degree and number of hypersurfaces
        @param self.dim: int, the dimension of the embedded projective space
        @param self.deg: an int, the degree of the hypersurfaces
        @param self.hyp_no: int, the number of hypersurfaces
        @return: Prints the destabilizing families for all walls/chambers in a txt file
        """
        onepslist = ops_set(self)
        r = self.hyp_no-1
        d = self.dim+1
        f = open("VGIT_output_intersections.txt", "a")
        print('Solving for complete intersection of degree',self.deg, 'and hyperplane section in dimension', self.dim, file=f)
        max_semi_dest_sets(onepslist, self.dim, self.deg, self.hyp_no)  #generates families
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
                    if centroid_criterion(maximal_dest_vm_walls[i][j], max_dest_bm_walls_needed, maximal_dest_bhm_walls[i][j], used_walls[i], gamma_walls[i][j], self.dim, self.deg, self.hyp_no):  #checks if strictly semistable
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
                    if centroid_criterion(maximal_dest_vm_walls[i][j], maximal_dest_bm_walls[i][j], maximal_dest_bhm_walls[i][j], used_walls[i], gamma_walls[i][j], self.dim, self.deg, self.hyp_no):
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
                    if centroid_criterion(maximal_dest_vm_chambers[i][j], max_dest_bm_chambers_needed, maximal_dest_bhm_chambers[i][j], used_chambers[i], gamma_chambers[i][j], self.dim, self.deg, self.hyp_no):
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
                    if centroid_criterion(maximal_dest_vm_chambers[i][j], maximal_dest_bm_chambers[i][j], maximal_dest_bhm_chambers[i][j], used_chambers[i], gamma_chambers[i][j], self.dim, self.deg, self.hyp_no):
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
