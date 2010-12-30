Gem::Specification.new do |s|
  s.name              = "aleph"
  s.version           = "0.0.1"
  s.summary           = "Literate-programming HTML"
  s.authors           = ["Damian Janowski", "Michel Martens"]
  s.email             = ["djanowski@dimaion.com", "michel@soveran.com"]
  s.homepage          = "http://github.com/djanowski/aleph"

  s.files = ["Rakefile", "lib/aleph.rb", "aleph.gemspec", "test/aleph.rb", "test/binary.rb", "test/simple.html"]

  s.add_dependency "nokogiri", "~> 1.4"
  s.add_dependency "rdiscount", "~> 1.6"
end
