from libcpp.string cimport string

from .intervention cimport ModSecurityIntervention, clean, free
from .modsecurity cimport ModSecurity, PyModSecurity
from .rules_set cimport PyRulesSet, RulesSet
from .transaction cimport Transaction


cdef decode_or_none(char* s):
    if s == NULL:
        return None
    return s.decode()

cdef class PyTransaction:
    cdef Transaction *transaction

    def __cinit__(self, PyModSecurity modsecurity, PyRulesSet rules_set):
        self.transaction = new Transaction(&(modsecurity.modsecurity), &(rules_set.rules_set), NULL)

    def __dealloc__(self):
        del self.transaction

    def process_connection(self, client, cPort: int, server, sPort: int):
        return self.transaction.processConnection(str(client).encode(), cPort, str(server).encode(), sPort)

    def process_uri(self, uri: str, protocol: str, http_version: str):
        return self.transaction.processURI(uri.encode(), protocol.encode(), http_version.encode())

    def add_request_header(self, key: str, value: str):
        return self.transaction.addRequestHeader(<string> key.encode(), <string> value.encode())

    def process_request_headers(self):
        return self.transaction.processRequestHeaders()

    def append_request_body(self, body: bytes):
        return self.transaction.appendRequestBody(body, len(body))

    def process_request_body(self):
        return self.transaction.processRequestBody()

    def add_response_header(self, key: str, value: str):
        return self.transaction.addResponseHeader(<string>key.encode(), <string>value.encode())

    def process_response_headers(self, code: int, proto: str):
        return self.transaction.processResponseHeaders(code, proto.encode())

    def append_response_body(self, body: bytes):
        return self.transaction.appendResponseBody(body, len(body))

    def process_response_body(self):
        return self.transaction.processResponseBody()

    def process_logging(self):
        return self.transaction.processLogging()

    def update_status_code(self, status: int):
        return self.transaction.updateStatusCode(status)

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
