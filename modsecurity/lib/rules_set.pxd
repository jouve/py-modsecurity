# distutils: language = c++
# distutils: libraries = modsecurity

from libcpp.string cimport string


cdef extern from "modsecurity/rules_set.h" namespace "modsecurity":
    cdef cppclass RulesSet:
        RulesSet() except +

        int loadFromUri(const char *uri)
        int load(const char *rules)

        void dump()

        string getParserError()

cdef class PyRulesSet:
    cdef RulesSet rules_set
