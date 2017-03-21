# -*- ruby -*-
#
# Copyright (C) 2017 Kouhei Sutou <kou@clear-code.com>

task :default => :test

desc "Run test"
task :test => "mruby" do
  ENV["MRUBY_CONFIG"] = File.expand_path("config/test.rb")
  cd("mruby") do
    sh("rake", "test")
  end
end

desc "Clean"
task :clean => "mruby" do
  ENV["MRUBY_CONFIG"] = File.expand_path("config/test.rb")
  cd("mruby") do
    sh("rake", "clean")
  end
end

desc "Tag"
task :tag do
  /version = \"(.+?)\"/ =~ File.read("mrbgem.rake")
  version = $1
  sh("git", "tag", "-a", "-m", "#{version} has been released!!!", version)
  sh("git", "push", "--tags")
end
