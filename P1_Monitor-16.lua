-- QUICKAPP P1 MONITOR 

-- This Quickapp retrieves energy consumption, energy production, gas and water usage from the (P1 Monitor) energy, gas and water meter 

-- Child Devices for Consumption (Watt), Production (Watt), Todays Consumption (kWh), Todays Production (kWh), Gross Consumption (Watt), Device Consumption (Watt), Waterflow (Liter), Consumption High (kWh), Consumption Low (kWh), Production High (kWh), Production Low (kWh), Consumption L1 L2 L3 (Watt), Production L1 L2 and L3 (Watt), Ampere L1 L2 L3 (Amp), Voltage L1 L2 L3 (Volt), Total Gas (m³) and Total Waterflow (m³)

-- Energy consumption and energy production is added to the (new) HC3 energy panel

-- All power consumption of all HomeCenter devices is summarized
-- The difference between the total power consumption and the power consumption of the HomeCenter devices is put in a unused device (unless the powerID = 0 or empty)

-- The Child device Todays Consumption can be selected in the Generals Settings as "Main energy meter". Doing so, the summary consumption will be from this device. If not, the consumption will come from the Child device Consumption High, the Child device Consumption Low and all your energy registering Z-wave devices and there values will be counted twice unless you change the Energy panel setting of each energy registering Z-wave device. 


-- ToDo as soon as Yubii Mobile App supports all device types:
-- water -> com.fibaro.waterMeter 
-- ampere/voltage -> com.fibaro.electricMeter
-- gas -> com.fibaro.gasMeter
-- devices with power values (Watt) --> com.fibaro.powerMeter


-- Version 1.6 (8th January 2022)
-- Changed the waterflow algoritme to show more stable and more acurate measurements
-- Small change in the code for checking existance of waterflow sensor
-- Changed the Waterflow unit from Liter to L/min
-- Added experimental net consumption to power 
-- Added Lasthour gas to labels
-- Changed the API request for status to json output


-- Version 1.5 (4th September 2021)
-- Support of new Energy Panel: 
   -- Changed Child device Net Consumption to Main device with type com.fibaro.powerSensor (value can be positive or negative)
   -- Added Child device Todays Consumption to show the daily energy consumption in kWh
   -- Added Child device Todays Production to show the daily energy production in kWh
   -- Changed Child device Consumption High and Low to com.fibaro.energyMeter (kWh in property "value"; "rateType" = consumption). These values will be shown in the new energy panel. 
   -- Changed Child device Production High and Low to com.fibaro.energyMeter (kWh in property "value"; "rateType" = production). These values will be shown in the new energy panel. 
   -- Added automaticaly change rateType interface of Child device Consumption High and Low to "consumption" and Production High and Low to "production"
   -- Changed Child device Consumption and Production to type com.fibaro.powerSensor (Watt) to show power graphs
   -- Changed Child device Consumption L1, L2 and L3 and Production L1, L2 and L3 to type com.fibaro.powerSensor (Watt) to show power graphs
-- Additional changes:
   -- Added todays Maximum consumption and todays Maximum production and timestamp to the label text and Child device log text
   -- Added todays Maximum consumption and todays Maximum production automatic format measurement to W, Kw, MW or GW
   -- Added todays Consumption low and high (kWh) and todays Production low and high (kWh) to the label text and Child devices log text
   -- Added todays Consumption of gas in the label text and Child device log text
   -- Added Timestamp in format dd-mm-yyyy hh:mm:ss to log of Main device and labels
   -- Placed production below consumption in the labels
   -- Solved bug when Production is higher than Consumption with calculation of Gross Consumption (Gross Consumption = Net Consumption minus or plus Device Consumption)

-- Version 1.4 (11th April 2021)
-- Added Child Devices Waterflow and Total Waterflow

-- Version 1.3 (13th February 2021)
-- Added Child Devices for Voltage L1 L2 L3

-- Version 1.2 (6th February 2021)
-- Added a lot of Child Devices for Net Consumption, Consumption, Production, Gross Consumption, Device Consumption, Consumption High, Consumption Low, Production High, Production Low, Total Gas, Consumption L1 L2 L3, Ampere L1 L2 L3, Production L1 L2 and L3

-- Version 1.1 (18th January 2021)
-- Solved a bug when powerID = 0

-- Version 1.0 (15th Januari 2021)
-- Changed routine te get Energy Device ID's fast (no more maxNodeID needed)
-- Added "Update Devicelist" button to update the Energy devicelist
-- Added Tarifcode High and Low (and empty for flat fee)
-- Rounded Consumption and Production to zero digits Watt
-- Added Quickapp variable for debug level (1=some, 2=few, 3=all). Recommended default value is 1. 
-- Re-aranged the labels
-- Cleaned up some code

