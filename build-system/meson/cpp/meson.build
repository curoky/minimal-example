project('hello world', 'cpp',
    default_options: 'default_library=static',
    version: '0.1.0')

libhello_shared = shared_library('libhello-shared', 'src/hello-shared.cc')
libhello_static = static_library('libhello-static', 'src/hello-static.cc')

executable('main', 'src/main.cc',
    link_with: [libhello_shared, libhello_static]
)
