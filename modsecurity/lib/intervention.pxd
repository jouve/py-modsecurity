# distutils: language = c++

cdef extern from "modsecurity/intervention.h" namespace "modsecurity":
    ctypedef struct ModSecurityIntervention:
        int status
        int pause
        char *url
        char *log
        int disruptive

cdef extern from "modsecurity/intervention.h" namespace "modsecurity::intervention":
    void clean(ModSecurityIntervention *i)
    void free(ModSecurityIntervention *i)
