-- QUICKAPP P1 MONITOR 

-- This Quickapp retrieves power consumption, power production and gas usage from the (P1 Monitor) energy and gas meter 
-- All power consumption of all HomeCenter devices is summarized
-- The difference between the total power consumption and the power consumption of the HomeCenter devices is put in a unused device (unless the powerID = 0 or empty)
-- In the QuickApp labels power consumption, power production and gas usage is shown 
-- The net consumption is also shown in de log (under the icon)


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
   -- Path = Path behind the IP address, normally /api/v1/smartmeter?limit=1&json=object
   -- Interval = Number in seconds, the P1 Monitor normally is updated every 10 seconds
   -- powerID = ID of the device where you want to capture the 'delta' power, use 0 if you don't want to store the energy consumption
   -- debugLevel = Number (1=some, 2=few, 3=all) (default = 1)

-- I use a Smart Meter Cable Starter Kit:
   -- Raspberry Pi 4 Model B Rev 1.1 2GB
   -- 8GB Micro SDHC
   -- Original Raspberry Pi 4B Enclosure
   -- Original Raspberry Pi USB-C 3A power supply
   -- Smart Meter cable
   -- P1 Monitor software from: https://www.ztatz.nl

-- Example content Json table (without values for production)
   --[{"CONSUMPTION_GAS_M3": 6635.825, "CONSUMPTION_KWH_HIGH": 9986.186, "CONSUMPTION_KWH_LOW": 9170.652, "CONSUMPTION_W": 692, "PRODUCTION_KWH_HIGH": 0.0, "PRODUCTION_KWH_LOW": 0.0, "PRODUCTION_W": 0, "RECORD_IS_PROCESSED": 0, "TARIFCODE": "D", "TIMESTAMP_UTC": 1601733693, "TIMESTAMP_lOCAL": "2020-10-03 16:01:33"}]


-- No editing of this code is needed 


function QuickApp:logging(level,text) -- Logging function for debug
  if tonumber(debugLevel) >= tonumber(level) then 
      self:debug(text)
  end
end


function QuickApp:button1Event() -- Refresh button event
  self:updateView("button1", "text", "Please wait...")
  self:onInit()
  fibaro.setTimeout(3000, function()
    self:updateView("button1", "text", "Update Devicelist")
  end)
end


function QuickApp:updateConsumption() -- Update the energy consumption of all energy devices
  local deviceValue = 0
  local id = 1
  device_consumption = 0
  gross_consumption = 0
  for key, id in pairs(eDevices) do
    if fibaro.getValue(id, "power") and id~=powerID then
      deviceValue = fibaro.getValue(id, "power")
      self:logging(3,fibaro.getName(id) .." (ID " ..id .."): " ..deviceValue .." Watt")
      device_consumption = device_consumption + deviceValue
    end
  end
  gross_consumption = tonumber(net_consumption) - device_consumption -- Measured power usage minus power usage from all devices
  if powerID == 0 or powerID == nil then
    --self:warning("No powerID to store net power consumption")
  else
    api.put("/devices/"..powerID, {["properties"]={["power"]=gross_consumption}}) -- Put gross_consumption into device with powerID
  end
end


function QuickApp:updateProperties() -- Update the properties
  self:updateProperty("log", "Net: " ..net_consumption .."W " ..tarifcodeText)
end


function QuickApp:updateLabels() -- Update the labels
  local labelText = "Net consumption: " ..net_consumption .." Watt " ..tarifcodeText .."\n\n"
  labelText = labelText .."Consumption: " ..consumption .." Watt" .."\n" 
  labelText = labelText .."Production: " ..production .." Watt" .."\n"
  labelText = labelText .."Net consumption: " ..net_consumption .." Watt " .."\n\n"
  labelText = labelText .."Gross consumption: " ..gross_consumption .." Watt" .."\n"
  labelText = labelText .."Device consumption: " ..device_consumption .." Watt" .."\n\n"
  labelText = labelText .."Total consumption high: " ..consumption_high .." kWh" .."\n" 
  labelText = labelText .."Total consumption low: " ..consumption_low .." kWh" .."\n"
  labelText = labelText .. "Total consumption: " ..total_consumption .." kWh" .."\n" 
  labelText = labelText .."Total production high: " ..production_high .." kWh" .."\n" 
  labelText = labelText .."Total producton low: " ..production_low .." kWh" .."\n"
  labelText = labelText .."Total production: " ..total_production .." kWh" .."\n"
  labelText = labelText .."Total gas: " ..gas .." M3"

  self:updateView("label1", "text", labelText)
  self:logging(2,labelText)
