require 'wombat'
require 'awesome_print'
require 'json'

MAX_CNT = 2000
PER_PAGE = 50

API_KEY = 'AIzaSyAtGR4aPW5I_UreyjuvUaJdLL0N_LqSPdw'

# MAX_CNT = 10
# PER_PAGE = 10

class Crawler
  include Wombat::Crawler
  base_url "https://www.corcoran.com"
  path "/nyc/Search/Listings?SaleType=Rent&Page=0&count=#{PER_PAGE}"

  list 'css=div.info>.address>a', :follow do
    title 'xpath=//*[@id="all-breadcrumb"]' do |e|
      e.split(/\s/).reject {|e| e == "" }[0..-4].join('+')
    end
  end
end

# (1..MAX_CNT / PER_PAGE).to_a.each do |i|
#   puts "job: #{i} begin"
#   data = Crawler.new.crawl
#   File.open("tmp/#{i}.json", 'w+') {|f| f << data.to_json }
#   puts "job: #{i} done"
# end


class Node
  def initialize(data)
    @data = JSON.parse(data)['list']
  end

  def query_address
    return @data.map do |d|
      geolocation d['title']
    end
  end

  def geolocation(address)
    begin
      uri = URI("https://maps.google.cn/maps/api/geocode/json?address=#{address}&key=#{API_KEY}")
      res = Net::HTTP.get_response uri
      json_body = JSON.parse(res.body)['results'][0]
      {
        address: json_body['formatted_address'], 
        geometry: json_body['geometry']['location']
      }
    rescue Exception => e
      "Can not reach the google api. #{e}"
    end  
  end
end

arr = []

Dir.glob('tmp/*.json') do |jf|
  puts "=== job start ==="
  arr << Node.new(File.read jf).query_address.reject {|e| e.is_a? String }
  puts "--- job end ---"
end

File.open('tmp/locations/locations.json', 'w+') do |f|
  f << {lists: arr.flatten}.to_json
end