.. _installation-instructions:

==============
Installing lda
==============

lda requires Python (>= 3.6). The package should install successfully with::

    pip install ldafork


Installation from source
------------------------

Installing from source requires you to have installed the Python development
headers and a working C/C++ compiler. Under Debian-based operating systems,
which include Ubuntu, you can install all these requirements by issuing::

    sudo apt-get install build-essential python3-dev python3-setuptools \
                         python3-numpy

Before attempting a command such as ``python setup.py install`` you will need to run
Cython to generate the relevant C files::

    make cython
