# Author: Pink Banana

require 'net/http'
require 'nokogiri'
require 'json'

API_KEY = 'AIzaSyAtGR4aPW5I_UreyjuvUaJdLL0N_LqSPdw'

class LocationNode
  def initialize(node)
    @node = node
  end

  def address
    @node.at_xpath('StreetAddress').text
  end

  def city
    @node.at_xpath('City').text
  end

  def state
    @node.at_xpath('State').text
  end

  def zip
    @node.at_xpath('Zip').text
  end

  def query_address
    (address + city + state).gsub(' ', '+')
  end

  def geolocation
    begin
      uri = URI("https://maps.google.cn/maps/api/geocode/json?address=#{query_address}&key=#{API_KEY}")
      res = Net::HTTP.get_response uri
      JSON.parse(res.body)['results'][0]['geometry']['location']
    rescue Exception => e
      "Can not reach the google api."
    end  
  end
end

begin
  uri = URI('http://www.related.com/feeds/ZillowAvailabilities.xml')
  res = Net::HTTP.get_response uri
  xml_doc  = Nokogiri::XML res.body
  xml_doc.xpath('//Location').each do |node|
    location = LocationNode.new(node)
    puts location.geolocation
  end
rescue Exception => e
  puts "Raised an error #{e}"
end