end


function QuickApp:getValues() -- Get the values from json file
  consumption = string.format("%.1f",jsonTable.CONSUMPTION_W)
  consumption_high = string.format("%.3f",jsonTable.CONSUMPTION_KWH_HIGH)
  consumption_low = string.format("%.3f",jsonTable.CONSUMPTION_KWH_LOW)
  production = string.format("%.1f",jsonTable.PRODUCTION_W)
  production_high = string.format("%.3f",jsonTable.PRODUCTION_KWH_HIGH)
  production_low = string.format("%.3f",jsonTable.PRODUCTION_KWH_LOW)
  gas = string.format("%.3f",jsonTable.CONSUMPTION_GAS_M3)
  net_consumption = string.format("%.1f",jsonTable.CONSUMPTION_W - jsonTable.PRODUCTION_W)
  total_consumption = string.format("%.3f",(jsonTable.CONSUMPTION_KWH_HIGH + jsonTable.CONSUMPTION_KWH_LOW))
  total_production = string.format("%.3f",(jsonTable.PRODUCTION_KWH_HIGH + jsonTable.PRODUCTION_KWH_LOW))
  tarifcode = jsonTable.TARIFCODE

  if tarifcode == "P" then
    tarifcodeText = "(High)"
  elseif tarifcode == "D" then
    tarifcodeText = "(Low)"
  else
    tarifcodeText = ""
  end
end


function QuickApp:getData() -- Get data from P1 Monitor
  local url = "http://" ..IPaddress ..Path
  self.http:request(url, {
    options={
    headers = {Accept = "application/json"}, method = 'GET'},
      success = function(response)
        self:logging(3,"response status:" ..response.status)

        local apiResult = response.data
        apiResult = apiResult:gsub("%[", "") -- clean up the apiResult by removing [
        apiResult = apiResult:gsub("%]", "") -- clean up the apiResult by removing [
        self:logging(3,"apiResult" ..apiResult)
            
        jsonTable = json.decode(apiResult) -- Decode the json string from api to lua-table

        self:getValues() -- Get the values from json file
        self:updateConsumption() -- Store net consumption in unused device
        self:updateLabels() -- Update the labels
        self:updateProperties() -- Update the properties

      end,
      error = function(error)
      self:error("error: " ..json.encode(error))
      self:updateProperty("log", "error: " ..json.encode(error))
    end
    }) 
    fibaro.setTimeout(Interval*1000, function() -- Checks every [Interval] seconds for new data
    self:getData()
  end)
end 


function QuickApp:geteDevices() -- Get all Device IDs which measure Energy Consumption
  eDevices = {}
  local devices, status = api.get("/devices?interface=energy")
  self:trace("Updated devicelist devices with energy consumption")
  for k in pairs(devices) do
    table.insert(eDevices,devices[k].id)
  end
  self:logging(2,"Energy Devices: " ..json.encode(eDevices))
end


function QuickApp:getGlobals() -- Get all Global Variables or create them
  IPaddress = self:getVariable("IPaddress")
  Path = self:getVariable("Path")
  powerID = tonumber(self:getVariable("powerID"))
  Interval = tonumber(self:getVariable("Interval")) 
  debugLevel = tonumber(self:getVariable("debugLevel"))

  -- Check existence of the mandatory variables, if not, create them with default values 
  if IPaddress == "" or IPaddress == nil then 
    IPaddress = "192.168.1.120" -- Default IPaddress 
    self:setVariable("IPaddress", IPaddress)
    self:trace("Added QuickApp variable IPaddress")
  end
  if Path == "" or Path == nil then 
    Path = "/api/v1/smartmeter?limit=1&json=object" -- Default path
    self:setVariable("Path", Path)
    self:trace("Added QuickApp variable Path")
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


function QuickApp:onInit()
    __TAG = fibaro.getName(plugin.mainDeviceId) .." ID:" ..plugin.mainDeviceId
    self.http = net.HTTPClient({timeout=3000})
    self:debug("onInit")
    self:getGlobals() -- Get Global Variables
    self:geteDevices() -- Get all Energy Devices
    self:getData() -- Get data from P1 Monitor
end

-- EOF
