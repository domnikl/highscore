
begin
  require 'bones'
rescue LoadError
  abort '### Please install the "bones" gem ###'
end

task :default => 'test:run'
task 'gem:release' => 'test:run'

Bones {
  name     'highscore'
  authors  'Dominik Liebler'
  email    'liebler.dominik@googlemail.com'
  url      'http://thewebdev.de'
  ignore_file '.gitignore'
  depend_on 'fast-stemmer'
}
