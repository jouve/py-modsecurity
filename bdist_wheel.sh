#!/bin/bash

python3.10 -m venv /venv
/venv/bin/pip install wheel
/venv/bin/pip install cython
#/venv/bin/python setup.py sdist
/venv/bin/python setup.py bdist_wheel
#/venv/bin/pip wheel dist/modsecurity-*.tar.gz
auditwheel repair -w dist dist/modsecurity-*-cp310-cp310-linux_x86_64.whl 
rm dist/modsecurity-*-cp310-cp310-linux_x86_64.whl
/venv/bin/pip install dist/modsecurity-*-cp310-cp310-musllinux_1_1_x86_64.whl 
if [ -n "$UIDGID" ]; then
  chown -R "$UIDGID" *
fi
