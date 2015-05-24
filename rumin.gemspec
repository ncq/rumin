# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rumin/version'

Gem::Specification.new do |spec|
  spec.name          = "rumin"
  spec.version       = Rumin::VERSION
  spec.authors       = ["AIIT"]
  spec.email         = ["a1321km@aiit.ac.jp"]

  spec.summary       = %q{rumin is an extensible text editing platform implemented on Ruby.}
  spec.description   = %q{rumin is an extensible text editing platform implemented on Ruby. You can use rumin to writing text, source code and so on. We designed rumin instead of emacs and vim. So, if you want to writing text easily, you can use plug-in's or create a plug-in on your self.}
  spec.homepage      = "https://github.com/ncq/rumin"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #  raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
end
