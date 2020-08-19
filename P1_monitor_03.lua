-- QUICKAPP P1 MONITOR 

-- This Quickapp retrieves power consumption, power production and gas usage from the (P1 Monitor) energy and gas meter 
-- All power consumption of all HomeCenter devices is summerized
-- The difference between the total power consumption and the power consumption of the HomeCenter devices is put in a unused device (unless the powerID = 0 or empty)
-- In the QuickApp labels power consumption, power production and gas usage is shown 
-- The netto consumption is also shown in de log (under the icon)

-- Version 0.3 (16th August 2020)
-- Added Quickapp variables for easy configuration
-- Added power production
-- Changed method of adding QuickApp variables, so they can be edited
-- I use a Smart Meter Cable Starter Kit:
-- Raspberry Pi 4 2GB
-- 8GB Micro SDHC
-- Original Raspberry Pi 4B Enclosure
-- Original Raspberry Pi USB-C 3A power supply

-- With the P1 Monitor configuration from: https://www.ztatz.nl

-- Example content Json table (Without production)
-- {"CONSUMPTION_GAS_M3": 6539.998, "CONSUMPTION_KWH_HIGH": 9549.688, "CONSUMPTION_KWH_LOW": 8735.424, "CONSUMPTION_W": 704, "PRODUCTION_KWH_HIGH": 0.0, "PRODUCTION_KWH_LOW": 0.0, "PRODUCTION_W": 0, "RECORD_IS_PROCESSED": 0, "TARIFCODE": "P", "TIMESTAMP_UTC": 1597135675, "TIMESTAMP_lOCAL": "2020-08-11 10:47:55"}

function QuickApp:onInit()
    __TAG = "P1_MONITOR_"..self.id
    self.http = net.HTTPClient({timeout=3000})
    self:debug("onInit")

    IPaddress = self:getVariable("IPaddress")
    Path = self:getVariable("Path")
    powerID = tonumber(self:getVariable("powerID"))
    maxNodeID = tonumber(self:getVariable("maxNodeID"))
    Interval = tonumber(self:getVariable("Interval")) 

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
      powerID = "57" -- ID of the device where you want to capture the 'delta' power, use 0 if you don't want the storage
      self:setVariable("powerID", powerID)
      self:trace("Added QuickApp variable powerID")
      powerID = tonumber(powerID)
    end
    if maxNodeID == "" or maxNodeID == nil then 
      maxNodeID = "350" -- maximum node ID in your z-wave network (uses to summerize power consumption of your devices)
      self:setVariable("maxNodeID", maxNodeID)
      self:trace("Added QuickApp variable maxNodeID")
      maxNodeID = tonumber(maxNodeID)
    end
    if Interval == "" or Interval == nil then
      Interval = "9" -- Default interval in seconds (The P1 meter normally reads every 10 seconds)
      self:setVariable("Interval", Interval)
      self:trace("Added QuickApp variable Interval")
      Interval = tonumber(Interval)
    end

    if powerID == 0 or powerID == nil then
      self:warning("No powerID to store netto power consumption")
    end

    self:loop("")
end

function QuickApp:loop(text)

  local url = "http://" ..IPaddress ..Path

  --self:debug("-------------- P1 MONITOR --------------")
    
  self.http:request(url, {
    options={
    headers = {Accept = "application/json"}, method = 'GET'},
      success = function(response)
        --self:debug("response status:", response.status) 
        --self:debug("headers:", response.headers["Content-Type"]) 

        local apiResult = response.data
        apiResult = apiResult:gsub("%[", "") -- clean up the apiResult by removing [
        apiResult = apiResult:gsub("%]", "") -- clean up the apiResult by removing [
        --self:debug("apiResult",apiResult)
            
        local jsonTable = json.decode(apiResult) -- Decode the json string from api to lua-table
        --self:debug("jsonTable",jsonTable)

        -- Get the values
        local act_consumption = string.format("%.2f",jsonTable.CONSUMPTION_W)
        local act_consumption_high = string.format("%.2f",jsonTable.CONSUMPTION_KWH_HIGH)
        local act_consumption_low = string.format("%.2f",jsonTable.CONSUMPTION_KWH_LOW)
        local act_production = string.format("%.2f",jsonTable.PRODUCTION_W)
        local act_production_high = string.format("%.2f",jsonTable.PRODUCTION_KWH_HIGH)
        local act_production_low = string.format("%.2f",jsonTable.PRODUCTION_KWH_LOW)
        local act_gas = string.format("%.2f",jsonTable.CONSUMPTION_GAS_M3)
        local netto_consumption = string.format("%.2f",jsonTable.CONSUMPTION_W - jsonTable.PRODUCTION_W)
        local total_consumption = string.format("%.2f",(jsonTable.CONSUMPTION_KWH_HIGH + jsonTable.CONSUMPTION_KWH_LOW))
        local total_production = string.format("%.2f",(jsonTable.PRODUCTION_KWH_HIGH + jsonTable.PRODUCTION_KWH_LOW))
     
        -- Debug messages
        --self:debug("Netto consumption: ",netto_consumption .." Watt")
        --self:debug("Actual consumption high: ",act_consumption_high .. " kWh")
        --self:debug("Actual consumption low: ",act_consumption_low .." kWh")
        --self:debug("Total consumption: ",total_consumption .." kW")
        --self:debug("Actual production high: ",act_production_high .." kWh")
        --self:debug("Actual production low: ",act_production_low .." kWh")
        --self:debug("Total production: ",total_production .." kW")
        --self:debug("Actual gas: ",act_gas .." M3")

        -- Update the labels
        self:updateView("label1", "text", "Netto consumption: " ..netto_consumption .." Watt")
        self:updateView("label2", "text", "Actual consumption high: " ..act_consumption_high .." kWh") 
        self:updateView("label3", "text", "Actual consumption low: " ..act_consumption_low .." kWh")
        self:updateView("label4", "text", "Actual gas: " ..act_gas .." M3")
        self:updateView("label5", "text", "Total consumption: " ..total_consumption .." kW")
        self:updateView("label6", "text", "Actual production high: " ..act_production_high .." kWh") 
        self:updateView("label7", "text", "Actual producton low: " ..act_production_low .." kWh") 
        self:updateView("label8", "text", "Total production: " ..total_production .." kW")

        -- Update the property
        self:updateProperty("log", "Netto: " ..netto_consumption .." Watt")

        -- Store netto consumption in unused device
        local i = 0
        local total_devices = 0
        local deviceValue = 0
        local delta_power = 0
        if powerID == 0 or powerID == nil then
          --self:debug("No powerID to store netto power consumption")
        else
          for i = 0, maxNodeID do -- Collect the used power of all devices up till maxNodeID
            if fibaro.getValue(i, "power") and i~=powerID then
              deviceValue = fibaro.getValue(i, "power")
              total_devices = total_devices + deviceValue
            end
          end
          --self:debug("netto consumption", netto_consumption)
          delta_power = tonumber(netto_consumption) - total_devices -- Measured power usage minus power usage from all devices
          --self:debug("Delta power: ",delta_power .." Watt")
          api.put("/devices/"..powerID, {["properties"]={["power"]=delta_power}}) -- Put delta power into device with powerID
        end

      end,
      error = function(error)
      self:error("error: " ..json.encode(error))
      self:updateProperty("log", "error: " ..json.encode(error))
    end
    }) 
    fibaro.setTimeout(Interval*1000, function() -- Checks every n seconds for new data
    self:loop(text)
  end)
end 
