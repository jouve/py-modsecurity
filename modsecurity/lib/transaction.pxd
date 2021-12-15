# distutils: language = c++
# distutils: libraries = modsecurity

from libcpp cimport bool
from libcpp.string cimport string

from .intervention cimport ModSecurityIntervention
from .modsecurity cimport ModSecurity
from .rules_set cimport RulesSet


cdef extern from "modsecurity/transaction.h" namespace "modsecurity":
    cdef cppclass Transaction:
        Transaction(ModSecurity *transaction, RulesSet *rules, void *logCbData)
        Transaction(ModSecurity *transaction, RulesSet *rules, char *id, void *logCbData)

        int processConnection(const char *client, int cPort, const char *server, int sPort)

        int processURI(const char *uri, const char *protocol, const char *http_version)

        int addRequestHeader(const string& key, const string& value)
        int processRequestHeaders()

        int appendRequestBody(const unsigned char *body, size_t size)
        int processRequestBody()

        int addResponseHeader(const string& key, const string& value)
        int processResponseHeaders(int code, const string& proto)

        int appendResponseBody(const unsigned char *body, size_t size)
        int processResponseBody()

        int processLogging()

        bool intervention(ModSecurityIntervention *it)
