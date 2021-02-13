-- QUICKAPP P1 MONITOR 

-- This Quickapp retrieves power consumption, power production and gas usage from the (P1 Monitor) energy and gas meter 

-- Child Devices for Net Consumption, Consumption, Production, Gross Consumption, Device Consumption, Consumption High, Consumption Low, Production High, Production Low, Total Gas, Consumption L1 L2 L3, Ampere L1 L2 L3, Volt L1 L2 L3, Production L1 L2 and L3

-- All power consumption of all HomeCenter devices is summarized
-- The difference between the total power consumption and the power consumption of the HomeCenter devices is put in a unused device (unless the powerID = 0 or empty)

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
   -- Interval = Number in seconds, the P1 Monitor normally is updated every 10 seconds
   -- powerID = ID of the device where you want to capture the 'delta' power, use 0 if you don't want to store the energy consumption
   -- debugLevel = Number (1=some, 2=few, 3=all) (default = 1)

-- Tested on:
   -- P1 Monitor version:202012-1.0.0
   -- Raspberry Pi model:Raspberry Pi 4 Model B Rev 1.1
   -- Linux-5.4.72-v7l+-armv7l-with-debian-10.6
   -- Python versie:3.7.3

-- I use a Smart Meter Cable Starter Kit:
   -- Raspberry Pi 4 Model B Rev 1.1 2GB
   -- 8GB Micro SDHC
   -- Original Raspberry Pi 4B Enclosure
   -- Original Raspberry Pi USB-C 3A power supply
   -- Smart Meter cable
   -- P1 Monitor software from: https://www.ztatz.nl

-- Example content Json table Smartmeter (without values for production)
   --[{"CONSUMPTION_GAS_M3": 6635.825, "CONSUMPTION_KWH_HIGH": 9986.186, "CONSUMPTION_KWH_LOW": 9170.652, "CONSUMPTION_W": 692, "PRODUCTION_KWH_HIGH": 0.0, "PRODUCTION_KWH_LOW": 0.0, "PRODUCTION_W": 0, "RECORD_IS_PROCESSED": 0, "TARIFCODE": "D", "TIMESTAMP_UTC": 1601733693, "TIMESTAMP_lOCAL": "2020-10-03 16:01:33"}]

-- Example content Json table Phase
   --[{"CONSUMPTION_L1_W": 650.0, "CONSUMPTION_L2_W": 0.0, "CONSUMPTION_L3_W": 0.0, "L1_A": 3.0, "L1_V": 224.0, "L2_A": 0.0, "L2_V": 0.0, "L3_A": 0.0, "L3_V": 0.0, "PRODUCTION_L1_W": 0.0, "PRODUCTION_L2_W": 0.0, "PRODUCTION_L3_W": 0.0, "TIMESTAMP_UTC": 1611953641, "TIMESTAMP_lOCAL": "2021-01-29 21:54:01"}]
  

-- No editing of this code is needed 


class 'net_consumption'(QuickAppChild)
function net_consumption:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("net_consumption QuickappChild initiated, deviceId:",self.id)
end
function net_consumption:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.net_consumption)))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", "")
end


class 'consumption'(QuickAppChild)
function consumption:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("consumption QuickappChild initiated, deviceId:",self.id)
end
function consumption:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.consumption)))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", "")
end


class 'production'(QuickAppChild)
function production:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("production QuickappChild initiated, deviceId:",self.id)
end
function production:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.production)))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", "")
end


class 'gross_consumption'(QuickAppChild)
function gross_consumption:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("gross_consumption QuickappChild initiated, deviceId:",self.id)
end
function gross_consumption:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.gross_consumption)))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", "")
end


class 'device_consumption'(QuickAppChild)
function device_consumption:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("device_consumption QuickappChild initiated, deviceId:",self.id)
end
function device_consumption:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.device_consumption)))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", "")
end


class 'consumption_high'(QuickAppChild)
function consumption_high:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("consumption_high QuickappChild initiated, deviceId:",self.id)
end
function consumption_high:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.consumption_high)))
  self:updateProperty("unit", "kWh")
  self:updateProperty("log", "")
