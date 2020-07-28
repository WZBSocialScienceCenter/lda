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

3. Build Linux, MacOS and Windows wheels via AppVeyor.

3. Build windows wheels, place wheels in ``dist/``.

Windows wheels are built using appveyor, see ``continuous_integration/appveyor/``.
Once built they can be retrieved using ``continuous_integration/download_wheels.sh``.

4. Build macOS / OS X wheels, place wheels in ``dist/``.

macOS / OS X wheels are built via ``https://github.com/lda-project/lda-wheels``.
Put wheels in ``dist/``.

5. Build linux wheels, place wheels in ``dist/``.

Linux wheels are built via ``https://github.com/lda-project/lda-wheels``. Put
wheels in ``dist/``.

6. Upload and sign each wheel

``$ for fn in dist/*.whl; do twine upload -i D5493B3459D0858AB8CE06E44D811ED4C698940F --sign $fn; done``
