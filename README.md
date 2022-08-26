# Variations of GIT quotients for complete intersections package

 SAGE code for VGIT quotients of complete intersections
 
This software package is a complement to the article "K-moduli for log Fano complete intersections". The software package implements a series of algorithms for the study of variations of Geometric Invariant Theory (VGIT) quotients of pairs formed by a complete intersection of k hypersurface in projective space of dimension n-1 and degree d and a hyperplane embedded in the same projective space. Given n, degree d, and number of hypersurfaces k, the code finds all relevant one-parameter subgroups which determine all the GIT quotients for these pairs. In addition, it finds a finite list of candidate 'walls' in the wall-chamber decomposition studied by Dolgachev-Hu and Thaddeus. Furthermore, for each prospective chamber and wall it finds all maximal orbits of non stable and strictly semistable pairs, as well as minimal closed orbits of strictly semistable pairs in terms of families of pairs defined by monomials with non-zero coefficients. Finally, it runs through all the list of prospective chambers and walls eliminating 'false walls' for which the GIT quotient is detected not to vary. It outputs the maximal orbits of non stable and strictly semistable pairs in each wall/chamber as a list of polynomials defined by monomials with non-zero coefficients, in a txt output file. Further details can be found at the article "K-moduli for log Fano complete intersections". 

The sotware package is implemented as a Sage 9.2 package. The program can be run directly from the Sage Shell (Windows) or from the terminal (Mac and Linux).

The run file is completeintersections.sage. The user inserts the dimension n, degree d and number of hypersurfaces k they want for the VGIT quotient. The user can also indicate if they want to study GIT problems with or without the hyperplane section, as well as GIT problems for specific walls/chambers.

The file functions contains general functions for manipulating lists and testing conditions such as the centroid criterion, which checks if a tuple is strictly semistable.

The file VGIT.sage contains the class Problem that contains the following: 

A function ops_set which calculates the fundamental set of one-parameter subgroup for given dimension,degree and number of hypersurfaces, as presented in the article "K-moduli for log Fano complete intersections".

A function max_sets_t which calculates the max destabilizing sets for each wall/chamber t individually.

A function max_semi_dest_sets which calculates the max destabilizing sets for all walls/chambers using max_sets_t and discards the false walls.

A function printout which contains a method for printing the max destabilizing sets and applies the centroid criterion. In the case of a strictly semistable family it also generates the minimal closed orbits of strictly semistable pairs and prints them all out as polynomials with non-zero coefficients.

The folder "Some Outputs" contains outputs of the code for the convenience of the user.
