-- Quickapp P1 Monitor childs


class 'consumption'(QuickAppChild)
function consumption:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "consumption" then 
    self:updateProperty("rateType", "consumption")
    self:warning("Changed rateType interface of Todays Consumption child device (" ..self.id ..") to consumption")
  end
end
function consumption:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.consumption)))
  self:updateProperty("power", tonumber(string.format("%.3f",data.consumption)))
  self:updateProperty("unit", translation["Watt"])
  self:updateProperty("log", translation["Max"] .." " ..data.max_consumption .." " ..data.max_consumption_unit .." " ..data.max_consumption_time)
end


class 'production'(QuickAppChild)
function production:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "production" then 
    self:updateProperty("rateType", "production")
    self:warning("Changed rateType interface of Todays Production child device (" ..self.id ..") to production")
  end
end
function production:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.production)))
  self:updateProperty("power", tonumber(string.format("%.3f",data.production)))
  self:updateProperty("unit", translation["Watt"])
  self:updateProperty("log", translation["Max"] .." " ..data.max_production .." " ..data.max_production_unit .." " ..data.max_production_time)
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
  self:updateProperty("unit", translation["kWh"])
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
  self:updateProperty("unit", translation["kWh"])
  self:updateProperty("log", "")
end


class 'waterflow'(QuickAppChild)
function waterflow:__init(dev)
  QuickAppChild.__init(self,dev)
end
function waterflow:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.1f",data.waterflow)))
  self:updateProperty("unit", translation["L/min"])
  self:updateProperty("log", "")
end


class 'consumption_L1'(QuickAppChild)
function consumption_L1:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "consumption" then 
    self:updateProperty("rateType", "consumption")
    self:warning("Changed rateType interface of Todays Consumption child device (" ..self.id ..") to consumption")
  end
end
function consumption_L1:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.consumption_L1)))
  self:updateProperty("power", tonumber(string.format("%.3f",data.consumption_L1)))
  self:updateProperty("unit", translation["Watt"])
  self:updateProperty("log", " ")
end


class 'consumption_L2'(QuickAppChild)
function consumption_L2:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "consumption" then 
    self:updateProperty("rateType", "consumption")
    self:warning("Changed rateType interface of Todays Consumption child device (" ..self.id ..") to consumption")
  end
end
function consumption_L2:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.consumption_L2)))
  self:updateProperty("power", tonumber(string.format("%.3f",data.consumption_L2)))
  self:updateProperty("unit", translation["Watt"])
  self:updateProperty("log", " ")
end


class 'consumption_L3'(QuickAppChild)
function consumption_L3:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "consumption" then 
    self:updateProperty("rateType", "consumption")
    self:warning("Changed rateType interface of Todays Consumption child device (" ..self.id ..") to consumption")
  end
end
function consumption_L3:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.consumption_L3)))
  self:updateProperty("power", tonumber(string.format("%.3f",data.consumption_L3)))
  self:updateProperty("unit", translation["Watt"])
  self:updateProperty("log", " ")
end


class 'production_L1'(QuickAppChild)
function production_L1:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "production" then 
    self:updateProperty("rateType", "production")
    self:warning("Changed rateType interface of Todays Production child device (" ..self.id ..") to production")
  end
end
function production_L1:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.production_L1)))
  self:updateProperty("power", tonumber(string.format("%.3f",data.production_L1)))
  self:updateProperty("unit", translation["Watt"])
  self:updateProperty("log", " ")
end


class 'production_L2'(QuickAppChild)
function production_L2:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "production" then 
    self:updateProperty("rateType", "production")
    self:warning("Changed rateType interface of Todays Production child device (" ..self.id ..") to production")
  end
end
function production_L2:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.production_L2)))
  self:updateProperty("power", tonumber(string.format("%.3f",data.production_L2)))
  self:updateProperty("unit", translation["Watt"])
  self:updateProperty("log", " ")
end


class 'production_L3'(QuickAppChild)
function production_L3:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "production" then 
    self:updateProperty("rateType", "production")
    self:warning("Changed rateType interface of Todays Production child device (" ..self.id ..") to production")
  end
end
function production_L3:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.3f",data.production_L3)))
  self:updateProperty("power", tonumber(string.format("%.3f",data.production_L3)))
  self:updateProperty("unit", translation["Watt"])
  self:updateProperty("log", " ")
end


class 'L1_A'(QuickAppChild)
function L1_A:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "consumption" then 
    self:updateProperty("rateType", "consumption")
    self:warning("Changed rateType interface of Todays Consumption child device (" ..self.id ..") to consumption")
  end
end
function L1_A:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.1f",data.L1_A)))
  self:updateProperty("unit", translation["Amp"])
  self:updateProperty("log", "")
end


class 'L2_A'(QuickAppChild)
function L2_A:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "consumption" then 
    self:updateProperty("rateType", "consumption")
    self:warning("Changed rateType interface of Todays Consumption child device (" ..self.id ..") to consumption")
  end
end
function L2_A:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.1f",data.L2_A)))
  self:updateProperty("unit", translation["Amp"])
  self:updateProperty("log", "")
end


class 'L3_A'(QuickAppChild)
function L3_A:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "consumption" then 
    self:updateProperty("rateType", "consumption")
    self:warning("Changed rateType interface of Todays Consumption child device (" ..self.id ..") to consumption")
  end
end
function L3_A:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.1f",data.L3_A)))
  self:updateProperty("unit", translation["Amp"])
  self:updateProperty("log", "")
end


class 'L1_V'(QuickAppChild)
function L1_V:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "consumption" then 
    self:updateProperty("rateType", "consumption")
    self:warning("Changed rateType interface of Todays Consumption child device (" ..self.id ..") to consumption")
  end
end
function L1_V:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.0f",data.L1_V)))
  self:updateProperty("unit", translation["Volt"])
  self:updateProperty("log", "")
end


class 'L2_V'(QuickAppChild)
function L2_V:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "consumption" then 
    self:updateProperty("rateType", "consumption")
    self:warning("Changed rateType interface of Todays Consumption child device (" ..self.id ..") to consumption")
  end
end
function L2_V:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.0f",data.L2_V)))
  self:updateProperty("unit", translation["Volt"])
  self:updateProperty("log", "")
end


class 'L3_V'(QuickAppChild)
function L3_V:__init(dev)
  QuickAppChild.__init(self,dev)
  if fibaro.getValue(self.id, "rateType") ~= "consumption" then 
    self:updateProperty("rateType", "consumption")
    self:warning("Changed rateType interface of Todays Consumption child device (" ..self.id ..") to consumption")
  end
end
function L3_V:updateValue(data) 
  self:updateProperty("value", tonumber(string.format("%.0f",data.L3_V)))
  self:updateProperty("unit", translation["Volt"])
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
  self:updateProperty("unit", translation["kWh"])
  self:updateProperty("log", translation["Today"] .." " ..data.today_consumption_high .." " ..translation["kWh"])
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
  self:updateProperty("unit", translation["kWh"])
  self:updateProperty("log", translation["Today"] .." " ..data.today_consumption_low .." " ..translation["kWh"])
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
  self:updateProperty("unit", translation["kWh"])
  self:updateProperty("log", translation["Today"] .." " ..data.today_production_high .." " ..translation["kWh"])
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
  self:updateProperty("unit", translation["kWh"])
  self:updateProperty("log", translation["Today"] .." " ..data.today_production_low .." " ..translation["kWh"])
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
  self:updateProperty("log", translation["Today"] .." " ..data.today_gas .." m³")
end

-- EOF