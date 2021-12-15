from libcpp.string cimport string

from .intervention cimport ModSecurityIntervention, clean, free
from .modsecurity cimport ModSecurity, PyModSecurity
from .rules_set cimport PyRulesSet, RulesSet
from .transaction cimport Transaction


cdef decode_or_none(char* s):
    if s == NULL:
        return None
    return s.decode(errors='replace')

cdef class PyTransaction:
    cdef Transaction *transaction

    def __cinit__(self, PyModSecurity modsecurity, PyRulesSet rules_set):
        self.transaction = new Transaction(&(modsecurity.modsecurity), &(rules_set.rules_set), NULL)

    def __dealloc__(self):
        del self.transaction

    def process_connection(self, client: bytes, cPort: int, server: bytes, sPort: int):
        return self.transaction.processConnection(client, cPort, server, sPort)

    def process_uri(self, uri: bytes, protocol: bytes, http_version: bytes):
        return self.transaction.processURI(uri, protocol, http_version)

    def add_request_header(self, key: bytes, value: bytes):
        return self.transaction.addRequestHeader(key, value)

    def process_request_headers(self):
        return self.transaction.processRequestHeaders()

    def append_request_body(self, body: bytes):
        return self.transaction.appendRequestBody(body, len(body))

    def process_request_body(self):
        return self.transaction.processRequestBody()

    def add_response_header(self, key: bytes, value: bytes):
        return self.transaction.addResponseHeader(key, value)

    def process_response_headers(self, code: int, proto: bytes):
        return self.transaction.processResponseHeaders(code, proto)

    def append_response_body(self, body: bytes):
        return self.transaction.appendResponseBody(body, len(body))

    def process_response_body(self):
        return self.transaction.processResponseBody()

    def process_logging(self):
        return self.transaction.processLogging()

    def intervention(self):
        cdef ModSecurityIntervention intervention
        clean(&intervention)
        retval = self.transaction.intervention(&intervention)
        if not retval:
            return None
        url = decode_or_none(intervention.url)
        log = decode_or_none(intervention.log)
        free(&intervention)
        return intervention.status, intervention.pause, url, log
