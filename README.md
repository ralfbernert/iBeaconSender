# iBeaconSender

Ralf Bernert

Website: http://www.bernertmedia.com
Twitter: [@ralfbernert](http://twitter.com/ralfbernert)
E-Mail: ralfbernert@gmx.de 


## What is it?
BeaconSender is a simple XCode project for turning any iOS device (for simplicity it only contains an iPhone storyboard, but runs also on iPad) into an iBeacon sender. 
 
So if you have an app idea that requires the use of several iBeacons and you want to give it a try without investing in iBeacon hardware first - this is it.

This is a simple example for how to use iOS CoreLocation's `CBPeripheralManager` class.


## How does it work?

Just build and run the project on any iOS device. You can then select between 10 iBeacons devided into two groups to simulate a multiple iBeacon scenario. If you need more then 10 iBeacons or more/less groups, the code should easily be modified. 

If you are only interested in the sending code for your app just look into this method:
``` obj-c
- (void)createAdvertisingBeaconWithPower:(NSNumber *)rssi major:(CLBeaconMajorValue)major mino:(CLBeaconMinorValue)minor
```
There you will find everything you need. It's pretty easy and straight forward.


## iBeacon Scanner
Please see another iBeacon project, the [iBeaconScanner](https://github.com/ralfbernert/iBeaconScanner) that shows all iBeacons in range ordered by proximity.