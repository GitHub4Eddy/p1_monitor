-- Quickapp P1 Monitor main


local function getChildVariable(child,varName)
  for _,v in ipairs(child.properties.quickAppVariables or {}) do
    if v.name==varName then return v.value end
  end
  return ""
end


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


function QuickApp:unitCheckWatt(measurement) -- Set the measurement and unit to Watt, Kilowatt, Megawatt or Gigawatt
  self:logging(3,"unitCheckWatt() - Set the measurement and unit to Watt, Kilowatt, Megawatt or Gigawatt")
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


function QuickApp:updateProperties() -- Update the properties
  self:logging(3,"updateProperties() - Update the properties")
  self:updateProperty("value", tonumber(string.format("%.3f",data.net_consumption)))
  self:updateProperty("power", tonumber(string.format("%.3f",data.net_consumption)))
  self:updateProperty("unit", translation["Watt"])
  self:updateProperty("log", data.timestamp_local)
end


function QuickApp:updateLabels() -- Update the labels
  self:logging(3,"updateLabels() - Update the labels")
  local labelText = ""
  labelText = labelText ..translation["Consumption"] ..": " ..data.consumption .." " ..translation["Watt"] .." (" ..translation["Max"] .." " ..data.max_consumption .." " ..data.max_consumption_unit .." " ..translation["at"] .." " ..data.max_consumption_time ..")" .."\n" 
  labelText = labelText ..translation["Production"] ..": " ..data.production .." " ..translation["Watt"] .." (" ..translation["Max"] .." " ..data.max_production .." " ..data.max_production_unit .." " ..translation["at"] .." " ..data.max_production_time ..")"  .."\n"
  labelText = labelText ..translation["Waterflow"] ..": " ..data.waterflow .." " ..translation["L/min"] .."\n\n"
  
  labelText = labelText ..translation["Todays consumption"] ..": " ..data.todays_consumption .." " ..translation["kWh"] .."\n"
  labelText = labelText ..translation["Todays production"] ..": " ..data.todays_production .." " ..translation["kWh"] .."\n\n"
  
  labelText = labelText ..translation["Totals"] ..": " .."\n" 
  labelText = labelText ..translation["Consumption high"] ..": " ..data.consumption_high .." " ..translation["kWh"] .." (" ..translation["Today"] .." " ..data.today_consumption_high .." " ..translation["kWh"] ..")" .."\n" 
  labelText = labelText ..translation["Consumption low"] ..": " ..data.consumption_low .." " ..translation["kWh"] .." (" ..translation["Today"] .." " ..data.today_consumption_low .." " ..translation["kWh"] ..")" .."\n"
  labelText = labelText ..translation["Consumption"] ..": " ..data.total_consumption .." " ..translation["kWh"] .."\n" 
  labelText = labelText ..translation["Production high"] ..": " ..data.production_high .." " ..translation["kWh"] .." (" ..translation["Today"] .." " ..data.today_production_high .." " ..translation["kWh"] ..")" .."\n" 
  labelText = labelText ..translation["Production low"] ..": " ..data.production_low .." " ..translation["kWh"] .." (" ..translation["Today"] .." " ..data.today_production_low .." " ..translation["kWh"] ..")" .."\n"
  labelText = labelText ..translation["Production"] ..": " ..data.total_production .." " ..translation["kWh"]  .."\n"
  labelText = labelText ..translation["Gas"] ..": " ..data.gas .." m³ (" ..translation["Today"] ..": " ..data.today_gas .." m³" .." / " ..translation["Lasthour"] ..": " ..data.lasthour_gas .." L)" .."\n"
  labelText = labelText ..translation["Water"] ..": " ..data.water .." m³" .."\n\n"
  
  labelText = labelText ..translation["Consumption"] ..":" .."\n"
  labelText = labelText ..translation["L1"] ..": " ..data.consumption_L1 .." - " ..translation["L2"] ..": " ..data.consumption_L2 .." - " ..translation["L3"] ..": " ..data.consumption_L3 .." " ..translation["Watt"] .."\n\n"
  
  labelText = labelText ..translation["Production"] .."\n"
  labelText = labelText ..translation["L1"] ..": " ..data.production_L1 .." - " ..translation["L2"] ..": " ..data.production_L2 .." - " ..translation["L3"] ..": " ..data.production_L3 .." " .."Watt" .."\n\n"
  
  labelText = labelText ..translation["Ampere"] ..":" .."\n"
  labelText = labelText ..translation["L1"] ..": " ..data.L1_A .." - " ..translation["L2"] ..": " ..data.L2_A .." - " ..translation["L3"] ..": " ..data.L3_A .." " ..translation["Amp"] .."\n\n"
  
  labelText = labelText ..translation["Voltage"] ..":" .."\n"
  labelText = labelText ..translation["L1"] ..": " ..data.L1_V .." - " ..translation["L2"] ..": " ..data.L2_V .." - " ..translation["L3"] ..": " ..data.L3_V .." " ..translation["Volt"] .."\n\n"

  labelText = labelText ..translation["Updated"] ..": " ..data.timestamp_local .."\n"

  self:updateView("label", "text", labelText)
  self:logging(2,labelText)
