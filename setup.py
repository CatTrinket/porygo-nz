import os

import setuptools


requires = [
    'pyramid >=1.7.3, <1.8',
    'pyramid_debugtoolbar >=3.0.5, <3.1',
    'pyramid_mako >=1.0.2, <1.1',
    'waitress==1.4.3'
]

setuptools.setup(
    name='porygo-nz',
    packages=setuptools.find_packages(),
    include_package_data=True,
    zip_safe=False,
    install_requires=requires,
    entry_points={'paste.app_factory': 'main = porygo_nz:main'}
)
