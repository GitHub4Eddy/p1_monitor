# p1_monitor

This Quickapp retrieves power consumption, power production and gas usage from the (P1 Monitor) energy and gas meter. All power consumption of all HomeCenter devices is summerized. The difference between the total power consumption and the power consumption of the HomeCenter devices is put in a unused device (unless the powerID = 0 or empty)

In the QuickApp labels power consumption, power production and gas usage is shown. The netto consumption is also shown in de log (under the icon)

Version 0.3 (16th August 2020)
- Added Quickapp variables for easy configuration
- Added power production
- Changed method of adding QuickApp variables, so they can be edited

I use a Smart Meter Cable Starter Kit:
- Raspberry Pi 4 2GB
- 8GB Micro SDHC
- Original Raspberry Pi 4B Enclosure
- Original Raspberry Pi USB-C 3A power supply

With the P1 Monitor configuration from: https://www.ztatz.nl

Example content Json table (Without production)
{"CONSUMPTION_GAS_M3": 6539.998, "CONSUMPTION_KWH_HIGH": 9549.688, "CONSUMPTION_KWH_LOW": 8735.424, "CONSUMPTION_W": 704, "PRODUCTION_KWH_HIGH": 0.0, "PRODUCTION_KWH_LOW": 0.0, "PRODUCTION_W": 0, "RECORD_IS_PROCESSED": 0, "TARIFCODE": "P", "TIMESTAMP_UTC": 1597135675, "TIMESTAMP_lOCAL": "2020-08-11 10:47:55"}
