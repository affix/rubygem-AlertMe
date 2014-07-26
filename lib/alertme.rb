#!/usr/bin/env ruby

require 'uri'
require 'net/http'
require 'json'

class AlertMe

  @hub = nil
  @cookie = nil

  def initialize(username, password, caller, bg = false)
    if bg == true
      @uri = URI("https://api.bgchlivehome.co.uk/v5")
    else 
      @uri = URI("https://api.alertme.com/v5")
    end
    @session = self.login(username, password, caller)
    @username = username
    @password = password
  end

  def login(username, password, caller)
    http = Net::HTTP.new(@uri.host, @uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new("#{@uri.path}/login")
    request.set_form_data({"username" => username, "password" => password, "caller" => caller})

    response = http.request(request)
    all_cookies = response.get_fields('set-cookie')
    cookies_array = Array.new
    all_cookies.each { | cookie |
        cookies_array.push(cookie.split('; ')[0])
    }
    @cookie = cookies_array.join('; ')

    json = JSON.parse(response.body)
    @hub = json["hubIds"].first
  end

  def getDevices
    http = Net::HTTP.new(@uri.host, @uri.port)
    http.use_ssl = true

    header = {'Cookie' => @cookie}

    req = Net::HTTP::Get.new("#{@uri.path}/users/#{@username}/hubs/#{@hub}/devices", header)
    res = http.request(req)
    JSON.parse(res.body)
  end

  def getDeviceByType(type)
    http = Net::HTTP.new(@uri.host, @uri.port)
    http.use_ssl = true

    header = {'Cookie' => @cookie}

    req = Net::HTTP::Get.new("#{@uri.path}/users/#{@username}/hubs/#{@hub}/devices/#{type}", header)
    res = http.request(req)
    JSON.parse(res.body)
  end

  def getHeatingControllerById(id)
    http = Net::HTTP.new(@uri.host, @uri.port)
    http.use_ssl = true

    header = {'Cookie' => @cookie}

    req = Net::HTTP::Get.new("#{@uri.path}/users/#{@username}/hubs/#{@hub}/devices/HeatingController/#{id}", header)
    res = http.request(req)
    JSON.parse(res.body)
  end

  def getHouseholdDetails
    http = Net::HTTP.new(@uri.host, @uri.port)
    http.use_ssl = true

    header = {'Cookie' => @cookie}

    req = Net::HTTP::Get.new("#{@uri.path}/users/#{@username}/householdDetails", header)
    res = http.request(req)
    JSON.parse(res.body)["values"]
  end

end