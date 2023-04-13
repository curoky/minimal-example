add_rules("mode.debug", "mode.release")

add_requires("vcpkg::fmt")
add_requires("vcpkg::boost-algorithm")

target("main")
    set_kind("binary")
    add_packages("vcpkg::fmt")
    add_packages("vcpkg::boost-algorithm")
    add_files("main.cc")
