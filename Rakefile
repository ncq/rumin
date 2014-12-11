C_COMPILER = "clang"
TARGET = "rumin"
BUILD_DIR = "build"
INC_DIR = "runtime/mruby/include"

task :all => ["build"]
task :default => ["build"]

task :build => "rumin" do
	sh "cp -r mruby #{BUILD_DIR}/mruby"
	puts "done."
end

task :clean do
	puts "cleaning."
	sh "rm -fr #{BUILD_DIR}"
end

file "rumin" => ["src/rumin.c"] do |t|
	puts "building."
	sh "mkdir #{BUILD_DIR}"
	sh "#{C_COMPILER} -Iruntime/mruby/include src/rumin.c runtime/mruby/build/host/lib/libmruby.a -lm -lncursesw -ldl -lyaml -o #{BUILD_DIR}/#{TARGET}"
end

task :mtest do
  FileList["test/**/*_test.rb"].each do |i|
    sh "./run/bin/mruby #{i}"
  end
end
