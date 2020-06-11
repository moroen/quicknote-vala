project('quicknote', 'vala', 'c')

gnome = import('gnome')

dependencies = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('gtk+-3.0'),
    dependency('gmodule-2.0'),
]

gresources = gnome.compile_resources(
    meson.project_name() + '.resources',
    'data/resources.gresources.xml',
    source_dir: ['data']
)

install_data('data/settings/com.github.moroen.quicknote.gschema.xml', install_dir: get_option('datadir') / 'glib-2.0' / 'schemas')
meson.add_install_script('meson_post_install.py')

sources = files('main.vala')

executable('quicknote', sources, gresources, dependencies: dependencies)