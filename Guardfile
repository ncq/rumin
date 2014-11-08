# A sample Guardfile
# More info at https://github.com/guard/guard#readme
guard :shell do
  watch(%r{test_*.rb$}) { |m| `./mtest.sh #{m[0]}` }
  watch(%r{^mruby/(.+)\.rb$})  { |m| `./mtest.sh test/mruby/#{m[1]}_test.rb` }
end
