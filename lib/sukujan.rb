require 'pry'
require 'open-uri'
require 'nokogiri'

class Sukajan

  attr_accessor :name, :price, :time_left, :shipping_listed, :profile_url, :image_link, :key_word

  @@all = []

  def initialize
  end

  def self.all
    @@all
  end

  private
    def self.scrape_sukajans
      all_sukajans = []
      search = Nokogiri::HTML(open("http://www.ebay.com/sch/Clothing-Shoes-Accessories/11450/i.html?ipg=200&_sop=15&_nkw=sukajan"))
      search.css(".mimg").collect do |item|
        sukajan = Sukajan.new
        sukajan.name = item.css(".gvtitle h3").text.delete "\n" "\r" "\t"
        sukajan.price = item.css(".gvprices .bin span .bold").text
        sukajan.time_left = item.css(".gvprices .gvformat").text
        if !(item.css(".gvshipping").empty?)
          sukajan.shipping_listed = "Yes, and it's #{item.css(".gvshipping .ship .bfsp").text}"
        else sukajan.shipping_listed = "No, sorry! Try checking out the profile with the profile link provided."
        end
        sukajan.profile_url = item.css(".gvtitle h3 a").attribute("href").value
        @@all << sukajan
      end
      all_sukajans
    end

    scrape_sukajans

    binding.pry

end
