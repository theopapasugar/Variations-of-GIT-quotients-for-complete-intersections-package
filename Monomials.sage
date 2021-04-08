#include imports etc here

class Original(tuple):
    r"""
    Wrapper class of tuple, contains basic functions to use with tuples.

    EXAMPLES:

        sage: test1 = Original([1, 2, 3, 4])
        sage: test1
        (1, 2, 3, 4)

    """

    def __init(self, data):
        self = tuple(data)

    def dot_product(self, other):
        r"""
        Return the dot product of list1 and list2.

        INPUT:

        - ``self`` -- list/ tuple; contains floats or ints

        - ``other`` -- list/ tuple; contains floats or ints

        OUTPUT: the dot product as a fraction or int

        EXAMPLES:

        This example illustrates a basic dot product ::

            sage: test1 = Original([1, 2, 3, 4]); test2 = Original([5, 6, 7, 8])
            sage: test1.dot_product(test2)
            70

        We now compute a dot product that is a fraction ::

            sage: test1 = Original([1, 2, 3, 4]); test2 = Original([1.3, 3.5, 2.7])
            sage: test1.dot_product(test2)
            163/60

        """
        return sum([self[i] * other[i] for i in range(len(self))])

    
    def __add__(self, other):
        r"""
        Return the sum of two monomials.

        INPUT:

        - ``self`` -- Original; contains floats or ints

        - ``other`` -- Original; contains floats or ints

        OUTPUT: the list of the sum of the elements

        EXAMPLES:

        This example illustrates a basic operations ::

            sage: test1 = Original([1, 2, 3, 4]); test2 = Original([5, 6, 7, 8])
            sage: test1 + test2
            [6, 8, 10, 12]

        """
        return [a+b for a, b in zip(self, other)]
    
    
    def __sub__(self, other):
        r"""
        Return the subtraction of two monomials.

        INPUT:

        - ``self`` -- Original; contains floats or ints

        - ``other`` -- Original; contains floats or ints

        OUTPUT: the list of the subtraction of the elements

        EXAMPLES:

        This example illustrates a basic operations ::

            sage: test1 = Original([1, 2, 3, 4]); test2 = Original([5, 6, 7, 8])
            sage: test1 - test2
            [-4, -4, -4, -4]

        """
        return [a-b for a, b in zip(self, other)]



class Monomial(Original):
    r"""
    Wrapper class of Original, contains basic functions to use with Monomial.

    EXAMPLES:

        sage: test1 = Monomial([1, 2, 3, 4])
        sage: test1
        (1, 2, 3, 4)

    """
    def __init__(self, data):
        self = Original(data)

    def gamma_bigger_e(self, other, gamma): #runs as mon1.gaama_bigger_e(mon2, gamma),
        r"""
        Return True or False if other is bigger in the monomial order than self.

        INPUT:

        - ``self`` -- Monomial; contains ints, corresponding to a monomial

        - ``other`` -- Mononomial; contains ints, corresponding to a monomial
        
        - ``gamma`` -- list; contains ints, corresponding to a one-parameter subgroup.


        OUTPUT: True or False

        EXAMPLES:

        This example illustrates a monomial which is bigger or equal with respect to the order for specific one-parameter subgroup [1, 1, -1, -1] ::

            sage: ops = [1, 1, -1, -1]; mon1 = Monomial([2, 0, 0, 0]); mon2 = Monomial([0, 2, 0, 0])
            sage: mon2.gamma_bigger_e(mon1, ops)
            True

        This example illustrates a monomial which is not bigger or equal with respect to the order for specific one-parameter subgroup [1, 1, -1, -1] ::

            sage: ops = [1, 1, -1, -1]; mon1 = Monomial([2, 0, 0, 0]); mon2 = Monomial([0, 1, 0, 1])
            sage: mon1.gamma_bigger_e(self, ops)
            False

        Any monomial is bigger or equal than itself ::

            sage: ops = [1, 1, -1, -1]; mon1 = [2, 0, 0, 0]
            sage: mon1.gamma_bigger_e(mon1, ops)
            True

        """
        prod1 = self.dot_product( gamma)
        prod2 = other.dot_product(gamma)
        if prod1 != prod2:
            return prod1 < prod2
        else:
            return self <= other
        

    def to_the_power(self, list1):
        r"""
        Return the powers of elements of list1 with respect to the elements of self.

        INPUT:

        - ``self`` -- Monomial; contains floats or ints

        - ``list1`` -- list; contains floats or ints

        OUTPUT: the list of raised powers

        EXAMPLES:

        This example illustrates a basic operations ::

            sage: test1 = Monomial([1, 2, 3, 4]); test2 = [5, 6, 7, 8]
            sage: test1.to_the_power(test2)
            [1, 64, 2187, 65536]

        This also works with symbols ::

            sage: test1 = Monomial([1, 2, 3, 4]); x = var('x', n=4)
            sage: test1.to_the_power(x)
            [x0, x1^2, x2^3, x3^4]

        """
        return [a ** b for a, b in zip(list1, self)]


    @staticmethod
    def monomials(dimension, degree):
        r"""
        Return the homogeneous monomials of degree d in dimension `n`.

        INPUT:

        - ``dimension`` -- int; the dimension of the embeded projective space

        - ``degree`` -- int; the degree of the hypersurfaces


        OUTPUT: a list of lists containing the homogeneous monomials of degree d in dimension n.

        EXAMPLES:

        This example illustrates the construction of monomials of dimension 2 and degree 3 ::

            sage: Monomial.monomials(2,3)
            [[0, 0, 3],
            [0, 1, 2],
            [1, 0, 2],
            [0, 2, 1],
            [1, 1, 1],
            [2, 0, 1],
            [0, 3, 0],
            [1, 2, 0],
            [2, 1, 0],
            [3, 0, 0]]

        It is wrong to not input integer values dimension and degree ::

            sage: Monomial.monomials(3, 2.5)
            Traceback (most recent call last):
            ...
            TypeError: unsupported operand parent(s) for //: 'Real Field with 53 bits of precision' and 'Real Field with 53 bits of precision'

        """
        l = list(WeightedIntegerVectors(degree, [1 for i in range(dimension + 1)]))
        return  [Monomial(el) for el in l]




