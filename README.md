# Sage-Complete-intersections
 SAGE code for VGIT quotients of complete intersections

Contains code for VGIT for complete intersections

The run file is completeintersections.sage. The user inserts the dimension,degree and number of hypersurfaces he wants for the VGIT quotient.

The file functions contains general functions for manipulating lists and testing conditions.

The file OPS_set.sage contains the function and method to calculate the fundamental set of one-parameter subgroup for given dimension,degree and number of hypersurfaces.

The file Walls.sage calculates the max destabilizing sets for each t individually.

The file Families.sage calculates the max destabilizing sets for all walls/chambers and discards the false walls.

The file Printout.sage contains a method for printing the max destabilizing sets and applies the centroid criterion.