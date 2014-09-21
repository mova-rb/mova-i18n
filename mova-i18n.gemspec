Gem::Specification.new do |spec|
  spec.name          = "mova-i18n"
  spec.version       = "0.1.0"
  spec.authors       = ["Andrii Malyshko"]
  spec.email         = ["mail@nashbridges.me"]
  spec.summary       = "Seamless migration from I18n to Mova"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/mova-rb/mova-i18n"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "i18n"
  spec.add_dependency "mova", "~> 0.1"
end
