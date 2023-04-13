add_rules("mode.debug", "mode.release")

target("libhellostatic")
    set_kind("static")
    add_files("src/hello-static.cc")

target("libhelloshared")
    set_kind("shared")
    add_files("src/hello-shared.cc")

target("main")
    set_kind("binary")
    add_deps("libhellostatic")
    add_deps("libhelloshared")
    add_files("src/main.cc")
