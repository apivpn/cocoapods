Pod::Spec.new do |spec|
  spec.name         = "ApiVPN"
  spec.version      = "0.0.9"
  spec.summary      = "apiVPN SDK"
  spec.description  = <<-DESC
                      api:VPN White Label Solutions SDK
                      DESC
  spec.homepage     = "https://apivpn.io"
  spec.license      = { :type => 'MIT', :file => 'LICENSE.md' }
  spec.author    = "apiVPN"
  spec.swift_versions = "5.8"
  spec.ios.deployment_target = "12.1"
  spec.osx.deployment_target = "13.0"
  spec.source       = { :git => "https://github.com/apivpn/cocoapods.git", :tag => "#{spec.version}" }
  spec.source_files  = "ApiVPN/**/*.{swift,h}"
  spec.resources = ["ApiVPN/cacert.pem", "ApiVPN/geo.mmdb", "ApiVPN/site.dat"]
  spec.vendored_frameworks = "apivpncore.xcframework"
end