-- Version 0.3 (16th August 2020)
-- Added Quickapp variables for easy configuration
-- Added Power Production
-- Changed method of adding QuickApp variables, so they can be edited


-- Variables (mandatory): 
-- IPaddress = IP address of your P1 monitor
-- Interval = Number in seconds, the P1 Monitor normally is updated every 10 seconds, sometimes even faster
-- powerID = ID of the device where you want to capture the 'delta' power, use 0 if you don't want to store the delta energy consumption
-- debugLevel = Number (1=some, 2=few, 3=all) (default = 1)
-- waterMeter = Existance of watermeter true or false (default = false)


-- Tested on:
-- P1 Monitor version: 20210618 V1.3.1
-- Raspberry Pi model: Raspberry Pi 4 Model B Rev 1.1
-- Linux-5.10.17-v7l+-armv7l-with-debian-10.9
-- Python versie: 3.7.3


-- I use a Smart Meter Cable Starter Kit:
   -- Raspberry Pi 4 Model B Rev 1.1 2GB
   -- 8GB Micro SDHC
   -- Original Raspberry Pi 4B Enclosure
   -- Original Raspberry Pi USB-C 3A power supply
   -- Smart Meter cable
   -- P1 Monitor software from: https://www.ztatz.nl


-- Example content Json table Smartmeter (without values for production)
   --[{"CONSUMPTION_GAS_M3": 6635.825, "CONSUMPTION_KWH_HIGH": 9986.186, "CONSUMPTION_KWH_LOW": 9170.652, "CONSUMPTION_W": 692, "PRODUCTION_KWH_HIGH": 0.0, "PRODUCTION_KWH_LOW": 0.0, "PRODUCTION_W": 0, "RECORD_IS_PROCESSED": 0, "TARIFCODE": "D", "TIMESTAMP_UTC": 1601733693, "TIMESTAMP_lOCAL": "2020-10-03 16:01:33"}]
  
-- Example content Json table Watermeter
  --[{"TIMEPERIOD_ID": 11, "TIMESTAMP_UTC": 1615713840, "TIMESTAMP_lOCAL": "2021-03-14 10:24:00", "WATERMETER_CONSUMPTION_LITER": 1.0, "WATERMETER_CONSUMPTION_TOTAL_M3": 3406.243, "WATERMETER_PULS_COUNT": 1.0}]
  
  
-- No editing of this code is needed 


class 'consumption'(QuickAppChild)
function consumption:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("consumption QuickappChild initiated, deviceId:",self.id)
end
function consumption:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.consumption)))
  self:updateProperty("power", tonumber(string.format("%.3f",data.consumption)))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", "Max " ..data.max_consumption .." " ..data.max_consumption_unit .." " ..data.max_consumption_time)
end


class 'production'(QuickAppChild)
function production:__init(dev)
  QuickAppChild.__init(self,dev)
end
function production:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.production)))
  self:updateProperty("power", tonumber(string.format("%.3f",data.production)))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", "Max " ..data.max_production .." " ..data.max_production_unit .." " ..data.max_production_time)
end


class 'todays_consumption'(QuickAppChild)
function todays_consumption:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "consumption" then 
    self:updateProperty("rateType", "consumption")
    self:warning("Changed rateType interface of Todays Consumption child device (" ..self.id ..") to consumption")
  end
end
function todays_consumption:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.todays_consumption)))
  self:updateProperty("unit", "kWh")
  self:updateProperty("log", "")
end


class 'todays_production'(QuickAppChild)
function todays_production:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "production" then 
    self:updateProperty("rateType", "production")
    self:warning("Changed rateType interface of Todays Production child device (" ..self.id ..") to production")
  end
end
function todays_production:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.todays_production)))
  self:updateProperty("unit", "kWh")
  self:updateProperty("log", "")
end


class 'gross_consumption'(QuickAppChild)
function gross_consumption:__init(dev)
  QuickAppChild.__init(self,dev)
end
function gross_consumption:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.gross_consumption)))
  self:updateProperty("power", tonumber(string.format("%.3f",data.gross_consumption)))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", " ")
end


class 'device_consumption'(QuickAppChild)
function device_consumption:__init(dev)
  QuickAppChild.__init(self,dev)
end
function device_consumption:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.device_consumption)))
  self:updateProperty("power", tonumber(string.format("%.3f",data.device_consumption)))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", " ")
end


class 'waterflow'(QuickAppChild)
function waterflow:__init(dev)
  QuickAppChild.__init(self,dev)
end
function waterflow:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.1f",data.waterflow)))
  self:updateProperty("unit", "L/min")
  self:updateProperty("log", "")
end


