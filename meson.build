project('hello', 'vala', 'c')

gnome = import('gnome')

dependencies = [
    dependency('glib-2.0'),
    dependency('gobject-2.0'),
    dependency('gtk+-3.0'),
    dependency('gmodule-2.0'),
]

gresources = gnome.compile_resources(
    meson.project_name() + '.resources',
    'data/gresources.xml',
    source_dir: ['data']
)

sources = files('main.vala')

executable('hello', sources, gresources, dependencies: dependencies)