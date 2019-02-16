
cdef extern from "TestSparsePCA.h":
    void testSparsePCA(double *B, double *Dsq, int p, int n, int r, double mu, double *X, double *Xopt);
