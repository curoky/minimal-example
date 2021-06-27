lib_LIBRARIES = libhello_static.a
libhello_static_a_SOURCES = hello-static.cc

lib_LTLIBRARIES = libhello_shared.la
libhello_shared_la_SOURCES = hello-shared.cc

bin_PROGRAMS = main
main_SOURCES = main.cc
#main_DEPENDENIES = libhello_static_a
main_LDADD = libhello_static.a libhello_shared.la