class 'consumption_L1'(QuickAppChild)
function consumption_L1:__init(dev)
  QuickAppChild.__init(self,dev)
end
function consumption_L1:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.consumption_L1)))
  self:updateProperty("power", tonumber(string.format("%.3f",data.consumption_L1)))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", " ")
end


class 'consumption_L2'(QuickAppChild)
function consumption_L2:__init(dev)
  QuickAppChild.__init(self,dev)
end
function consumption_L2:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.consumption_L2)))
  self:updateProperty("power", tonumber(string.format("%.3f",data.consumption_L2)))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", " ")
end


class 'consumption_L3'(QuickAppChild)
function consumption_L3:__init(dev)
  QuickAppChild.__init(self,dev)
end
function consumption_L3:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.consumption_L3)))
  self:updateProperty("power", tonumber(string.format("%.3f",data.consumption_L3)))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", " ")
end


class 'production_L1'(QuickAppChild)
function production_L1:__init(dev)
  QuickAppChild.__init(self,dev)
end
function production_L1:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.production_L1)))
  self:updateProperty("power", tonumber(string.format("%.3f",data.production_L1)))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", " ")
end


class 'production_L2'(QuickAppChild)
function production_L2:__init(dev)
  QuickAppChild.__init(self,dev)
end
function production_L2:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.production_L2)))
  self:updateProperty("power", tonumber(string.format("%.3f",data.production_L2)))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", " ")
end


class 'production_L3'(QuickAppChild)
function production_L3:__init(dev)
  QuickAppChild.__init(self,dev)
end
function production_L3:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.production_L3)))
  self:updateProperty("power", tonumber(string.format("%.3f",data.production_L3)))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", " ")
end


class 'L1_A'(QuickAppChild)
function L1_A:__init(dev)
  QuickAppChild.__init(self,dev)
end
function L1_A:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.1f",data.L1_A)))
  self:updateProperty("unit", "Amp")
  self:updateProperty("log", "")
end


class 'L2_A'(QuickAppChild)
function L2_A:__init(dev)
  QuickAppChild.__init(self,dev)
end
function L2_A:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.1f",data.L2_A)))
  self:updateProperty("unit", "Amp")
  self:updateProperty("log", "")
end


class 'L3_A'(QuickAppChild)
function L3_A:__init(dev)
  QuickAppChild.__init(self,dev)
end
function L3_A:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.1f",data.L3_A)))
  self:updateProperty("unit", "Amp")
  self:updateProperty("log", "")
end


class 'L1_V'(QuickAppChild)
function L1_V:__init(dev)
  QuickAppChild.__init(self,dev)
end
function L1_V:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.0f",data.L1_V)))
  self:updateProperty("unit", "Volt")
  self:updateProperty("log", "")
end


class 'L2_V'(QuickAppChild)
function L2_V:__init(dev)
  QuickAppChild.__init(self,dev)
end
function L2_V:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.0f",data.L2_V)))
  self:updateProperty("unit", "Volt")
  self:updateProperty("log", "")
end


class 'L3_V'(QuickAppChild)
function L3_V:__init(dev)
  QuickAppChild.__init(self,dev)
end
function L3_V:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.0f",data.L3_V)))
  self:updateProperty("unit", "Volt")
  self:updateProperty("log", "")
end


class 'consumption_high'(QuickAppChild)
function consumption_high:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "consumption" then 
    self:updateProperty("rateType", "consumption")
    self:warning("Changed rateType interface of Consumption High child device (" ..self.id ..") to consumption")
  end
end
function consumption_high:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.consumption_high)))
  self:updateProperty("unit", "kWh")
  self:updateProperty("log", "Today " ..data.today_consumption_high .." kWh")
end


class 'consumption_low'(QuickAppChild)
function consumption_low:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "consumption" then 
    self:updateProperty("rateType", "consumption")
    self:warning("Changed rateType interface of Consumption Low child device (" ..self.id ..") to consumption")
  end
end
function consumption_low:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.consumption_low)))
  self:updateProperty("unit", "kWh")
  self:updateProperty("log", "Today " ..data.today_consumption_low .." kWh")
end


class 'production_high'(QuickAppChild)
function production_high:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "production" then 
    self:updateProperty("rateType", "production")
    self:warning("Changed rateType interface of Production High child device (" ..self.id ..") to production")
  end
end
function production_high:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.production_high)))
  self:updateProperty("unit", "kWh")
  self:updateProperty("log", "Today " ..data.today_production_high .." kWh")
end


class 'production_low'(QuickAppChild)
function production_low:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "production" then 
    self:updateProperty("rateType", "production")
    self:warning("Changed rateType interface of Production Low child device (" ..self.id ..") to production")
  end
end
function production_low:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.production_low)))
  self:updateProperty("unit", "kWh")
  self:updateProperty("log", "Today " ..data.today_production_low .." kWh")
