# flutter_ble_demo

A new Flutter project that showcases a generic Bluetooth Low Energy (BLE) mobile application. The EFRConnect app by Silicon Labs and the nRFConnect app by Nordic Semiconductor were the main sources of inspiration for the development of this application. 

## Getting Started

This project may be the starting point for Bluetooth Low Energy based mobile application development. This project shows general purpose scanning, connecting to the desired device, and showing the GATT services and properties of the chosen BLE device. Additionally, this application can function as a BLE GATT Client and carry out fundamental BLE GATT operations like Read, Write, Notify, and Indicate with a BLE GATT Server. 

Besides, there is a Class (Stateful Widget) that is commented out in the lib/screens/scan screen.dart file and can only scan the one targeted BLE device.
The BLE device name is used to filter this scan.   

In order to make the application better in the future, I intend to keep working on this project. 

Credits:

I mainly took inspiration from the codebase of the following two GitHub repos for this project:

https://github.com/jenow/flutter-ble
https://github.com/pauldemarco/flutter_blue/tree/master/example

Bravo for their excellent work! 
