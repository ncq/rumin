require 'yard'

C_COMPILER = "gcc"
TARGET = "rumin"
BUILD_DIR = "build"
INC_DIR = "runtime/mruby/include"

task :all => ["mruby", "build", "mtest"]
task :default => ["mruby", "build"]

task :mruby do
  sh 'sh ./mruby.sh'
end

task :build => "rumin" do
  sh "cp -r mruby #{BUILD_DIR}/mruby"
  puts "done."
end

task :clean do
  puts "cleaning."
  sh "rm -fr #{BUILD_DIR}"
  sh "rm -fr runtime"
end

file "rumin" => ["src/rumin.c"] do |t|
  puts "building."
  sh "if test -e #{BUILD_DIR}; then echo '#{BUILD_DIR} directory is already exist. Now cleaning.'; rm -fr #{BUILD_DIR}/*; else mkdir #{BUILD_DIR}; fi"
  sh "#{C_COMPILER} -Iruntime/include src/rumin.c runtime/build/host/lib/libmruby.a -lm -lncursesw -ldl -lyaml -o #{BUILD_DIR}/#{TARGET}"
end

task :mtest do
  FileList["test/**/*_test.rb"].each do |i|
    sh "./runtime/bin/mruby #{i}"
  end
end

task :yardoc do
  sh "yardoc mruby"
  puts "done."
end