end


class 'water'(QuickAppChild)
function water:__init(dev)
  QuickAppChild.__init(self,dev)
end
function water:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.water)))
  self:updateProperty("unit", "m³")
  self:updateProperty("log", "")
end


class 'gas'(QuickAppChild)
function gas:__init(dev)
  QuickAppChild.__init(self,dev)
end
function gas:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.gas)))
  self:updateProperty("unit", "m³")
  self:updateProperty("log", "Today " ..data.today_gas .." m³")
end


local function getChildVariable(child,varName)
  for _,v in ipairs(child.properties.quickAppVariables or {}) do
    if v.name==varName then return v.value end
  end
  return ""
end


-- QuickApp Functions


function QuickApp:updateChildDevices()
  for id,child in pairs(self.childDevices) do -- Update Child Devices
    child:updateValue(data) 
  end
end


function QuickApp:logging(level,text) -- Logging function for debug
  if tonumber(debugLevel) >= tonumber(level) then 
      self:debug(text)
  end
end


function QuickApp:button1Event() -- Refresh button event
  self:updateView("button1", "text", "Please wait...")
  self:eDevices() -- Get all Energy Devices
  fibaro.setTimeout(5000, function()
    self:updateView("button1", "text", "Update Devicelist")
  end)
end


function QuickApp:unitCheckWatt(measurement) -- Set the measurement and unit to Watt, Kilowatt, Megawatt or Gigawatt
  self:logging(3,"Start unitCheckWatt")
  if measurement > 1000000000 then
    return string.format("%.2f",measurement/1000000000),"GW"
  elseif measurement > 1000000 then
    return string.format("%.2f",measurement/1000000),"MW"
  elseif measurement > 1000 then
    return string.format("%.2f",measurement/1000),"kW"
  else
    return string.format("%.0f",measurement),"W"
  end
end


function QuickApp:consumption() -- Update the energy consumption of all energy devices
  self:logging(3,"QuickApp:consumption")
  local deviceValue = 0
  local id = 1
  data.device_consumption = 0
  data.gross_consumption = 0
  for key, id in pairs(eDevices) do
    if fibaro.getValue(id, "power") and id~=powerID then
      deviceValue = fibaro.getValue(id, "power")
      data.device_consumption = data.device_consumption + deviceValue
    end
  end
  
  if tonumber(data.net_consumption)  < 0 then -- Measured power usage minus power usage from all devices
    data.gross_consumption = tonumber(data.net_consumption) + data.device_consumption -- Production is higher than consumption (negative net consumption)
  else
    data.gross_consumption = tonumber(data.net_consumption) - data.device_consumption 
  end

  if powerID ~= 0 and powerID == nil then
    api.put("/devices/"..powerID, {["properties"]={["power"]=data.gross_consumption}}) -- Put gross_consumption into device with powerID
  end
end


function QuickApp:updateProperties() -- Update the properties
  self:logging(3,"QuickApp:updateProperties")
  self:updateProperty("value", tonumber(string.format("%.3f",data.net_consumption)))
  self:updateProperty("power", tonumber(string.format("%.3f",data.net_consumption)))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", data.timestamp_local)
end


