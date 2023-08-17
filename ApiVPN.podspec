Pod::Spec.new do |spec|
  spec.name         = "ApiVPN"
  spec.version      = "0.0.9"
  spec.summary      = "ApiVPN SDK."
  spec.description  = <<-DESC
                      ApiVPN SDK.
                      DESC
  spec.homepage     = "https://apivpn.io"
  spec.license      = "MIT"
  spec.author    = "apiVPN"
  spec.ios.deployment_target = "12.1"
  spec.osx.deployment_target = "13.0"
  spec.source       = { :git => "git@git.sly.team:apivpnsdk/apivpn-ios.git", :tag => "#{spec.version}" }
  spec.source_files  = "ApiVPN/**/*.{swift,h}"
  spec.resources = ["ApiVPN/cacert.pem", "ApiVPN/geo.mmdb", "ApiVPN/site.dat"]
  spec.vendored_frameworks = "apivpncore.xcframework"
end
