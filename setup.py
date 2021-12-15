from pathlib import Path

from setuptools import setup

lib = Path('modsecurity/lib')
if any(lib.glob('*.pyx')):
    from Cython.Build import cythonize

    ext_modules = cythonize('modsecurity/lib/*.pyx', language_level=3)
else:
    from setuptools import Extension

    ext_modules = [
        Extension(
            str(cpp.with_suffix('')).replace('/', '.'),
            [str(cpp)],
            libraries=['modsecurity'],
        )
        for cpp in lib.glob('*.cpp')
    ]

setup(
    name='modsecurity',
    version='0.1.1',
    author='Cyril Jouve',
    author_email='jv.cyril@gmail.com',
    license='GPL-3.0-or-later',
    packages=['modsecurity'],
    ext_modules=ext_modules,
)