function QuickApp:updateLabels() -- Update the labels
  self:logging(3,"QuickApp:updateLabels")
  local labelText = ""
  labelText = labelText .."Consumption: " ..data.consumption .." Watt (Max " ..data.max_consumption .." " ..data.max_consumption_unit .." at " ..data.max_consumption_time ..")" .."\n" 
  labelText = labelText .."Production: " ..data.production .." Watt (Max " ..data.max_production .." " ..data.max_production_unit .." at " ..data.max_production_time ..")"  .."\n"
  labelText = labelText .."Waterflow: " ..data.waterflow .." L/min" .."\n\n"
  
  labelText = labelText .."Todays consumption: " ..data.todays_consumption .." kWh" .."\n"
  labelText = labelText .."Todays production: " ..data.todays_production .." kWh" .."\n"
  labelText = labelText .."Gross consumption: " ..data.gross_consumption .." Watt" .."\n"
  labelText = labelText .."Device consumption: " ..data.device_consumption .." Watt" .."\n\n"
  
  labelText = labelText .."Totals:" .."\n" 
  labelText = labelText .."Consumption high: " ..data.consumption_high .." kWh (Today " ..data.today_consumption_high .." kWh)" .."\n" 
  labelText = labelText .."Consumption low: " ..data.consumption_low .." kWh (Today " ..data.today_consumption_low .." kWh)" .."\n"
  labelText = labelText .."Consumption: " ..data.total_consumption .." kWh" .."\n" 
  labelText = labelText .."Production high: " ..data.production_high .." kWh (Today " ..data.today_production_high .." kWh)" .."\n" 
  labelText = labelText .."Producton low: " ..data.production_low .." kWh (Today " ..data.today_production_low .." kWh)" .."\n"
  labelText = labelText .."Production: " ..data.total_production .." kWh"  .."\n"
  labelText = labelText .."Gas: " ..data.gas .." m³ (Today: " ..data.today_gas .." m³" .." / Lasthour: " ..data.lasthour_gas .." L)" .."\n"
  labelText = labelText .."Water: " ..data.water .." m³" .."\n\n"
  
  labelText = labelText .."Consumption:" .."\n"
  labelText = labelText .."L1: " ..data.consumption_L1 .." - L2: " ..data.consumption_L2 .." - L3: " ..data.consumption_L3 .." Watt " .."\n\n"
  
  labelText = labelText .."Production" .."\n"
  labelText = labelText .."L1: " ..data.production_L1 .." - L2: " ..data.production_L2 .." - L3: " ..data.production_L3 .." Watt " .."\n\n"
  
  labelText = labelText .."Ampere:" .."\n"
  labelText = labelText .."L1: " ..data.L1_A .." - L2: " ..data.L2_A .." - L3: " ..data.L3_A .." Amp " .."\n\n"
  
  labelText = labelText .."Voltage:" .."\n"
  labelText = labelText .."L1: " ..data.L1_V .." - L2: " ..data.L2_V .." - L3: " ..data.L3_V .." Volt " .."\n\n"

  labelText = labelText .."Updated: " ..data.timestamp_local .."\n"

  self:updateView("label1", "text", labelText)
  self:logging(2,labelText)
end


function QuickApp:valuesWatermeter() -- Get the values from json file Watermeter
  self:logging(3,"QuickApp:valuesWatermeter")
  data.waterflow = string.format("%.1f",jsonTable[2].WATERMETER_CONSUMPTION_LITER) -- Use the seconds measurement, to get a stable value (not counting from 1 to n up to one minute)
  local waterflow_check = tonumber(jsonTable[1].WATERMETER_CONSUMPTION_LITER) 
  data.water = string.format("%.3f",jsonTable[1].WATERMETER_CONSUMPTION_TOTAL_M3)
  data.waterflow_timestamp = tonumber(jsonTable[1].TIMESTAMP_UTC)
  if waterflow_check > tonumber(data.waterflow) or waterflow_check == 0 then -- Check if current waterflow is higer than one minute ago or is zero
    data.waterflow = string.format("%.1f",waterflow_check)
  end
  if os.time()-data.waterflow_timestamp > 70 and tonumber(data.waterflow) > 0 then -- If measurement (>0) is older than 70 seconds then change measurement to zero
    data.waterflow = "0.0"
  end
end


function QuickApp:valuesStatus() -- Get the values from json file Status
  self:logging(3,"QuickApp:valuesStatus")
  data.consumption_L1 = string.format("%.1f",tonumber(jsonTable[74].STATUS)*1000)
  data.consumption_L2 = string.format("%.1f",tonumber(jsonTable[75].STATUS)*1000)
  data.consumption_L3 = string.format("%.1f",tonumber(jsonTable[76].STATUS)*1000)
  data.production_L1 = string.format("%.1f",tonumber(jsonTable[77].STATUS)*1000)
  data.production_L2 = string.format("%.1f",tonumber(jsonTable[78].STATUS)*1000)
  data.production_L3 = string.format("%.1f",tonumber(jsonTable[79].STATUS)*1000)
  data.L1_A = string.format("%.1f",jsonTable[100].STATUS)
  data.L2_A = string.format("%.1f",jsonTable[101].STATUS)
  data.L3_A = string.format("%.1f",jsonTable[102].STATUS)
  data.L1_V = string.format("%.1f",jsonTable[103].STATUS)
  data.L2_V = string.format("%.1f",jsonTable[104].STATUS)
  data.L3_V = string.format("%.1f",jsonTable[105].STATUS)  
  data.max_consumption = string.format("%.0f",tonumber(jsonTable[1].STATUS)*1000)
  data.max_production = string.format("%.0f",tonumber(jsonTable[3].STATUS)*1000)
  data.max_consumption, data.max_consumption_unit = self:unitCheckWatt(tonumber(data.max_consumption)) -- Set measurement and unit to W, kW, MW or GW
  data.max_production, data.max_production_unit = self:unitCheckWatt(tonumber(data.max_production)) -- Set measurement and unit to W, kW, MW or GW
  data.max_consumption_time = jsonTable[2].STATUS
  data.max_production_time = jsonTable[4].STATUS
  data.today_consumption_low = string.format("%.3f",jsonTable[8].STATUS)
  data.today_consumption_high = string.format("%.3f",jsonTable[9].STATUS)
  data.today_production_low = string.format("%.3f",jsonTable[10].STATUS)
  data.today_production_high = string.format("%.3f",jsonTable[11].STATUS)
  data.todays_consumption = string.format("%.3f",tonumber(data.today_consumption_low) + tonumber(data.today_consumption_high))
  data.todays_production = string.format("%.3f",tonumber(data.today_production_low) + tonumber(data.today_production_high))
  data.today_gas = string.format("%.3f",jsonTable[44].STATUS)
  data.lasthour_gas = string.format("%.0f",tonumber(jsonTable[50].STATUS)*1000)

  local pattern = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)" -- Convert data.max_consumption_time and data.max_production_time to nice format
  local runyear, runmonth, runday, runhour, runminute, runseconds = data.max_consumption_time:match(pattern)
  local convertedTimestamp = os.time({year = runyear, month = runmonth, day = runday, hour = runhour, min = runminute, sec = runseconds})
  data.max_consumption_time = os.date("%H:%M", convertedTimestamp)
  runyear, runmonth, runday, runhour, runminute, runseconds = data.max_production_time:match(pattern)
  convertedTimestamp = os.time({year = runyear, month = runmonth, day = runday, hour = runhour, min = runminute, sec = runseconds})
  data.max_production_time = os.date("%H:%M", convertedTimestamp)