end


function QuickApp:valuesWatermeter(jsonTable) -- Get the values from json file Watermeter
  self:logging(3,"valuesWatermeter() - Get the values from json file Watermeter")
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


function QuickApp:valuesStatus(jsonTable) -- Get the values from json file Status
  self:logging(3,"valuesStatus() - Get the values from json file Status")
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


function QuickApp:valuesSmartmeter(jsonTable) -- Get the values from json file Smartmeter
  self:logging(3,"valuesSmartmeter() - Get the values from json file Smartmeter")
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
    data.tarifcodeText = "(" ..translation["High"] ..")"
  elseif data.tarifcode == "D" then
    data.tarifcodeText = "(" ..translation["Low"] ..")"
  else
    data.tarifcodeText = ""
  end

end


function QuickApp:getData() -- Get data from P1 Monitor 
  self:logging(3,"getData() - Get data from P1 Monitor ")
  local url = "http://" ..IPaddress ..path
  self:logging(3,"url: " ..url)
  self.http:request(url, {
  options = {
    headers = {Accept = "application/json"}, method = 'GET'},
    success = function(response)
      self:logging(3,"Response status: " ..response.status)
      self:logging(3,"Response data: " ..response.data)
      local jsonTable = json.decode(response.data) -- Decode the json string from api to lua-table

      self:logging(3,"Mode prev: " ..mode)
      if mode == "Smartmeter" then
        self:valuesSmartmeter(jsonTable) -- Get the values from json file Smartmeter
        path = pathStatus -- Next path
        mode = "Status" -- Next mode
      elseif mode == "Status" then 
        self:valuesStatus(jsonTable) -- Get the values from json file Status
        if waterMeter then
          path = pathWatermeter -- Next path
          mode = "Watermeter" -- Next mode
        else
          path = pathSmartmeter -- Next path
          mode = "Smartmeter" -- Next mode  
        end
      elseif mode == "Watermeter" then
        self:valuesWatermeter(jsonTable) -- Get the values from json file Watermeter
        path = pathSmartmeter -- Next path
        mode = "Smartmeter" -- Next mode  
      end
      self:logging(3,"Mode next: " ..mode)

      self:updateLabels() -- Update the labels
      self:updateProperties() -- Update the properties
      self:updateChildDevices() -- Update the Child Devices

    end,
    error = function(error)
      self:error("error: " ..json.encode(error))
      self:updateProperty("log", "error: " ..json.encode(error))
    end
  }) 
  fibaro.setTimeout(interval, function() self:getData() end) -- Checks every [interval] seconds for new data (three loops: Smartmeter, Status and Watermeter)
end 


