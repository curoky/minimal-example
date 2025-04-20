# Copyright (c) 2018-2024 curoky(cccuroky@gmail.com).
#
# This file is part of minimal-example.
# See https://github.com/curoky/minimal-example for further info.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
load("@com_justbuchanan_rules_qt//:qt.bzl", "qt_cc_library", "qt_ui_library")
load("@rules_cc//cc:defs.bzl", "cc_binary")

qt_cc_library(
    name = "mainwindow",
    srcs = ["mainwindow.cpp"],
    hdrs = ["mainwindow.h"],
    deps = [
        ":mainwindow_ui",
        "@qt//:qt_widgets",
    ],
)

qt_ui_library(
    name = "mainwindow_ui",
    ui = "mainwindow.ui",
    deps = [
        "@qt//:qt_core",
        "@qt//:qt_widgets",
    ],
)

cc_binary(
    name = "main",
    srcs = ["main.cpp"],
    copts = ["-fpic"],
    deps = [
        ":mainwindow",
        "@qt//:qt_widgets",
    ],
)
