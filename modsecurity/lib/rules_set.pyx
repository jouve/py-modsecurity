import logging

from libcpp.string cimport string

from .rules_set cimport RulesSet

logger = logging.getLogger(__name__)


cdef class PyRulesSet:

    def dump(self):
        self.rules_set.dump()

    def load_from_uri(self, uri):
        if self.rules_set.loadFromUri(str(uri).encode()) == -1:
            raise Exception(self.rules_set.getParserError().decode())

    def load(self, rules):
        if self.rules_set.load(rules.encode()) == -1:
            raise Exception(self.rules_set.getParserError().decode())
