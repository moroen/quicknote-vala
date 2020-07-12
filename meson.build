project('quicknote', 'vala', 'c',
    version: '0.0.1')

executable_name = 'quicknote'

host_system = host_machine.system()

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

if host_system == 'linux'
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
endif

if host_system == 'windows'
    schemadir = join_paths(meson.current_build_dir(), 'share','glib-2.0', 'schemas')
    install_exe = false
else
    schemadir = join_paths(get_option('prefix'), get_option('datadir'), 'glib-2.0','schemas')
    install_exe = true
endif

install_data('data/settings/com.github.moroen.quicknote.gschema.xml', install_dir: schemadir)
meson.add_install_script('meson_post_install.py', host_system, schemadir)

sources = files('src/main.vala', 'src/note.vala')

executable(executable_name, sources, gresources, 
    dependencies: dependencies, 
    gui_app: true,
    install: install_exe)