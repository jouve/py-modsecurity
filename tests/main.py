import logging
from textwrap import dedent

from modsecurity import ModSecurity, RulesSet, Transaction


def main():
    logging.basicConfig(level=logging.DEBUG)

    modsecurity = ModSecurity()
    print(modsecurity.who_am_i())
    rules_set = RulesSet()
    rules_set.load(
        dedent(
            """\
        Include conf/modsecurity.conf
        Include conf/crs-setup.conf
        Include conf/rules/*.conf
        """
        )
    )

    transaction = Transaction(modsecurity, rules_set)

    print(
        'process_connection',
        transaction.process_connection('127.0.0.1', 80, '127.0.0.1', 8080),
    )
    print('=======>', transaction.intervention())

    print('process_uri', transaction.process_uri('http://localhost/foo.asa', 'GET', '1.0'))
    print('=======>', transaction.intervention())

    for key, value in {
        'user-agent': 'curl/7.74.0',
        'accept': '*/*',
        'content-length': 'zz',
        'Transfer-Encoding': 'yo',
        'x-spoe-redis': '758',
        'x-forwarded-for': '172.20.0.1',
    }.items():
        transaction.add_request_header(key, value)
        # print("add_request_header", res)
    print('process_request_headers', transaction.process_request_headers())
    print('=======>', transaction.intervention())

    print('append_request_body', transaction.append_request_body(b'-- SELECT 1;'))
    print('process_request_body', transaction.process_request_body())
    print('=======>', transaction.intervention())

    for key, value in {
        'host': 'localhost',
        'user-agent': 'curl/7.74.0',
        'accept': '*/*',
        'x-spoe-redis': '758',
        'x-forwarded-for': '172.20.0.1',
    }.items():
        transaction.add_response_header(key, value)
        # print("add_response_header", res)
    print(
        'process_response_headers',
        transaction.process_response_headers(200, 'HTTP/1.1'),
    )
    print('=======>', transaction.intervention())

    err = b' valid PostgreSQL result x\nUnable to connect to PostgreSQL server\n'
    print('append_response_body', transaction.append_response_body(err))
    print('process_response_body', transaction.process_response_body())
    print('=======>', transaction.intervention())

    print('process_logging', transaction.process_logging())


main()
