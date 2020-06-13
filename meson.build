project('quicknote', 'vala', 'c',
    version: '0.0.1')

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

conf_data = configuration_data({
    'NAME': meson.project_name(),
    'INSTALLDIR': join_paths(get_option('datadir'), 'applications'),
    'BIN': join_paths(get_option('prefix'), get_option('bindir'), '')  + meson.project_name()
})

configure_file(
    input: 'data/desktop/launcher.desktop.in',
    output: meson.project_name() + '.desktop',
    configuration: conf_data,
    install_dir: join_paths(get_option('datadir'), 'applications')
)

install_data('data/settings/com.github.moroen.quicknote.gschema.xml', install_dir: get_option('datadir') / 'glib-2.0' / 'schemas')
meson.add_install_script('meson_post_install.py')



sources = files('main.vala')

executable('quicknote', sources, gresources, dependencies: dependencies, install: true)