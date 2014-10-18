C_COMPILER = "clang"
TARGET = "rumin"
TARGET_DIR = "build"
INC_DIR = "runtime/mruby/include"

task :all => ["build"]
task :default => ["build"]

task :build => "rumin" do
	puts "done."
end

task :clean do
	puts "cleaning."
	sh "rm -fr build"
end

file "rumin" => ["src/rumin.c"] do |t|
	puts "building."
	sh "mkdir build"
	sh "gcc -Iruntime/mruby/include -Iruntime/mruby/src src/rumin.c runtime/mruby/build/host/lib/libmruby.a -lm -lncurses -o #{TARGET_DIR}/#{TARGET}"
end