end


function QuickApp:valuesSmartmeter() -- Get the values from json file Smartmeter
  self:logging(3,"QuickApp:valuesSmartmeter")
  data.consumption = string.format("%.1f",jsonTable[1].CONSUMPTION_W)
  data.consumption_high = string.format("%.3f",jsonTable[1].CONSUMPTION_KWH_HIGH)
  data.consumption_low = string.format("%.3f",jsonTable[1].CONSUMPTION_KWH_LOW)
  data.production = string.format("%.1f",jsonTable[1].PRODUCTION_W)
  data.production_high = string.format("%.3f",jsonTable[1].PRODUCTION_KWH_HIGH)
  data.production_low = string.format("%.3f",jsonTable[1].PRODUCTION_KWH_LOW)
  data.gas = string.format("%.3f",jsonTable[1].CONSUMPTION_GAS_M3)  
  data.net_consumption = string.format("%.1f",jsonTable[1].CONSUMPTION_W - jsonTable[1].PRODUCTION_W)
  data.total_consumption = string.format("%.3f",(jsonTable[1].CONSUMPTION_KWH_HIGH + jsonTable[1].CONSUMPTION_KWH_LOW))
  data.total_production = string.format("%.3f",(jsonTable[1].PRODUCTION_KWH_HIGH + jsonTable[1].PRODUCTION_KWH_LOW))
  data.tarifcode = jsonTable[1].TARIFCODE
  data.timestamp_local = jsonTable[1].TIMESTAMP_lOCAL
  
  local pattern = "(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)" -- Convert timestamp_local to nice format
  local runyear, runmonth, runday, runhour, runminute, runseconds = data.timestamp_local:match(pattern)
  local convertedTimestamp = os.time({year = runyear, month = runmonth, day = runday, hour = runhour, min = runminute, sec = runseconds})
  data.timestamp_local = os.date("%d-%m-%Y %H:%M:%S", convertedTimestamp)

  if data.tarifcode == "P" then
    data.tarifcodeText = "(High)"
  elseif data.tarifcode == "D" then
    data.tarifcodeText = "(Low)"
  else
    data.tarifcodeText = ""
  end

end


function QuickApp:getData() -- Get data from P1 Monitor 
  self:logging(3,"getData")
  local url = "http://" ..IPaddress ..Path
  self:logging(3,"url: " ..url)
  self.http:request(url, {
  options = {
    headers = {Accept = "application/json"}, method = 'GET'},
    success = function(response)
      self:logging(3,"Response status: " ..response.status)
      self:logging(3,"Response data: " ..response.data)

      local apiResult = response.data        
      jsonTable = json.decode(apiResult) -- Decode the json string from api to lua-table

      self:logging(3,"Mode prev: " ..Mode)
      if Mode == "Smartmeter" then
        self:valuesSmartmeter() -- Get the values from json file Smartmeter
        self:consumption() -- Store net consumption in unused device 
        Path = pathStatus -- Next path
        Mode = "Status" -- Next mode
      elseif Mode == "Status" then 
        self:valuesStatus() -- Get the values from json file Status
        if waterMeter then
          Path = pathWatermeter -- Next path
          Mode = "Watermeter" -- Next mode
        else
          Path = pathSmartmeter -- Next path
          Mode = "Smartmeter" -- Next mode  
        end
      elseif Mode == "Watermeter" then
        self:valuesWatermeter() -- Get the values from json file Watermeter
        Path = pathSmartmeter -- Next path
        Mode = "Smartmeter" -- Next mode  
      end
      self:logging(3,"Mode next: " ..Mode)

      self:updateLabels() -- Update the labels
      self:updateProperties() -- Update the properties
      self:updateChildDevices() -- Update the Child Devices

    end,
    error = function(error)
      self:error("error: " ..json.encode(error))
      self:updateProperty("log", "error: " ..json.encode(error))
    end
  }) 
  fibaro.setTimeout(Interval, function() self:getData() end) -- Checks every [Interval] seconds for new data (three loops: Smartmeter, Status and Watermeter)
