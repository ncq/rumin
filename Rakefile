C_COMPILER = "clang"
TARGET = "rumin"
BUILD_DIR = "build"
INC_DIR = "runtime/mruby/include"

task :all => ["mruby", "build", "mtest"]
task :default => ["mruby", "build"]

task :mruby do
  sh "git clone https://github.com/mruby/mruby.git runtime"
  sh "cp mruby/config/build_config.rb runtime"
  sh "cd runtime && ruby ./minirake"
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
  sh "mkdir #{BUILD_DIR}"
  sh "#{C_COMPILER} -Iruntime/include src/rumin.c runtime/build/host/lib/libmruby.a -lm -lncursesw -ldl -lyaml -o #{BUILD_DIR}/#{TARGET}"
end

task :mtest do
  FileList["test/**/*_test.rb"].each do |i|
    sh "./runtime/bin/mruby #{i}"
  end
end
