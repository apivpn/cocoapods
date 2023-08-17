## Usage

The `apivpncore.xcframework` and the resource files `geo.mmdb`, `site.dat` are committed to the git repo in order for users to install the library via CocoaPods.

To update the core xcframework, please build it from `apivpn-core` and override `apivpncore.xcframework` in this repo.

To update the resource files, please run `download_assets.sh` and commit the updated resource files.

## Install the library via CocoaPods

To use the library via CocoaPods, you can include something similar to the following in your `Podfile`:

```
platform :ios, '12.1'

def common_pods
  pod 'ApiVPN', :git => 'git@git.sly.team:apivpnsdk/apivpn-ios.git', :tag => '0.0.2'
end

target 'apivpn-ios-example' do
  common_pods
end

target 'apiVPNTunnel' do
  common_pods
end
```
# cocoapods
# cocoapods