end 


function QuickApp:eDevices() -- Get all Device IDs which measure Energy Consumption
  eDevices = {}
  local devices, status = api.get("/devices?interface=energy")
  self:trace("Updated devicelist devices with energy consumption")
  for k in pairs(devices) do
    table.insert(eDevices,devices[k].id)
  end
  self:logging(2,"Energy Devices: " ..json.encode(eDevices))
end


function QuickApp:createVariables() -- Get all Quickapp Variables or create them
  pathSmartmeter = "/api/v1/smartmeter?limit=1&json=object" -- Default path Smartmeter
  pathStatus = "/api/v1/status?json=object" -- Default path Status
  pathWatermeter = "/api/v2/watermeter/minute?limit=2&sort=des&json=object" -- Default path Watermeter
  Path = pathSmartmeter -- Set initial value for Path
  Mode = "Smartmeter" -- Set initial value for Mode
  
  data = {}
  
  data.consumption = "0"
  data.production = "0"
  
  data.device_consumption = 0
  data.gross_consumption = 0 
  data.total_consumption = ""
  data.total_production = ""
  data.tarifcode = ""
  data.tarifcodeText = ""
  
  data.consumption_L1 = "0" 
  data.consumption_L2 = "0" 
  data.consumption_L3 = "0" 
  data.production_L1 = "0" 
  data.production_L2 = "0" 
  data.production_L3 = "0" 
  data.consumption_high = "0"
  data.consumption_low = "0"
  data.production_high = "0"
  data.production_low = "0"
  
  data.L1_A = "0" 
  data.L2_A = "0" 
  data.L3_A = "0"   
  data.L1_V = "0" 
  data.L2_V = "0" 
  data.L3_V = "0" 
  
  data.waterflow = "0"
  data.waterflow_timestamp = 0
  data.water = "0"
  data.gas = "0"
  
  data.timestamp_local = ""
  
  data.max_consumption = "0"
  data.max_production = "0"
  data.max_consumption_unit ="W" 
  data.max_production_unit = "W" 
  data.max_consumption_time = ""
  data.max_production_time = ""
  data.todays_consumption = "0"
  data.todays_production = "0"
  data.today_consumption_low = "0"
  data.today_consumption_high = "0"
  data.today_production_low = "0"
  data.today_production_high = "0"
  data.today_gas = "0"
  data.lasthour_gas = "0"
  
end


function QuickApp:getQuickappVariables() -- Get all Quickapp Variables or create them
  IPaddress = self:getVariable("IPaddress")
  powerID = tonumber(self:getVariable("powerID"))
  waterMeter = string.lower(self:getVariable("waterMeter"))
  Interval = tonumber(self:getVariable("Interval")) 
  debugLevel = tonumber(self:getVariable("debugLevel"))

  -- Check existence of the mandatory variables, if not, create them with default values 
  if IPaddress == "" or IPaddress == nil then 
    IPaddress = "192.168.1.120" -- Default IPaddress 
    self:setVariable("IPaddress", IPaddress)
    self:trace("Added QuickApp variable IPaddress")
  end
  if powerID == "" or powerID == nil then 
    powerID = "0" -- ID of the device where you want to capture the 'delta' power, use 0 if you don't want to store the energy consumption
    self:setVariable("powerID", powerID)
    self:trace("Added QuickApp variable powerID")
    powerID = tonumber(powerID)
  end
  if waterMeter == "" or waterMeter == nil then 
    waterMeter = "false" -- Default availability of waterMeter is "false"
    self:setVariable("waterMeter",waterMeter)
    self:trace("Added QuickApp variable waterMeter")
  end  
  if Interval == "" or Interval == nil then
    Interval = "10" -- Default interval in seconds (The P1 meter normally reads every 10 seconds)
    self:setVariable("Interval", Interval)
    self:trace("Added QuickApp variable Interval")
    Interval = tonumber(Interval)
  end
  if debugLevel == "" or debugLevel == nil then
    debugLevel = "1" -- Default value for debugLevel response in seconds
    self:setVariable("debugLevel",debugLevel)
    self:trace("Added QuickApp variable debugLevel")
    debugLevel = tonumber(debugLevel)
  end
  if powerID == 0 or powerID == nil then
    self:warning("No powerID to store net power consumption")
  end
  if waterMeter == "true" then 
    waterMeter = true 
  else
    waterMeter = false
  end
  if waterMeter then
    Interval = tonumber(string.format("%.0f",(Interval*1000/3)))
  else
    Interval = tonumber(string.format("%.0f",(Interval*1000/2)))
    self:warning("No waterMeter to measure waterflow")
  end
  self:logging(3,"Interval: " ..Interval)
