# p1_monitor

This Quickapp retrieves energy consumption, energy production, gas and water usage from the (P1 Monitor) energy, gas and water meter 

Child Devices for Consumption (Watt), Production (Watt), Todays Consumption (kWh), Todays Production (kWh), Gross Consumption (Watt), Device Consumption (Watt), Waterflow (Liter), Consumption High (kWh), Consumption Low (kWh), Production High (kWh), Production Low (kWh), Consumption L1 L2 L3 (Watt), Production L1 L2 and L3 (Watt), Ampere L1 L2 L3 (Amp), Voltage L1 L2 L3 (Volt), Total Gas (m³) and Total Waterflow (m³)

Energy consumption and energy production is added to the (new) HC3 energy panel

All power consumption of all HomeCenter devices is summarized
The difference between the total power consumption and the power consumption of the HomeCenter devices is put in a unused device (unless the powerID = 0 or empty)

The Child device Todays Consumption can be selected in the Generals Settings as "Main energy meter". Doing so, the summary consumption will be from this device. If not, the consumption will come from the Child device Consumption High, the Child device Consumption Low and all your energy registering Z-wave devices and there values will be counted twice unless you change the Energy panel setting of each energy registering Z-wave device. 


ToDo as soon as Mobile App supports all device types:
- water -> com.fibaro.waterMeter 
- ampere/voltage -> com.fibaro.electricMeter
- gas -> com.fibaro.gasMeter
- devices with power values (Watt) --> com.fibaro.powerMeter


Version 1.5 (4th Septembber 2021)
- Support of new Energy Panel: 
   - Changed Child device Net Consumption to Main device with type com.fibaro.powerSensor (value can be positive or negative)
   - Added Child device Todays Consumption to show the daily energy consumption in kWh
   - Added Child device Todays Production to show the daily energy production in kWh
   - Changed Child device Consumption High and Low to com.fibaro.energyMeter (kWh in property "value"; "rateType" = consumption). These values will be shown in the new energy panel. 
   - Changed Child device Production High and Low to com.fibaro.energyMeter (kWh in property "value"; "rateType" = production). These values will be shown in the new energy panel. 
   - Added automaticaly change rateType interface of Child device Consumption High and Low to "consumption" and Production High and Low to "production"
   - Changed Child device Consumption and Production to type com.fibaro.powerSensor (Watt) to show power graphs
   - Changed Child device Consumption L1, L2 and L3 and Production L1, L2 and L3 to type com.fibaro.powerSensor (Watt) to show power graphs
- Additional changes:
   - Added todays Maximum consumption and todays Maximum production and timestamp to the label text and Child device log text
   - Added todays Maximum consumption and todays Maximum production automatic format measurement to W, Kw, MW or GW
   - Added todays Consumption low and high (kWh) and todays Production low and high (kWh) to the label text and Child devices log text
   - Added todays Consumption of gas in the label text and Child device log text
   - Added Timestamp in format dd-mm-yyyy hh:mm:ss to log of Main device and labels
   - Placed production below consumption in the labels
   - Solved bug when Production is higher than Consumption with calculation of Gross Consumption (Gross Consumption = Net Consumption minus or plus Device Consumption)


Version 1.4 (11th April 2021)
- Added Child Devices Waterflow and Total Waterflow

Version 1.3 (13th February 2021)
- Added Child Devices for Voltage L1 L2 L3

Version 1.2 (6th February 2021)
- Added a lot of Child Devices for Net Consumption, Consumption, Production, Gross Consumption, Device Consumption, Consumption High, Consumption Low, Production High, Production Low, Total Gas, Consumption L1 L2 L3, Ampere L1 L2 L3, Production L1 L2 and L3

Version 1.1 (18th January 2021)
- Solved a bug when powerID = 0

Version 1.0 (15th Januari 2021)
- Changed routine te get Energy Device ID's fast (no more maxNodeID needed)
- Added "Update Devicelist" button to update the Energy devicelist
- Added Tarifcode High and Low (and empty for flat fee)
- Rounded Consumption and Production to zero digits Watt
- Added Quickapp variable for debug level (1=some, 2=few, 3=all). Recommended default value is 1. 
- Re-aranged the labels
- Cleaned up some code

Version 0.3 (16th August 2020)
- Added Quickapp variables for easy configuration
- Added Power Production
- Changed method of adding QuickApp variables, so they can be edited


Variables (mandatory): 
- IPaddress = IP address of your P1 monitor
- Interval = Number in seconds, the P1 Monitor normally is updated every 10 seconds
- powerID = ID of the device where you want to capture the 'delta' power, use 0 if you don't want to store the energy consumption
- debugLevel = Number (1=some, 2=few, 3=all) (default = 1)
- waterMeter = Existance of watermeter true or false (default = false)


Tested on:
- P1 Monitor version: 20210618 V1.3.1
- Raspberry Pi model: Raspberry Pi 4 Model B Rev 1.1
- Linux-5.10.17-v7l+-armv7l-with-debian-10.9
- Python versie: 3.7.3


I use a Smart Meter Cable Starter Kit:
   - Raspberry Pi 4 Model B Rev 1.1 2GB
   - 8GB Micro SDHC
   - Original Raspberry Pi 4B Enclosure
   - Original Raspberry Pi USB-C 3A power supply
   - Smart Meter cable
   - P1 Monitor software from: https://www.ztatz.nl
