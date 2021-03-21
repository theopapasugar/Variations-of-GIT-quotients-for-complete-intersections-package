#from functions import *
def my_import(module_name, func_name='*'):
    import os
    os.system('sage --preparse ' + module_name + '.sage')
    os.system('mv ' + module_name + '.sage.py ' + module_name + '.py')

    from sage.misc.python import Python
    python = Python()
    python.eval('from ' + module_name + ' import ' + func_name, globals())

my_import("functions")
my_import("Monomials")
my_import("OPS")

#todo add docstrings
#todo maybe break problem in two classes, one parent class Problem, one subclass Printout


class Problem:
    """docstring for Problem"""
    def __init__(self, dim, deg, hyp_no):
        self.dim = dim
        self.deg = deg
        self.hyp_no = hyp_no


    def t_walls(self, oneps):
        """

        @param monomial_list1: list of lists of monomials, corresponding to the monomials of the hypersurfaces
        @param monomial_list2: list of lists of monomials, corresponding to the monomials of the hyperplane
        @param no_of_hypersurfaces: the number of hypersurfaces
        @param oneps: a list corresponding to a one-parameter subgroup
        @param dimension: int, the dimension of the embedded projective space
        @param degree: int, the degree of the hypersurfaces
        @return: list of floats, sorted with ascending order corresponding to the walls with respect to the oneps
        """
        monomial_list1 = Monomial.monomials(self.dim, self.deg)
        monomial_list2 = Monomial.monomials(self.dim, 1)
        walls = []
        r = self.hyp_no
        d = self.dim + 1
        max_wall = r * self.deg / self.dim
        monomial_combinations = itertools.combinations(monomial_list1, int(r))
        for monc in monomial_combinations:
            total_t = Monomial([0 for i in range(d)])
            for j in range(0, len(monc)):
                total_t =  monc[j] + total_t
            for mon in monomial_list2:
                tnum = Monomial(total_t).dot_product(oneps)
                tden = mon.dot_product(oneps)
                if tden != 0:
                    t = -tnum / tden
                    if 0 <= t <= max_wall:
                        walls.append(t)
        if 0 not in walls: #ensures extremal walls are added
            walls.append(0)
        if max_wall not in walls:
            walls.append(max_wall)
        walls = list(dict.fromkeys(walls))
        walls.sort()
        return walls


    def all_walls(self, onepset_list=None):
        """

        @param onepset_list: a list of lists corresponding to a list one-parameter subgroup
        @param monomial_list1: list of lists of monomials, corresponding to the monomials of the hypersurfaces
        @param monomial_list2: corresponding to the monomials of the hyperplane
        @param no_of_hypersurfaces: the number of hypersurfaces
        @param dim: the dimension of the embeded projective space
        @param deg: the degree of the hypersurfaces
        @return: list of floats, sorted with ascending order corresponding to all the walls
        """
        #if onepslist == None:
        #    onepslist = OPS.ops_set(self.dim, self.deg, self.hyp_no)
        monomial_list1 = Monomial.monomials(self.dim, self.deg)
        monomial_list2 = Monomial.monomials(self.dim, 1)
        final_walls = []
        for oneps in onepset_list:
            specific_walls = self.t_walls(oneps)
            final_walls.append(specific_walls)
        final_walls = sum(final_walls, [])
        final_walls = list(dict.fromkeys(final_walls))
        final_walls.sort()
        return final_walls

        # This defines a method to calculate the GIT chambers

    @staticmethod
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



    def max_semi_dest_sets(self, onepslist=None):
        """

        @param onepslist:a list of list of floats, corresponding to a list of one-parameter subgroups. DEFAULT: the list of one-parameter subgroups of given dimension and degree and number of hypersurfaces
        @param self.dim: int, the dimension of the embedded projective space
        @param self.deg: an int, the degree of the hypersurfaces
        @param self.hyp_no: int, the number of hypersurfaces
        @return: Generates all walls/chambers and finds the destabilizing families, which then writes into distinct txt files, while discarding false walls/chambers
        """
        #if onepslist == None:
        #onepslist = OPS.ops_set(self.dim, self.deg, self.hyp_no)
        flag = [1000]
        r = self.hyp_no-1
        tden = self.deg * self.hyp_no / self.dim
        monomial_hypersurface = Monomial.monomials(self.dim, self.deg)
        monomial_hyperplane = Monomial.monomials(self.dim, 1)
        newflag = 1000
        allwalls = self.all_walls(onepslist) #generates all possible walls
        print('The number of walls is ', len(allwalls))
        allchambers = Problem.t_chambers(allwalls)  #generates all possible chambers
        maximal_dest_vm_walls = []
        maximal_dest_bm_walls = []
        if r > 1:
            maximal_dest_bm_walls = [[] for i in range(r)]
        maximal_dest_bhm_walls = []
        support_monomials_walls = []
        if r > 1:
            support_monomials_walls = [[] for i in range(r)]
        support_monomialsh_walls = []
        set_value = -10
        for i in range(len(allwalls)):
            if allwalls[i] == tden:
                set_value = i
        gamma_walls = []
        for wall in allwalls:  #generates the de-stabilizing families for each wall
            set_t = self.max_sets_t(onepslist, wall)
            maximal_dest_vm_walls.append(set_t[0])
            if r > 1:
                for i in range(r):
                    maximal_dest_bm_walls[i].append(set_t[1][i])
            else:
                maximal_dest_bm_walls.append(set_t[1])
            maximal_dest_bhm_walls.append(set_t[2])
            if r > 1:
                for i in range(r):
                    support_monomials_walls[i].append(set_t[3][i])
            else:
                support_monomials_walls.append(set_t[3])
            support_monomialsh_walls.append(set_t[4])
            gamma_walls.append(set_t[5])
        maximal_dest_vm_chambers = []
        maximal_dest_bm_chambers = []
        if r > 1:
            maximal_dest_bm_chambers = [[] for i in range(r)]
        maximal_dest_bhm_chambers = []
        support_monomials_chambers = []
        if r > 1:
            support_monomials_chambers = [[] for i in range(r)]
        support_monomialsh_chambers = []
        gamma_chambers = []
        for cham in allchambers:  #generates the de-stabilizing families for each chamber
            set_t = self.max_sets_t(onepslist, cham)
            maximal_dest_vm_chambers.append(set_t[0])
            if r > 1:
                for i in range(r):
                    maximal_dest_bm_chambers[i].append(set_t[1][i])
            else:
                maximal_dest_bm_chambers.append(set_t[1])
            maximal_dest_bhm_chambers.append(set_t[2])
            if r > 1:
                for i in range(r):
                    support_monomials_chambers[i].append(set_t[3][i])
            else:
                support_monomials_chambers.append(set_t[3])
            support_monomialsh_chambers.append(set_t[4])
            gamma_chambers.append(set_t[5])
        discarded_positions_walls = []
        discarded_positions_chambers = []
        if r > 1:
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
            if r > 1:
                for k in range(r):
                    maximal_dest_bm_walls[k][i] = flag
            else:
                maximal_dest_bm_walls[i] = flag
            maximal_dest_bhm_walls[i] = flag
            if r > 1:
                for k in range(r):
                    support_monomials_walls[k][i] = flag
            else:
                support_monomials_walls[i] = flag
            support_monomialsh_walls[i] = flag
            gamma_walls[i] = flag
        while flag in maximal_dest_vm_walls:
            maximal_dest_vm_walls.remove(flag)
        if r > 1:
            for k in range(r):
                while flag in maximal_dest_bm_walls[k]:
                    maximal_dest_bm_walls[k].remove(flag)
        else:
            while flag in maximal_dest_bm_walls:
                maximal_dest_bm_walls.remove(flag)
        while flag in maximal_dest_bhm_walls:
            maximal_dest_bhm_walls.remove(flag)
        if r > 1:
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
            if r > 1:
                for k in range(r):
                    maximal_dest_bm_chambers[k][j] = flag
            else:
                maximal_dest_bm_chambers[j] = flag
            maximal_dest_bhm_chambers[j] = flag
            if r > 1:
                for k in range(r):
                    support_monomials_chambers[k][j] = flag
            else:
                support_monomials_chambers[j] = flag
            support_monomialsh_chambers[j] = flag
            gamma_chambers[j] = flag
        while flag in maximal_dest_vm_chambers:
            maximal_dest_vm_chambers.remove(flag)
        if r > 1:
            for k in range(r):
                while flag in maximal_dest_bm_chambers[k]:
                    maximal_dest_bm_chambers[k].remove(flag)
        else:
            while flag in maximal_dest_bm_chambers:
                maximal_dest_bm_chambers.remove(flag)
        while flag in maximal_dest_bhm_chambers:
            maximal_dest_bhm_chambers.remove(flag)
        if r > 1:
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
        # with open("maximal_dest_vm_walls.txt", "wb") as fp:   #Pickling
        #     pickle.dump(maximal_dest_vm_walls, fp)
        # with open("maximal_dest_vm_chambers.txt", "wb") as fp:   #Pickling
        #     pickle.dump(maximal_dest_vm_chambers, fp)
        # with open("maximal_dest_bm_walls.txt", "wb") as fp:   #Pickling
        #     pickle.dump(maximal_dest_bm_walls, fp)
        # with open("maximal_dest_bm_chambers.txt", "wb") as fp:   #Pickling
        #     pickle.dump(maximal_dest_bm_chambers, fp)
        # with open("maximal_dest_bhm_walls.txt", "wb") as fp:   #Pickling
        #     pickle.dump(maximal_dest_bhm_walls, fp)
        # with open("maximal_dest_bhm_chambers.txt", "wb") as fp:   #Pickling
        #     pickle.dump(maximal_dest_bhm_chambers, fp)
        # with open("support_monomials_walls.txt", "wb") as fp:   #Pickling
        #     pickle.dump(support_monomials_walls, fp)
        # with open("support_monomials_chambers.txt", "wb") as fp:   #Pickling
        #     pickle.dump(support_monomials_chambers, fp)
        # with open("support_monomialsh_walls.txt", "wb") as fp:   #Pickling
        #     pickle.dump(support_monomialsh_walls, fp)
        # with open("support_monomialsh_chambers.txt", "wb") as fp:   #Pickling
        #     pickle.dump(support_monomialsh_chambers, fp)
        # with open("gamma_walls.txt", "wb") as fp:   #Pickling
        #     pickle.dump(gamma_walls, fp)
        # with open("gamma_chambers.txt", "wb") as fp:   #Pickling
        #     pickle.dump(gamma_chambers, fp)
        # with open("used_walls.txt", "wb") as fp:   #Pickling
        #     pickle.dump(used_walls, fp)
        # with open("used_chambers.txt", "wb") as fp:   #Pickling
        #     pickle.dump(used_chambers, fp) #todo maybe add return and not rely on pickle
        return [maximal_dest_vm_walls, maximal_dest_vm_chambers, maximal_dest_bm_walls, maximal_dest_bm_chambers, maximal_dest_bhm_walls, maximal_dest_bhm_chambers, support_monomials_walls, support_monomials_chambers, support_monomialsh_walls, support_monomialsh_chambers, gamma_walls, gamma_chambers, used_walls, used_chambers ]


    def max_sets_t(self, onepslist=None, t=0):
        """
        
        @param onepslist: a list of list of floats, corresponding to a list of one-parameter subgroups. DEFAULT: the list of one-parameter subgroups of given dimension and degree and number of hypersurfaces
        @param t: float, a wall/chamber
        @param monomial_list1: a list of list of floats, corresponding to a list of monomials in hypersurface. DEFAULT: the monomial list of given dimension and degree
        @param monomial_list2: a list of list of floats, corresponding to a list of monomials in hyperplane. DEFAULT: the monomial list of hyperplanes given dimension
        @param self.hyp_no: int, the number of hypersurfaces
        @return: a list containing all the destabilizing families with respect to the specific t
        """
        # monomial_list1 corresponds to monomials in hypersurface, monomial_list2 corresponds to monomials in hyperplane
        #onepslist = OPS.ops_set(self.dim, self.deg, self.hyp_no)
        if onepslist == None:
            onepslist = OPS.ops_set(self.dim, self.deg, self.hyp_no)
        monomial_list1 = Monomial.monomials(self.dim, self.deg)
        monomial_list2 = Monomial.monomials(self.dim, 1)
        flag = [1000]
        r = self.hyp_no-1
        mon_combins = monomial_list1
        if r > 1:
            mon_combins = list(itertools.combinations(monomial_list1, int(r)))
        maximal_dest_vmt = []
        maximal_dest_bmt = []
        if r > 1:
            maximal_dest_bmt = [[] for i in range(r)]
        maximal_dest_bhmt = []
        support_monomialst = []
        if r > 1:
            support_monomialst = [[] for i in range(r)]
        support_monomialsht = []
        gammat = []
        for gamma in onepslist:
            for moni in mon_combins: #maybe add here condition for k=1
                for monxj in monomial_list2: 
                    cond = hilbert_mumford(moni, monxj, gamma, monomial_list1, monomial_list2,self.dim, self.hyp_no, t)
                    if cond:
                        vm = cond[0]
                        bm = cond[1]
                        bhm = cond[2]
                    else:
                        continue
                    incl =  inclusion_condition(gamma, t, vm, bm, bhm, moni, monxj, self.hyp_no, maximal_dest_vmt, maximal_dest_bmt, maximal_dest_bhmt, support_monomialst, support_monomialsht, gammat) 
                    maximal_dest_vmt = incl[0]
                    maximal_dest_bmt = incl[1]
                    maximal_dest_bhmt  = incl[2]
                    support_monomialst = incl[3]
                    support_monomialsht  = incl[4]
                    gammat = incl[5] 
        for j in range(len(maximal_dest_vmt)):  #removes all extra elements not detected by method above - maybe also implement into seperate function?
            for k in range(len(maximal_dest_vmt)):
                test1 = all(elem in maximal_dest_vmt[j] for elem in maximal_dest_vmt[k])
                test2 = True
                if r == 1:
                    test2 = all(elem in maximal_dest_bmt[j] for elem in maximal_dest_bmt[k])
                if r > 1:
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
                    if r > 1:
                        for i in range(r):
                            maximal_dest_bmt[i][k] = flag
                    else:
                        maximal_dest_bmt[k] = flag
                    maximal_dest_bhmt[k] = flag
                    if r > 1:
                        for i in range(r):
                            support_monomialst[i][k] = flag
                    else:
                        support_monomialst[k] = flag
                    support_monomialsht[k] = flag
                    gammat[k] = flag
        while flag in maximal_dest_vmt:
            maximal_dest_vmt.remove(flag)
        if r > 1:
            for i in range(r):
                while flag in maximal_dest_bmt[i]:
                    maximal_dest_bmt[i].remove(flag)
        else:
            while flag in maximal_dest_bmt:
                maximal_dest_bmt.remove(flag)
        while flag in maximal_dest_bhmt:
            maximal_dest_bhmt.remove(flag)
        if r > 1:
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


