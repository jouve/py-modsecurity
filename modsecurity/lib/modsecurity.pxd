# distutils: language = c++
# distutils: libraries = modsecurity

from libcpp.string cimport string

ctypedef void (*ModSecLogCb) (void *, const void *)

cdef extern from "modsecurity/modsecurity.h" namespace "modsecurity":
    cdef cppclass ModSecurity:
        ModSecurity() except +

        const string& whoAmI()

        void setServerLogCb(ModSecLogCb cb)

cdef class PyModSecurity:
    cdef ModSecurity modsecurity
