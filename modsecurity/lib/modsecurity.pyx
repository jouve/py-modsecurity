import logging

from .modsecurity cimport ModSecLogCb, ModSecurity

logger = logging.getLogger(__name__)

cdef void server_log_cb(void *data, const void *ruleMessage):
    logger.debug('%s', (<char*>ruleMessage).decode())

cdef class PyModSecurity:

    def __cinit__(self):
        self.modsecurity.setServerLogCb(server_log_cb)

    def who_am_i(self):
        return self.modsecurity.whoAmI().decode()
