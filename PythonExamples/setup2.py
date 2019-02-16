from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
from Cython.Build import cythonize

#print("For this compilation to work the following line has to be commented out; #define abs(x) ((x) >= 0 ? (x) : -(x))")
import os
roptlib_root = os.path.dirname(os.getcwd())
subdir = lambda sub: os.path.join(roptlib_root, sub)
ext_modules = [Extension("PySparsePCA",
                     ["PySparsePCA.pyx"],
                     language='c++',
                         extra_compile_args=["-std=c++11", "-fPIC"],
                         extra_link_args=["-std=c++11", "-Wl,-rpath="+os.getcwd()],
                         libraries=["ropt"], library_dirs=[roptlib_root],
                         include_dirs=[roptlib_root, subdir("cwrapper/blas"),
                                                                     subdir("cwrapper/lapack"),
                                                                     subdir("Manifolds"),
                                                                     subdir("Manifolds/Stiefel"),
                                                                     subdir("Manifolds/Euclidean"),
                                                                     subdir("Problems"),
                                                                     subdir("/Solvers"),
                                                                     subdir("Problems/StieBrockett"),
                                                                     subdir("Others"),
                                                                subdir("test")]
                     )]

#setup(ext_modules=cythonize("PySparsePCA.pyx"))
setup(
  name = 'PySparsePCA',
  cmdclass = {'build_ext': build_ext},
  ext_modules = ext_modules
)