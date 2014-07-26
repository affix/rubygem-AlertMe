#!/usr/bin/env ruby

require 'AlertMe'

puts " -- AlertMe API Ruby Binding Demo --"
puts " -- Written by Keiran Smith --"
puts "Logging in"

api = AlertMe.new('your_username', 'your_password', 'RubyAPITest', true)  # You must set to true if using Brittish Gas Hive Active Heating


puts "Retrieving Thermostat Information"
thermostat = api.getDeviceByType("HAHVACThermostat")

thermostat_id = thermostat.first["id"]

firstController = api.getHeatingControllerById(thermostat_id)
therm = firstController["hahvacthermostat"]


puts "-- Temperature Information at #{therm["timeNow"]} --"

puts "Current Temperature : #{therm["currentTemperature"]} #{therm["temperatureUnit"]}"
puts "Target  Temperature : #{therm["targetTemperature"]} #{therm["temperatureUnit"]}"