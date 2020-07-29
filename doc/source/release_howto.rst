==============================
 How to make a release of lda
==============================

Fingerprint of signing key is ``D5493B3459D0858AB8CE06E44D811ED4C698940F``.

Note that ``pbr`` requires tags to be signed for its version calculations.

1. Verify that the following chores are finished:

    - Tests pass.
    - Changes since last release are mentioned in ``doc/source/whats_new.rst``.
    - Signed tag for the current release exists.
      Run ``git tag -s -u D5493B3459D0858AB8CE06E44D811ED4C698940F <n.n.n>``.

2. Build source distribution.

     *A script in the repository, ``build_dist.sh`` will take care of these steps.*

     - Run ``git checkout <tag>`` to checkout the tree associated with the release.
     - Run ``make cython`` so sdist can find the Cython-generated c files.
     - Build source package with ``python setup.py sdist``.

3. Build Linux wheels via `manylinux <https://github.com/pypa/manylinux>`_ docker images (either locally or via Travis)

To install the docker images locally, run:

    docker pull quay.io/pypa/manylinux1_x86_64
    docker pull quay.io/pypa/manylinux1_i686

Then from the project root, run the following to generate manylinux1 wheels for 64 and 32 bit architectures:

    docker run --rm -e PLAT=manylinux1_x86_64 -v `pwd`:/io quay.io/pypa/manylinux1_x86_64 /io/build_wheels.sh
    docker run --rm -e PLAT=manylinux1_i686 -v `pwd`:/io quay.io/pypa/manylinux1_i686 /io/build_wheels.sh

To make life easier, run ``sudo build_manylinux_docker.sh`` which also sets the proper ownership for the resulting
files.

4. Build MacOS and Windows wheels via AppVeyor.

The built wheels are pushed to the GitHub releases page. They can be downloaded to the ``dist/`` folder via
``download_releases.py`` (make sure to install the dependencies from ``deploy-requirements.txt`` first).

5. Upload and sign each wheel

    for fn in dist/*.whl; do twine upload -i D5493B3459D0858AB8CE06E44D811ED4C698940F --sign $fn; done

