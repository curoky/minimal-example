add_rules("mode.debug", "mode.release")

add_requires("fmt")
add_requires("boost")

target("main")
    set_kind("binary")
    add_packages("fmt")
    add_packages("boost")
    add_files("main.cc")
