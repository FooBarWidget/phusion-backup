Gem::Specification.new do |s|
	s.name = "phusion-backup"
	s.version = "1.0.0"
	s.authors = ["Hongli Lai"]
	s.date = "2011-03-30"
	s.description = "Simple backup tool utilizing rdiff-backup."
	s.summary = "Simple backup tool utilizing rdiff-backup."
	s.email = "hongli@phusion.nl"
	s.files = Dir[
		"LICENSE.TXT",
		"phusion-backup.gemspec",
		"bin/*",
		"resources/*"
	]
	s.homepage = "https://github.com/FooBarWidget/crash-watch"
	s.rdoc_options = ["--charset=UTF-8"]
	s.executables = ["phusion-backup"]
	s.require_paths = ["lib"]
end

