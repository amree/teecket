Gem::Specification.new do |s|
  s.name = "teecket"
  s.version = "0.0.6"
  s.executables = "teecket"
  s.date = "2015-06-11"
  s.summary = "Search for flights fare in Malaysia"
  s.description = %(Search ticket's fare for all
                    major airlines in Malaysia at once)
  s.authors = ["Amree Zaid"]
  s.email = "mohd.amree@gmail.com"
  s.files = Dir.glob("{bin,lib}/**/*") + %w(README.md)
  s.homepage = "https://github.com/amree/teecket"
  s.license = "MIT"

  s.add_runtime_dependency "terminal-table", "~> 1.4", ">= 1.4.5"
  s.add_runtime_dependency "nokogiri", "~> 1.6", ">= 1.6.6.2"

  s.add_development_dependency "byebug", "~> 5.0", ">= 5.0.0"
end
