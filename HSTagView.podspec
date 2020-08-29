#
# Be sure to run `pod lib lint HSTagView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HSTagView'
  s.version          = '0.1.0'
  s.summary          = 'A simple view to show clickable tags as rounded buttons'
  s.description      = 'A simple view to show clickable tags as rounded buttons'
  s.homepage         = 'https://github.com/hemant3370/HSTagView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hemant3370' => 'hemant3370@gmail.com' }
  s.source           = { :git => 'https://github.com/hemant3370/HSTagView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '13.0'
  s.source_files = 'HSTagView/Classes/**/*'
end