end


class 'consumption_low'(QuickAppChild)
function consumption_low:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("consumption_low QuickappChild initiated, deviceId:",self.id)
end
function consumption_low:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.consumption_low)))
  self:updateProperty("unit", "kWh")
  self:updateProperty("log", "")
end


class 'production_high'(QuickAppChild)
function production_high:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("production_high QuickappChild initiated, deviceId:",self.id)
end
function production_high:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.production_high)))
  self:updateProperty("unit", "kWh")
  self:updateProperty("log", "")
end


class 'production_low'(QuickAppChild)
function production_low:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("production_low QuickappChild initiated, deviceId:",self.id)
end
function production_low:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.production_low)))
  self:updateProperty("unit", "kWh")
  self:updateProperty("log", "")
end


class 'gas'(QuickAppChild)
function gas:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("gas QuickappChild initiated, deviceId:",self.id)
end
function gas:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.gas)))
  self:updateProperty("unit", "m³")
  self:updateProperty("log", "")
end


class 'consumption_L1'(QuickAppChild)
function consumption_L1:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("consumption_L1 QuickappChild initiated, deviceId:",self.id)
end
function consumption_L1:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.consumption_L1)))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", "")
end


class 'consumption_L2'(QuickAppChild)
function consumption_L2:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("consumption_L2 QuickappChild initiated, deviceId:",self.id)
end
function consumption_L2:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.consumption_L2)))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", "")
end


class 'consumption_L3'(QuickAppChild)
function consumption_L3:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("consumption_L3 QuickappChild initiated, deviceId:",self.id)
end
function consumption_L3:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.consumption_L3)))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", "")
end


class 'L1_A'(QuickAppChild)
function L1_A:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("L1_A QuickappChild initiated, deviceId:",self.id)
end
function L1_A:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.L1_A)))
  self:updateProperty("unit", "Amp")
  self:updateProperty("log", "")
end


class 'L2_A'(QuickAppChild)
function L2_A:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("L2_A QuickappChild initiated, deviceId:",self.id)
end
function L2_A:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.L2_A)))
  self:updateProperty("unit", "Amp")
  self:updateProperty("log", "")
end


class 'L3_A'(QuickAppChild)
function L3_A:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("L3_A QuickappChild initiated, deviceId:",self.id)
end
function L3_A:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.L3_A)))
  self:updateProperty("unit", "Amp")
  self:updateProperty("log", "")
end


class 'L1_V'(QuickAppChild)
function L1_V:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("L1_V QuickappChild initiated, deviceId:",self.id)
end
function L1_V:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.L1_V)))
  self:updateProperty("unit", "Volt")
  self:updateProperty("log", "")
end


class 'L2_V'(QuickAppChild)
function L2_V:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("L2_V QuickappChild initiated, deviceId:",self.id)
end
function L2_V:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.L2_V)))
  self:updateProperty("unit", "Volt")
  self:updateProperty("log", "")
end


class 'L3_V'(QuickAppChild)
function L3_V:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("L3_V QuickappChild initiated, deviceId:",self.id)
end
function L3_V:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.L3_V)))
  self:updateProperty("unit", "Volt")
  self:updateProperty("log", "")
end


class 'production_L1'(QuickAppChild)
function production_L1:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("production_L1 QuickappChild initiated, deviceId:",self.id)
end
function production_L1:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.production_L1)))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", "")
end


class 'production_L2'(QuickAppChild)
function production_L2:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("production_L2 QuickappChild initiated, deviceId:",self.id)
end
function production_L2:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.production_L2)))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", "")
end


class 'production_L3'(QuickAppChild)
function production_L3:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("production_L3 QuickappChild initiated, deviceId:",self.id)
end
function production_L3:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.production_L3)))
  self:updateProperty("unit", "Watt")
  self:updateProperty("log", "")
end


local function getChildVariable(child,varName)
  for _,v in ipairs(child.properties.quickAppVariables or {}) do
    if v.name==varName then return v.value end
  end
  return ""
end


