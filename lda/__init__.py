import logging

import pbr.version

from lda.lda import LDA  # noqa
import lda.datasets  # noqa

__version__ = pbr.version.VersionInfo('ldafork').version_string()

logging.getLogger('lda').addHandler(logging.NullHandler())
