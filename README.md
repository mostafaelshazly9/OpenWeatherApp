# OpenWeatherApp

This is an app that shows you the current weather and the forecast of weather in any city.
It allows you to search using city name, zip code or lat/lon coordinates.

Technologies used:
<br>
Swift
<br>
SwiftUI
<br>
Cocoapods
<br>
Modern Concurrency
<br>
MVVM Architecture
<br>

3rd party Frameworks used:
<br>
SwiftLint
<br>
RSwift
<br>

File structure layout:
|-Extensions (Common extensions used throughout the app) <br>
|-Library (Objects, including network responses)<br>
|-Resources (Auto generated files from RSwift)<br>
|-Services (Models, each contained to itself and hiding its implementation complexity within) <br>
|-UserScreens (The Screens that the user sees, their VMs and their base classes) <br>
|-Views (Reusable SwiftUI views and style modifiers) <br>
<br>
Installation:
<br>
run pod install or bundle exec pod install if you have rbenv 3.0.2 to get the very exact versions I am running.
Using XCode, open the "OpenWeatherApp.xcworkspace" , not the "OpenWeatherApp.xcodeproj" one
Run the app
