# Copyright (C) 2017 Kouhei Sutou <kou@clear-code.com>

MRuby::Gem::Specification.new("mruby-tsort") do |spec|
  spec.license = "BSD-2-Clause"
  spec.authors = [
    "Kouhei Sutou",
    "Tanaka Akira",
  ]
  spec.version = "1.0.0"
  spec.add_dependency "mruby-hash-ext", :core => "mruby-hash-ext"
  spec.add_dependency "mruby-kernel-ext", :core => "mruby-kernel-ext"
  spec.add_dependency "mruby-enumerator", :core => "mruby-enumerator"
end
