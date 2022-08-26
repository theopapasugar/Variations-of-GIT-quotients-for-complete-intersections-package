# Variations of GIT quotients for complete intersections package

 SAGE code for VGIT quotients of complete intersections

Contains code for VGIT for complete intersections

The run file is completeintersections.sage. The user inserts the dimension, degree and number of hypersurfaces they want for the VGIT quotient.

The file functions contains general functions for manipulating lists and testing conditions such as the centroid criterion, which checks if a tuple is strictly semistable.

The file VGIT.sage contains the class Problem that contains the following: 

A function ops_set which calculates the fundamental set of one-parameter subgroup for given dimension,degree and number of hypersurfaces.

A function max_sets_t which calculates the max destabilizing sets for each wall t individually.

A function max_semi_dest_sets which calculates the max destabilizing sets for all walls/chambers using max_sets_t and discards the false walls.

A function printout which contains a method for printing the max destabilizing sets and applies the centroid criterion. In the case of a strictly semistable family it also generates the annihilator and prints it out.
