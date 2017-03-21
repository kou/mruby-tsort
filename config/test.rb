MRuby::Build.new do |conf|
  toolchain :gcc

  enable_debug

  conf.gembox "default"
  conf.enable_test

  conf.gem :core => "mruby-hash-ext"
  conf.gem :core => "mruby-kernel-ext"
  conf.gem :core => "mruby-enumerator"
  conf.gem File.expand_path("..", File.dirname(__FILE__))
end
