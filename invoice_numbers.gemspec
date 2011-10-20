require 'rake'

Gem::Specification.new do |s|
  s.name             = 'invoice_numbers'
  s.version          = '0.0.2'

  s.authors          = [ 'Rob Scheepmaker' ]
  s.email            = 'rob@rscheepmaker.nl'
  s.date             = '2011-09-06'
  s.description      = 'Create sequences of uninterrupted invoice numbers'
  s.summary          = 'Create sequences of uninterrupted invoice numbers'
  s.extra_rdoc_files = [ 'README.rdoc' ]
  s.files            = FileList['lib/**/*.rb', 'test/**/*'].to_a
  s.rdoc_options     = ['--main', 'README.rdoc']
  s.require_paths    = ['lib']
  s.test_files       = FileList['test/*.rb'].to_a
  s.add_dependency             'activerecord', ['>= 0']
  s.add_development_dependency 'database_cleaner', ['>= 0']
end
