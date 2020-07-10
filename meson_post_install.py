#!/usr/bin/env python3

import os
import subprocess
import sys

# argv[1]: Meson host_system
# argv[2]: Schema dir

# schemadir = os.path.join(os.environ['MESON_INSTALL_PREFIX'], 'share', 'glib-2.0', 'schemas')

if not os.environ.get('DESTDIR'):
    print('Compiling gsettings schemas...')
    subprocess.call(['glib-compile-schemas', sys.argv[2]])
    
    if sys.argv[1] == "linux":
        print('Updating desktop database...')
        subprocess.call(['update-desktop-database'])