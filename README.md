# WeatherApp

## Building And Running The Project (Requirements)
* Swift 5.0+
* Xcode 11.5+
* iOS 13.0+

# Getting Started
If this is your first time encountering swift/ios development, please follow [the instructions](https://developer.apple.com/support/xcode/) to setup Xcode and Swift on your Mac.

## Setup Configs
* Open the project by double clicking the `WeatherApp.xcworkspace` file
```
// App Settings
APP_NAME = WeatherApp
PRODUCT_BUNDLE_IDENTIFIER = abozaid.WeatherApp

#targets:
* WeatherApp
* WeatherAppTests

```

# Build and or run application by doing:
* Select the build scheme which can be found right after the stop button on the top left of the IDE
* [Command(cmd)] + B - Build app
* [Command(cmd)] + R - Run app

## Architecture
This application uses the Model-View-ViewModel (refered to as MVVM) UI architecture,


## Structure

### SupportingFiles
- Group app shared fils, like appDelegate, Assets, Info.plist, ...etc

### Modules
- Include seperate modules, Network, Extensions, ...etc.

### Scenes
- Group of app scenes.