function QuickApp:createVariables() -- Setup the global variables
  self:logging(2,"createVariables() - Setup the global variables")
  pathSmartmeter = "/api/v1/smartmeter?limit=1&json=object" -- Default path Smartmeter
  pathStatus = "/api/v1/status?json=object" -- Default path Status
  pathWatermeter = "/api/v2/watermeter/minute?limit=2&sort=des&json=object" -- Default path Watermeter
  path = pathSmartmeter -- Set initial value for path
  mode = "Smartmeter" -- Set initial value for mode
  translation = i18n:translation(string.lower(self:getVariable("language"))) -- Initialise the translation

  data = {}
  data.consumption = "0"
  data.production = "0"
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
  waterMeter = string.lower(self:getVariable("waterMeter"))
  local language = string.lower(self:getVariable("language"))
  interval = tonumber(self:getVariable("interval")) 
  debugLevel = tonumber(self:getVariable("debugLevel"))

  -- Check existence of the mandatory variables, if not, create them with default values 
  if IPaddress == "" or IPaddress == nil then 
    IPaddress = "192.168.1.120" -- Default IPaddress 
    self:setVariable("IPaddress", IPaddress)
    self:trace("Added QuickApp variable IPaddress")
  end
  if waterMeter == "" or waterMeter == nil then 
    waterMeter = "false" -- Default availability of waterMeter is "false"
    self:setVariable("waterMeter",waterMeter)
    self:trace("Added QuickApp variable waterMeter")
  end  
  if language == "" or language == nil or (language ~= "en" and language ~= "nl" and language ~= "fr" and language ~= "pl") then
    language = "en" 
    self:setVariable("language",language)
    self:trace("Added QuickApp variable language")
  end
  if interval == "" or interval == nil then
    interval = "10" -- Default interval in seconds (The P1 meter normally reads every 10 seconds)
    self:setVariable("interval", interval)
    self:trace("Added QuickApp variable interval")
    interval = tonumber(interval)
  end
  if debugLevel == "" or debugLevel == nil then
    debugLevel = "1" -- Default value for debugLevel response in seconds
    self:setVariable("debugLevel",debugLevel)
    self:trace("Added QuickApp variable debugLevel")
    debugLevel = tonumber(debugLevel)
  end
  if waterMeter == "true" then 
    waterMeter = true 
  else
    waterMeter = false
  end
  if waterMeter then
    interval = tonumber(string.format("%.0f",(interval*1000/3)))
  else
    interval = tonumber(string.format("%.0f",(interval*1000/2)))
    self:warning("No waterMeter to measure waterflow")
  end
  self:logging(3,"interval: " ..interval)
end


function QuickApp:setupChildDevices() -- Setup Child Devices
  local cdevs = api.get("/devices?parentId="..self.id) or {} -- Pick up all Child Devices
  function self:initChildDevices() end -- Null function, else Fibaro calls it after onInit()...

  if #cdevs == 0 then -- If no Child Devices, create them
    local initChildData = { 
      {className="consumption", name="Consumption", type="com.fibaro.powerMeter", value=0},
      {className="production", name="Production", type="com.fibaro.powerMeter", value=0},
      {className="todays_consumption", name="Todays Consumption", type="com.fibaro.energyMeter", value=0},
      {className="todays_production", name="Todays Production", type="com.fibaro.energyMeter", value=0},
      {className="waterflow", name="Water Flow", type="com.fibaro.waterMeter", value=0},
      {className="consumption_high", name="Consumption High", type="com.fibaro.energyMeter", value=0},
      {className="consumption_low", name="Consumption Low", type="com.fibaro.energyMeter", value=0},
      {className="production_high", name="Production High", type="com.fibaro.energyMeter", value=0},
      {className="production_low", name="Production Low", type="com.fibaro.energyMeter", value=0},
      {className="consumption_L1", name="Consumption L1", type="com.fibaro.powerMeter", value=0},
      {className="consumption_L2", name="Consumption L2", type="com.fibaro.powerMeter", value=0},
      {className="consumption_L3", name="Consumption L3", type="com.fibaro.powerMeter", value=0},
      {className="production_L1", name="Production L1", type="com.fibaro.powerMeter", value=0},
      {className="production_L2", name="Production L2", type="com.fibaro.powerMeter", value=0},
      {className="production_L3", name="Production L3", type="com.fibaro.powerMeter", value=0},
      {className="L1_A", name="Ampere L1", type="com.fibaro.electricMeter", value=0},
      {className="L2_A", name="Ampere L2", type="com.fibaro.electricMeter", value=0},
      {className="L3_A", name="Ampere L3", type="com.fibaro.electricMeter", value=0},
      {className="L1_V", name="Voltage L1", type="com.fibaro.electricMeter", value=0},
      {className="L2_V", name="Voltage L2", type="com.fibaro.electricMeter", value=0},
      {className="L3_V", name="Voltage L3", type="com.fibaro.electricMeter", value=0},
      {className="water", name="Water", type="com.fibaro.waterMeter", value=0},
      {className="gas", name="Total Gas", type="com.fibaro.gasMeter", value=0},
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
  self:getData() -- Go to getData
end

-- EOF