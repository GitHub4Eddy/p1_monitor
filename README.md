# p1_monitor

This Quickapp retrieves power consumption, power production and gas usage from the (P1 Monitor) energy and gas meter 
All power consumption of all HomeCenter devices is summerized
The difference between the total power consumption and the power consumption of the HomeCenter devices is put in a unused device (unless the powerID = 0 or empty)
In the QuickApp labels power consumption, power production and gas usage is shown 
The net consumption is also shown in de log (under the icon)

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

I use a Smart Meter Cable Starter Kit:
- Raspberry Pi 4 Model B Rev 1.1 2GB
- 8GB Micro SDHC
- Original Raspberry Pi 4B Enclosure
- Original Raspberry Pi USB-C 3A power supply
- Smart Meter cable
- P1 Monitor software from: https://www.ztatz.nl

Variables (mandatory): 
- IPaddress = IP address of your P1 monitor
- Path = Path behind the IP address, normally /api/v1/smartmeter?limit=1&json=object
- Interval = Number in seconds, the P1 Monitor normally is updated every 10 seconds
- powerID = ID of the device where you want to capture the 'delta' power, use 0 if you don't want to store the energy consumption
- debugLevel = Number (1=some, 2=few, 3=all) (default = 1)

Example content Json table (Without production)
{"CONSUMPTION_GAS_M3": 6539.998, "CONSUMPTION_KWH_HIGH": 9549.688, "CONSUMPTION_KWH_LOW": 8735.424, "CONSUMPTION_W": 704, "PRODUCTION_KWH_HIGH": 0.0, "PRODUCTION_KWH_LOW": 0.0, "PRODUCTION_W": 0, "RECORD_IS_PROCESSED": 0, "TARIFCODE": "P", "TIMESTAMP_UTC": 1597135675, "TIMESTAMP_lOCAL": "2020-08-11 10:47:55"}
