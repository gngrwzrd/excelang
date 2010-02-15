require 'rubygems'
Gem::manage_gems
require 'rake/gempackagetask'
spec=Gem::Specification.new do |s|
  s.name="excelang"
  s.version="0.1"
  s.author="Aaron Smith"
  s.add_dependency("roo",">=1.2.3")
  s.add_dependency("hpricot",">=0.6.164")
  s.add_dependency("spreadsheet",">=0.6.3.1")
  s.homepage="http://excelang.codeendeavor.com/"
  s.date=Time.now
  s.email="beingthexemplary@gmail.com"
  s.bindir="bin"
  s.executables<<"excelang"
  s.summary="The langtrans gem reads an excel sheet, which contains translations from english to any other language, which is written to xml."
  s.description="The langtrans gem reads an excel sheet, which contains translations from english to any other language, which is written to xml."
  s.files=FileList['lib/**/*','bin/*'].to_a
  s.requirements<<"roo gem"
end
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar=true
end
task :default => "pkg/#{spec.name}-#{spec.version}.gem" do
  puts "generated latest version"
end