-- QuickApp Functions


function QuickApp:logging(level,text) -- Logging function for debug
  if tonumber(debugLevel) >= tonumber(level) then 
      self:debug(text)
  end
end


function QuickApp:button1Event() -- Refresh button event
  self:updateView("button1", "text", "Please wait...")
  self:eDevices() -- Get all Energy Devices
  --self:getData() -- Go to getData
  fibaro.setTimeout(5000, function()
    self:updateView("button1", "text", "Update Devicelist")
  end)
end


function QuickApp:consumption() -- Update the energy consumption of all energy devices
  local deviceValue = 0
  local id = 1
  data.device_consumption = 0
  data.gross_consumption = 0
  for key, id in pairs(eDevices) do
    if fibaro.getValue(id, "power") and id~=powerID then
      deviceValue = fibaro.getValue(id, "power")
      --self:logging(3,fibaro.getName(id) .." (ID " ..id .."): " ..deviceValue .." Watt")
      data.device_consumption = data.device_consumption + deviceValue
    end
  end
  data.gross_consumption = tonumber(data.net_consumption) - data.device_consumption -- Measured power usage minus power usage from all devices
  if powerID == 0 or powerID == nil then
    --self:warning("No powerID to store net power consumption")
  else
    api.put("/devices/"..powerID, {["properties"]={["power"]=data.gross_consumption}}) -- Put gross_consumption into device with powerID
  end
end


function QuickApp:valuesPhase() -- Get the values from json file Phase
  self:logging(3,"valuesPhase")
  data.consumption_L1 = string.format("%.1f",jsonTable.CONSUMPTION_L1_W)
  data.consumption_L2 = string.format("%.1f",jsonTable.CONSUMPTION_L2_W)
  data.consumption_L3 = string.format("%.1f",jsonTable.CONSUMPTION_L3_W)
  data.L1_A = string.format("%.1f",jsonTable.L1_A)
  data.L2_A = string.format("%.1f",jsonTable.L2_A)
  data.L3_A = string.format("%.1f",jsonTable.L3_A)
  data.L1_V = string.format("%.1f",jsonTable.L1_V)
  data.L2_V = string.format("%.1f",jsonTable.L2_V)
  data.L3_V = string.format("%.1f",jsonTable.L3_V)  data.production_L1 = string.format("%.1f",jsonTable.PRODUCTION_L1_W)
  data.production_L2 = string.format("%.1f",jsonTable.PRODUCTION_L2_W)
  data.production_L3 = string.format("%.1f",jsonTable.PRODUCTION_L3_W)
end


function QuickApp:updateLabels() -- Update the labels
  local labelText = ""
  labelText = labelText .."Net consumption: " ..data.net_consumption .." Watt " ..data.tarifcodeText .."\n"
  labelText = labelText .."Consumption: " ..data.consumption .." Watt" .."\n" 
  labelText = labelText .."Production: " ..data.production .." Watt" .."\n\n"
  
  labelText = labelText .."Gross consumption: " ..data.gross_consumption .." Watt" .."\n"
  labelText = labelText .."Device consumption: " ..data.device_consumption .." Watt" .."\n\n"
  
  labelText = labelText .."Totals:" .."\n" 
  labelText = labelText .."Consumption high: " ..data.consumption_high .." kWh" .."\n" 
  labelText = labelText .."Consumption low: " ..data.consumption_low .." kWh" .."\n"
  labelText = labelText .."Consumption: " ..data.total_consumption .." kWh" .."\n" 
  labelText = labelText .."Production high: " ..data.production_high .." kWh" .."\n" 
  labelText = labelText .."Producton low: " ..data.production_low .." kWh" .."\n"
  labelText = labelText .."Production: " ..data.total_production .." kWh" .."\n"
  labelText = labelText .."Gas: " ..data.gas .." m³" .."\n\n"
  
  labelText = labelText .."Consumption:" .."\n"
  labelText = labelText .."L1: " ..data.consumption_L1 .." - L2: " ..data.consumption_L2 .." - L3: " ..data.consumption_L3 .." Watt " .."\n\n"
  
  labelText = labelText .."Ampere:" .."\n"
  labelText = labelText .."L1: " ..data.L1_A .." - L2: " ..data.L2_A .." - L3: " ..data.L3_A .." Amp " .."\n\n"
  
  labelText = labelText .."Voltage:" .."\n"
  labelText = labelText .."L1: " ..data.L1_V .." - L2: " ..data.L2_V .." - L3: " ..data.L3_V .." Volt " .."\n\n"
  
  labelText = labelText .."Production" .."\n"
  labelText = labelText .."L1: " ..data.production_L1 .." - L2: " ..data.production_L2 .." - L3: " ..data.production_L3 .." Watt " .."\n"

  self:updateView("label1", "text", labelText)
  self:updateProperty("log", "")
  self:logging(2,labelText)
