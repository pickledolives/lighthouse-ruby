require_relative 'lib/lighthouse/ruby/version'

Gem::Specification.new do |spec|
  spec.name          = "lighthouse-ruby"
  spec.version       = Lighthouse::Ruby::VERSION
  spec.authors       = ["Budi Sugianto"]
  spec.email         = ["budi@teachable.com"]

  spec.summary       = <<~DESC
    Ruby wrapper for lighthouse-cli command by 
    execute and evaluate for Lighthouse-cli test JSON report
    ~ inspired from lighthouse-matchers gem by Ackama Group ~
  DESC

  spec.description   = "Ruby wrapper for lighthouse-cli"
  spec.homepage      = "https://github.com/UseFedora/lighthouse-ruby"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"]    = "https://github.com/UseFedora/lighthouse-ruby"
  spec.metadata["source_code_uri"] = "https://github.com/UseFedora/lighthouse-ruby"
  spec.metadata["changelog_uri"]   = "https://github.com/UseFedora/lighthouse-ruby/blob/master/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "rspec", "~> 3"
end
