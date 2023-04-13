add_rules("mode.debug", "mode.release")

-- add_requires("conan::zlib/1.2.11@conan/stable", {alias = "zlib", debug = true})
-- add_requires("conan::openssl/1.1.1g", {alias = "openssl",
--     configs = {options = "OpenSSL:shared=True"}})
add_requires("conan::fmt/9.1.0", { configs = { build = "missing", build_requires = {} } })
add_requires("conan::boost/1.81.0", { configs = { build = "missing", build_requires = {} } })

target("main")
    set_kind("binary")
    add_packages("conan::fmt")
    add_packages("conan::boost")
    add_files("main.cc")
