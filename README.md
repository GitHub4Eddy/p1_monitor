# p1_monitor

This Quickapp retrieves power consumption, power production and gas usage from the (P1 Monitor) energy and gas meter 

Child Devices for Net Consumption, Consumption, Production, Gross Consumption, Device Consumption, Consumption High, Consumption Low, Production High, Production Low, Total Gas, Consumption L1, Consumption L2, Consumption L3, Ampere L1, Ampere L2, Ampere L3, Production L1, Production L2 and Production L3

All power consumption of all HomeCenter devices is summarized
The difference between the total power consumption and the power consumption of the HomeCenter devices is put in a unused device (unless the powerID = 0 or empty)

Version 1.3 (13th February 2021)
- Added Child Devices for Voltage L1 L2 L3
   
Versionn 1.2 (6th February 2021)
- Added a lot of Child Devices

Version 1.1 (18th January 2021)
- Solved a bug when powerID = 0

Version 1.0 (15th Jannuari 2021)
- Changed routine te get Energy Device ID's fast (no more maxNodeID needed)
- Added "Update Devicelist" button to update the Energy devicelist
- Added Tarifcode High and Low (and empty for flat fee)
- Rounded Consumption and Production to zero digits Watt
- Added Quickapp variable for debug level (1=some, 2=few, 3=all). Recommended default value is 1. 
- Re-aranged the labels
- Cleaned up some code

Version 0.3 (16th August 2020)
- Added Quickapp variables for easy configuration
- Added power production
- Changed method of adding QuickApp variables, so they can be edited

Tested on:
- P1 Monitor version:202012-1.0.0
- Raspberry Pi model:Raspberry Pi 4 Model B Rev 1.1
- Linux-5.4.72-v7l+-armv7l-with-debian-10.6
- Python versie:3.7.3
   
I use a Smart Meter Cable Starter Kit:
- Raspberry Pi 4 Model B Rev 1.1 2GB
- 8GB Micro SDHC
- Original Raspberry Pi 4B Enclosure
- Original Raspberry Pi USB-C 3A power supply
- Smart Meter cable
- P1 Monitor software from: https://www.ztatz.nl

Variables (mandatory): 
- IPaddress = IP address of your P1 monitor
- Interval = Number in seconds, the P1 Monitor normally is updated every 10 seconds
- powerID = ID of the device where you want to capture the 'delta' power, use 0 if you don't want to store the energy consumption
- debugLevel = Number (1=some, 2=few, 3=all) (default = 1)
