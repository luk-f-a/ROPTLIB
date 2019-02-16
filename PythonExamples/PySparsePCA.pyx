# distutils: language = c++

import numpy as np
from libropt cimport testSparsePCA



cdef class PySparsePCA:
    """
    Solves the problem \min_{diag(X^T X) = I_r} \mu \|A^T X X^T A - D^2\|_F^2
    Because this class follows Scikit-Learn estimator interface, X is the data matrix.
    A \in R^{p \times r}, X \in R^{p \times n}. A is a loading matrix. p > n > r.

    ROPTLIB's original implementation solves
    \min_{diag(X^T X) = I_r} \mu \|X^T B B^T X - D^2\|_F^2
    which means that X has a different meaning in ROPTLIB's code.

    mu:
    """

    def __init(self, Dsq, mu, p, A_0=None):
        self._Dsq = Dsq
        self._mu = mu
        assert Dsq.shape[0]==Dsq.shape[1]
        self._r = Dsq.shape[0]
        self._p = p
        if A_0 is not None:
            assert p == A_0.shape[0]
            assert self._r == A_0.shape[1]
        else:
            self._A = np.zeros((p,self._r))
        self.Aopt = None

    def fit(self, X, y):
        """
        X: data matrix
        :return:
        """
        p, n = X.shape[0], X.shape[1]
        assert p == self._p
        # out will be passed to ROPTLIB to be modified in place with the result
        out = np.zeros(p*self._r)
        cdef double[::1] arr_out = out
        # a memory view is created on X to be able to pass the pointer
        X = X.reshape((p*n), order="F")
        cdef double[::1] arr_X = X
        D = self._Dsq.reshape((self._r**2,), order="F")
        cdef double[::1] arr_D = D
        cdef double[::1] arr_A = self._A.reshape((p*self._r,), order="F")
        testSparsePCA(&arr_X[0], &arr_D[0], p, n, self._r, self._mu, &arr_A[0], &arr_out[0])
        self.Aopt = np.array(arr_out)
        return self