end


function QuickApp:valuesSmartmeter() -- Get the values from json file Smartmeter
  data.consumption = string.format("%.1f",jsonTable.CONSUMPTION_W)
  data.consumption_high = string.format("%.3f",jsonTable.CONSUMPTION_KWH_HIGH)
  data.consumption_low = string.format("%.3f",jsonTable.CONSUMPTION_KWH_LOW)
  data.production = string.format("%.1f",jsonTable.PRODUCTION_W)
  data.production_high = string.format("%.3f",jsonTable.PRODUCTION_KWH_HIGH)
  data.production_low = string.format("%.3f",jsonTable.PRODUCTION_KWH_LOW)
  data.gas = string.format("%.3f",jsonTable.CONSUMPTION_GAS_M3)
  data.net_consumption = string.format("%.1f",jsonTable.CONSUMPTION_W - jsonTable.PRODUCTION_W)
  data.total_consumption = string.format("%.3f",(jsonTable.CONSUMPTION_KWH_HIGH + jsonTable.CONSUMPTION_KWH_LOW))
  data.total_production = string.format("%.3f",(jsonTable.PRODUCTION_KWH_HIGH + jsonTable.PRODUCTION_KWH_LOW))
  data.tarifcode = jsonTable.TARIFCODE

  if data.tarifcode == "P" then
    data.tarifcodeText = "(High)"
  elseif data.tarifcode == "D" then
    data.tarifcodeText = "(Low)"
  else
    data.tarifcodeText = ""
  end
end


