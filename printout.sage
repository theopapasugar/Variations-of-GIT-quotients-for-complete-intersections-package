def my_import(module_name, func_name='*'):
    import os
    os.system('sage --preparse ' + module_name + '.sage')
    os.system('mv ' + module_name + '.sage.py ' + module_name + '.py')

    from sage.misc.python import Python
    python = Python()
    python.eval('from ' + module_name + ' import ' + func_name, globals())

#my_import("functions")
#my_import("Monomials")
#my_import("OPS")
my_import("VGIT")


class Printout(Problem):
    """docstring for Printout"""
    def __init__(self, dim, deg, hyp_no):
        super().__init__(dim, deg, hyp_no)
        

    def printout(self):
        """

        @param onepslist:a list of list of floats, corresponding to a list of one-parameter subgroups. DEFAULT: the list of one-parameter subgroups of given dimension and degree and number of hypersurfaces
        @param self.dim: int, the dimension of the embedded projective space
        @param self.deg: an int, the degree of the hypersurfaces
        @param self.hyp_no: int, the number of hypersurfaces
        @return: Prints the destabilizing families for all walls/chambers in a txt file
        """
        onepslist = OPS.ops_set(self.dim, self.deg, self.hyp_no)
        r = self.hyp_no - 1
        d = self.dim + 1
        f = open("VGIT_output_intersections.txt", "a")
        print('Solving for complete intersection of degree',self.deg, 'and hyperplane section in P^', self.dim, file=f)
        fams = self.max_semi_dest_sets(onepslist)  #generates families
        maximal_dest_vm_walls = fams[0]
        maximal_dest_vm_chambers = fams[1]
        maximal_dest_bm_walls = fams[2]
        maximal_dest_bm_chambers = fams[3]
        maximal_dest_bhm_walls = fams[4]
        maximal_dest_bhm_chambers = fams[5]
        support_monomials_walls = fams[6]
        support_monomials_chambers = fams[7]
        support_monomialsh_walls = fams[8]
        support_monomialsh_chambers = fams[9]
        gamma_walls = fams[10]
        gamma_chambers = fams[11]
        used_walls = fams[12]
        used_chambers = fams[13]
        print('Found false walls', file=f)
        # with open("maximal_dest_vm_walls.txt", "rb") as fp:   #Unpickling
        #     maximal_dest_vm_walls = pickle.load(fp)
        # with open("maximal_dest_vm_chambers.txt", "rb") as fp:   #Unpickling
        #     maximal_dest_vm_chambers = pickle.load(fp)
        # with open("maximal_dest_bm_walls.txt", "rb") as fp:   #Unpickling
        #     maximal_dest_bm_walls = pickle.load(fp)
        # with open("maximal_dest_bm_chambers.txt", "rb") as fp:   #Unpickling
        #     maximal_dest_bm_chambers = pickle.load(fp)
        # with open("maximal_dest_bhm_walls.txt", "rb") as fp:   #Unpickling
        #     maximal_dest_bhm_walls = pickle.load(fp)
        # with open("maximal_dest_bhm_chambers.txt", "rb") as fp:   #Unpickling
        #     maximal_dest_bhm_chambers = pickle.load(fp)
        # with open("support_monomials_walls.txt", "rb") as fp:   #Unpickling
        #     support_monomials_walls = pickle.load(fp)
        # with open("support_monomials_chambers.txt", "rb") as fp:   #Unpickling
        #     support_monomials_chambers = pickle.load(fp)
        # with open("support_monomialsh_walls.txt", "rb") as fp:   #Unpickling
        #     support_monomialsh_walls = pickle.load(fp)
        # with open("support_monomialsh_chambers.txt", "rb") as fp:   #Unpickling
        #     support_monomialsh_chambers = pickle.load(fp)
        # with open("gamma_walls.txt", "rb") as fp:   #Unpickling
        #     gamma_walls = pickle.load(fp)
        # with open("gamma_chambers.txt", "rb") as fp:   #Unpickling
        #     gamma_chambers = pickle.load(fp)
        # with open("used_walls.txt", "rb") as fp:   #Unpickling
        #     used_walls = pickle.load(fp)
        # with open("used_chambers.txt", "rb") as fp:   #Unpickling
        #     used_chambers = pickle.load(fp)
        print('The walls are', used_walls, file=f)
        print('The chambers are', used_chambers, file=f)
        tl = var('x', n=d)
        for i in range(len(maximal_dest_vm_walls)): # possibly make lines 393-461 into a single function 
            print('Solving for wall', used_walls[i], file=f)
            for j in range(len(maximal_dest_vm_walls[i])):
                max_dest_bm_walls_needed = [] 
                if r > 1:
                    max_dest_bm_walls_needed = [0 for el in range(r)]
                    for k in range(r):
                        max_dest_bm_walls_needed[k] = maximal_dest_bm_walls[k][i][j]
                else:
                    max_dest_bm_walls_needed = maximal_dest_bm_walls[i][j] #maybe include special condition for wall = 0
                equations = []
                if used_walls[i] == 0:
                    equations = printer(maximal_dest_vm_walls[i][j], max_dest_bm_walls_needed, [], used_walls[i], self.dim, self.hyp_no)
                if used_walls[i] > 0:
                    equations = printer(maximal_dest_vm_walls[i][j], max_dest_bm_walls_needed, maximal_dest_bhm_walls[i][j], used_walls[i], self.dim, self.hyp_no)
                eq_sum_v = equations[0]
                eq_sum_b = equations[1]
                eq_sum_bh = equations[2]
                print('Case', j+1, file=f)
                print('V^- = ', eq_sum_v, file=f)
                if r > 1:
                    print('The B^- are:', file=f)
                    for m in range(r):
                        print(m, file=f)
                        print(eq_sum_b[m], file=f)
                elif r == 1:
                    print('B^- = ', eq_sum_b, file=f)
                if used_walls[i] > 0:
                    print('Hyperplane B^- = ', eq_sum_bh, file=f)
                if r > 1:
                    print('Support monomials for the hypersurfaces: ', file=f)
                    for m in range(r):
                        print(m, file=f)
                        print(support_monomials_walls[m][i][j], file=f)
                elif r == 1:
                    print('Support monomial hypersurface: ', support_monomials_walls[i][j], file=f)
                if used_walls[i] > 0:
                    print('Support monomial hyperplane: ', support_monomialsh_walls[i][j], file=f)
                print('1-ps: ', gamma_walls[i][j], file=f)
                #fix identation here!
                if centroid_criterion(maximal_dest_vm_walls[i][j], max_dest_bm_walls_needed, maximal_dest_bhm_walls[i][j], used_walls[i], gamma_walls[i][j], self.dim, self.deg, self.hyp_no):  #checks if strictly semistable
                    print('This is a strictly t-semistable family', file=f)
                    an = []
                    if used_walls[i] == 0:
                        an = annihilator(maximal_dest_vm_walls[i][j], [], max_dest_bm_walls_needed, gamma_walls[i][j], used_walls[i], self.dim, self.hyp_no)
                    if used_walls[i] > 0:
                        an = annihilator(maximal_dest_vm_walls[i][j], maximal_dest_bhm_walls[i][j], max_dest_bm_walls_needed, gamma_walls[i][j], used_walls[i], self.dim, self.hyp_no)
                    vm0 = an[0]
                    bm0 = an[1]
                    bhm0 = an[2]
                    pr = printer(vm0, bm0, bhm0, used_walls[i], self.dim, self.hyp_no)
                    eq_sum_v0 = pr[0]
                    eq_sum_b0 = pr[1]
                    eq_sum_bh0 = pr[2] 
                    print('Potential closed orbit', file=f)
                    print('V^0 = ', eq_sum_v0, file=f)
                    if r > 0:
                        print('The B^0 are: ', file=f)
                        for m in range(r):
                            print(eq_sum_b0[m], file=f)
                    elif r == 1:
                        print('The B^0 is: ', file=f)
                        print(eq_sum_b0, file=f)
                    if used_walls[i] > 0:
                        print('B^0_h = ', eq_sum_bh0, file=f)
                    print('#######################################################', file=f)
                else:
                    print('Not strictly t-semistable', file=f)
                    print('#######################################################', file=f)
        for i in range(len(maximal_dest_vm_chambers)):
            print('Solving for chamber', used_chambers[i], file=f)
            for j in range(len(maximal_dest_vm_chambers[i])):
                if r > 1:
                    max_dest_bm_chambers_needed = [0 for el in range(r)]
                    for k in range(r):
                        max_dest_bm_chambers_needed[k] = maximal_dest_bm_chambers[k][i][j]
                else:
                    max_dest_bm_chambers_needed = maximal_dest_bm_chambers[i][j]
                equations = printer(maximal_dest_vm_chambers[i][j], max_dest_bm_chambers_needed, maximal_dest_bhm_chambers[i][j], used_chambers[i], self.dim, self.hyp_no)
                eq_sum_v = equations[0]
                eq_sum_b = equations[1]
                eq_sum_bh = equations[2]
                print('Case', j+1, file=f)
                print('V^- = ', eq_sum_v, file=f)
                if r > 1:
                    print('The B^- are:', file=f)
                    for m in range(r):
                        print(m, file=f)
                        print(eq_sum_b[m], file=f)
                else:
                    print('B^- = ', eq_sum_b, file=f)
                print('Hyperplane B^- = ', eq_sum_bh, file=f)
                if r > 1:
                    print('Support monomials for the hypersurfaces: ', file=f)
                    for m in range(r):
                        print(m, file=f)
                        print(support_monomials_chambers[m][i][j], file=f)
                elif r == 1:
                    print('Support monomial hypersurface: ', support_monomials_chambers[i][j], file=f)
                print('Support monomial hyperplane: ', support_monomialsh_chambers[i][j], file=f)
                print('1-ps: ', gamma_chambers[i][j], file=f)
                if centroid_criterion(maximal_dest_vm_chambers[i][j], max_dest_bm_chambers_needed, maximal_dest_bhm_chambers[i][j], used_chambers[i], gamma_chambers[i][j], self.dim, self.deg, self.hyp_no):
                    print('This is a strictly t-semistable family', file=f)
                    an = annihilator(maximal_dest_vm_chambers[i][j], maximal_dest_bhm_chambers[i][j], max_dest_bm_chambers_needed, gamma_chambers[i][j], used_chambers[i], self.dim, self.hyp_no)
                    vm0 = an[0]
                    bm0 = an[1]
                    bhm0 = an[2]
                    pr = printer(vm0, bm0, bhm0, used_chambers[i], self.dim, self.hyp_no)
                    eq_sum_v0 = pr[0]
                    eq_sum_b0 = pr[1]
                    eq_sum_bh0 = pr[2]
                    print('Potential closed orbit', file=f)
                    print('V^0 = ', eq_sum_v0, file=f)
                    if r > 1:
                        print('The B^0 are: ', file=f)
                        for m in range(r):
                            print(m, file=f)
                            print(eq_sum_b0[m], file=f)
                    elif r == 1:
                        print('B^0: ', file=f)
                        print(eq_sum_b0, file=f)
                    print('B^0_h = ', eq_sum_bh0, file=f)
                    print('#######################################################', file=f)
                else:
                    print('Not strictly t-semistable', file=f)
                    print('#######################################################', file=f)
        f.close()


    def printout_wall(self, onepslist, wall=0): #incorporate functions in functions 
        r = self.hyp_no-1
        d = self.dim+1
        tl = var('x', n=d)
        f = open("wall_output_intersections.txt", "a")
        print('Solving problem in P^', self.dim, ' degree ', self.deg, ' and ', self.hyp_no, ' hypersurfaces for wall t=', wall, file=f)
        #params = Problem(self)
        opset = onepslist
        #fix how this is called to generate these things
        families = self.max_sets_t(opset, wall)
        vms = families[0]
        if r > 1:
            bms = [0 for i in range(r)]
            for i in range(r):
                bms[i] = families[1][i]
        else:
            bms = families[1]
        bhms = []
        if wall != 0:
            bhms = families[2]
        if r > 1:
            supp_mons = [0 for i in range(r)]
            for i in range(r):
                supp_mons[i] = families[3][i]
        else:
            supp_mons = families[3]
        supp_mons_h = families[4]    
        gammas = families[5]
        for i in range(len(vms)):
            bms_needed = []
            if r > 1:
                bms_needed = [0 for i in range(r)]
                for m in range(r):
                    bms_needed[m] = bms[m][i]
            else:
                bms_needed = bms[i]
            equations = []
            if wall == 0:
                equations = printer(vms[i], bms_needed, [], wall, self.dim, self.hyp_no)
            if wall > 0:
                equations = printer(vms[i], bms_needed, bhms[i], wall, self.dim, self.hyp_no)
            eq_sum_v = equations[0]
            eq_sum_b = equations[1]
            eq_sum_bh = equations[2]
            print('Family', i, file=f)
            print('Vm:', file=f)
            print(eq_sum_v, file=f)
            if r > 1:
                print('The Bms are:', file=f)
                for k in range(r):
                    print(k, file=f)
                    print(eq_sum_b[k], file=f)
            elif r == 1:
                print('Bms:', file=f)
                print(eq_sum_b, file=f)
            if wall != 0:
                print('Bhm:', file=f)
                print(eq_sum_bh, file=f)
                print('Support monomial hyperplane', file=f)
                print(supp_mons[i], file=f)    
            if r > 1:
                for m in range(r):
                    print('Support monomial', m, file=f)
                    print(supp_mons[m][i], file=f)
            elif r == 1:
                print('Support monomial', file=f)
                print(supp_mons[i], file=f)
            print('One-parameter subgroup:', file=f)
            print(gammas[i], file=f)
            print('##############################', file=f)
                #add if centroid crit + generate annihilator
            if centroid_criterion(vms[i], bms_needed, bhms, wall, gammas[i], self.dim, self.deg, self.hyp_no):
                print('This is a strictly semistable family', file=f)
                an = []
                if wall == 0:
                    an = annihilator(vms[i], [], bms_needed, gammas[i], wall, self.dim, self.hyp_no)
                if wall > 0:
                    an = annihilator(vms[i], bhms[i], bms_needed, gammas[i], wall, self.dim, self.hyp_no)
                vm0 = an[0]
                bm0 = an[1]
                bhm0 = an[2]
                pr = printer(vm0, bm0, bhm0, wall, self.dim, self.hyp_no)
                eq_sum_v0 = pr[0]
                eq_sum_b0 = pr[1]
                eq_sum_bh0 = pr[2] 
                print('Potential closed orbit', file=f)
                print('V^0 = ', eq_sum_v0, file=f)
                if r > 1:
                    print('The B^0 are: ', file=f)
                    for m in range(r):
                        print(m, file=f)
                        print(eq_sum_b0[m], file=f) 
                elif r == 1:
                    print('B^0 = ', eq_sum_b0, file=f)
                if wall != 0:
                    print('B^0_h = ', eq_sum_bh0, file=f)
                print('#######################################################', file=f)
            else:
                print('Not strictly t-semistable', file=f)
                print('#######################################################', file=f)