end


function QuickApp:setupChildDevices() -- Setup Child Devices
  local cdevs = api.get("/devices?parentId="..self.id) or {} -- Pick up all Child Devices
  function self:initChildDevices() end -- Null function, else Fibaro calls it after onInit()...

  if #cdevs == 0 then -- If no Child Devices, create them
    local initChildData = { 
      {className="consumption", name="Consumption", type="com.fibaro.powerSensor", value=0},
      {className="production", name="Production", type="com.fibaro.powerSensor", value=0},
      {className="todays_consumption", name="Todays Consumption", type="com.fibaro.energyMeter", value=0},
      {className="todays_production", name="Todays Production", type="com.fibaro.energyMeter", value=0},
      {className="gross_consumption", name="Gross Consumption", type="com.fibaro.powerSensor", value=0},
      {className="device_consumption", name="Device Consumption", type="com.fibaro.powerSensor", value=0},
      {className="waterflow", name="Water Flow", type="com.fibaro.multilevelSensor", value=0},
      {className="consumption_high", name="Consumption High", type="com.fibaro.energyMeter", value=0},
      {className="consumption_low", name="Consumption Low", type="com.fibaro.energyMeter", value=0},
      {className="production_high", name="Production High", type="com.fibaro.energyMeter", value=0},
      {className="production_low", name="Production Low", type="com.fibaro.energyMeter", value=0},
      {className="consumption_L1", name="Consumption L1", type="com.fibaro.powerSensor", value=0},
      {className="consumption_L2", name="Consumption L2", type="com.fibaro.powerSensor", value=0},
      {className="consumption_L3", name="Consumption L3", type="com.fibaro.powerSensor", value=0},
      {className="production_L1", name="Production L1", type="com.fibaro.powerSensor", value=0},
      {className="production_L2", name="Production L2", type="com.fibaro.powerSensor", value=0},
      {className="production_L3", name="Production L3", type="com.fibaro.powerSensor", value=0},
      {className="L1_A", name="Ampere L1", type="com.fibaro.multilevelSensor", value=0},
      {className="L2_A", name="Ampere L2", type="com.fibaro.multilevelSensor", value=0},
      {className="L3_A", name="Ampere L3", type="com.fibaro.multilevelSensor", value=0},
      {className="L1_V", name="Voltage L1", type="com.fibaro.multilevelSensor", value=0},
      {className="L2_V", name="Voltage L2", type="com.fibaro.multilevelSensor", value=0},
      {className="L3_V", name="Voltage L3", type="com.fibaro.multilevelSensor", value=0},
      {className="water", name="Water", type="com.fibaro.multilevelSensor", value=0},
      {className="gas", name="Total Gas", type="com.fibaro.multilevelSensor", value=0},
    }
    for _,c in ipairs(initChildData) do
      local child = self:createChildDevice(
        {name = c.name,
          type=c.type,
          value=c.value,
          unit=c.unit,
          initialInterfaces = {},
        },
        _G[c.className] -- Fetch class constructor from class name
      )
      child:setVariable("className",c.className)  -- Save class name so we know when we load it next time
    end   
  else 
    for _,child in ipairs(cdevs) do
      local className = getChildVariable(child,"className") -- Fetch child class name
      local childObject = _G[className](child) -- Create child object from the constructor name
      self.childDevices[child.id]=childObject
      childObject.parent = self -- Setup parent link to device controller 
    end
  end
end


function QuickApp:onInit()
  __TAG = fibaro.getName(plugin.mainDeviceId) .." ID:" ..plugin.mainDeviceId
  self.http = net.HTTPClient({timeout=3000})
  self:debug("onInit")
  self:setupChildDevices() -- Setup the Child Devices
    
  if not api.get("/devices/"..self.id).enabled then
    self:warning("Device", fibaro.getName(plugin.mainDeviceId), "is disabled")
    return
  end
  
  self:getQuickappVariables() -- Get Quickapp Variables or create them
  self:createVariables() -- Create Variables
  self:eDevices() -- Get all Energy Devices
  self:getData() -- Go to getData
end

-- EOF