function QuickApp:getData() -- Get data from P1 Monitor 
  local url = "http://" ..IPaddress ..Path
  self:logging(3,"url: " ..url)
  self.http:request(url, {
  options = {
    headers = {Accept = "application/json"}, method = 'GET'},
    success = function(response)
      self:logging(3,"Response status: " ..response.status)
      self:logging(3,"Response data: " ..response.data)

      local apiResult = response.data        
      apiResult = apiResult:gsub("%[", "") -- clean up the apiResult by removing [
      apiResult = apiResult:gsub("%]", "") -- clean up the apiResult by removing [
      jsonTable = json.decode(apiResult) -- Decode the json string from api to lua-table

      self:logging(3,"Mode prev: " ..Mode)
      if Mode == "Smartmeter" then
        self:valuesSmartmeter() -- Get the values from json file Smartmeter
        self:consumption() -- Store net consumption in unused device 
        Path = pathPhase
        Mode = "Phase"
      else
        self:valuesPhase() -- Get the values from json file Phase
        Path = pathSmartmeter
        Mode = "Smartmeter"
      end
      self:logging(3,"Mode next: " ..Mode)

      self:updateLabels() -- Update the labels
      self:updateChildDevices() -- Update the Child Devices

    end,
    error = function(error)
      self:error("error: " ..json.encode(error))
      self:updateProperty("log", "error: " ..json.encode(error))
    end
  }) 
  fibaro.setTimeout((Interval/2)*1000, function() -- Checks every [Interval] seconds for new data (two loops)
    self:getData()
  end)
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
  pathPhase = "/api/v1/phase?limit=1&json=object" -- Default path Phase
  Path = pathSmartmeter -- Set initial value
  Mode = "Smartmeter" -- Set initial value
  data = {}
  data.consumption_L1 = "0" 
  data.consumption_L2 = "0" 
  data.consumption_L3 = "0" 
  data.L1_A = "0" 
  data.L2_A = "0" 
  data.L3_A = "0"   
  data.L1_V = "0" 
  data.L2_V = "0" 
  data.L3_V = "0" 
  data.production_L1 = "0" 
  data.production_L2 = "0" 
  data.production_L3 = "0" 
  data.device_consumption = 0
  data.gross_consumption = 0
end


function QuickApp:getQuickappVariables() -- Get all Quickapp Variables or create them
  IPaddress = self:getVariable("IPaddress")
  powerID = tonumber(self:getVariable("powerID"))
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
end



function QuickApp:updateChildDevices()
  for id,child in pairs(self.childDevices) do -- Update Child Devices
    child:updateValue(data) 
  end
end


function QuickApp:setupChildDevices() -- Setup Child Devices
  local cdevs = api.get("/devices?parentId="..self.id) or {} -- Pick up all Child Devices
  function self:initChildDevices() end -- Null function, else Fibaro calls it after onInit()...

  if #cdevs == 0 then -- If no Child Devices, create them
    local initChildData = { 
      {className="net_consumption", name="Net Consumption", type="com.fibaro.multilevelSensor", value=0, unit="Watt"},
      {className="consumption", name="Consumption", type="com.fibaro.multilevelSensor", value=0, unit="Watt"},
      {className="production", name="Production", type="com.fibaro.multilevelSensor", value=0, unit="Watt"},
      {className="gross_consumption", name="Gross Consumption", type="com.fibaro.multilevelSensor", value=0, unit="Watt"},
      {className="device_consumption", name="Device Consumption", type="com.fibaro.multilevelSensor", value=0, unit="Watt"},
      {className="consumption_high", name="Consumption High", type="com.fibaro.multilevelSensor", value=0, unit="kWh"},
      {className="consumption_low", name="Consumption Low", type="com.fibaro.multilevelSensor", value=0, unit="kWh"},
      {className="production_high", name="Production High", type="com.fibaro.multilevelSensor", value=0, unit="kWh"},
      {className="production_low", name="Production Low", type="com.fibaro.multilevelSensor", value=0, unit="kWh"},
      {className="gas", name="Total Gas", type="com.fibaro.multilevelSensor", value=0, unit="m³"},
      {className="consumption_L1", name="Consumption L1", type="com.fibaro.multilevelSensor", value=0, unit="Watt"},
      {className="consumption_L2", name="Consumption L2", type="com.fibaro.multilevelSensor", value=0, unit="Watt"},
      {className="consumption_L3", name="Consumption L3", type="com.fibaro.multilevelSensor", value=0, unit="Watt"},
      {className="L1_A", name="Ampere L1", type="com.fibaro.multilevelSensor", value=0, unit="Amp"},
      {className="L2_A", name="Ampere L2", type="com.fibaro.multilevelSensor", value=0, unit="Amp"},
      {className="L3_A", name="Ampere L3", type="com.fibaro.multilevelSensor", value=0, unit="Amp"},
      {className="L1_V", name="Voltage L1", type="com.fibaro.multilevelSensor", value=0, unit="Volt"},
      {className="L2_V", name="Voltage L2", type="com.fibaro.multilevelSensor", value=0, unit="Volt"},
      {className="L3_V", name="Voltage L3", type="com.fibaro.multilevelSensor", value=0, unit="Volt"},
      {className="production_L1", name="Production L1", type="com.fibaro.multilevelSensor", value=0, unit="Watt"},
      {className="production_L2", name="Production L2", type="com.fibaro.multilevelSensor", value=0, unit="Watt"},
      {className="production_L3", name="Production L3", type="com.fibaro.multilevelSensor", value=0, unit="Watt"},
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
    self:getQuickappVariables() -- Get Quickapp Variables or create them
    self:createVariables() -- Create Variables
    self:eDevices() -- Get all Energy Devices
    self:getData() -- Go to getData
end

-- EOF