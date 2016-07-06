require 'pry'
require 'open-uri'
require 'nokogiri'
require 'launchy'

class Sukajan

  attr_accessor :name, :profile_url, :bids, :price, :shipping, :image_link, :key_word

  @@all = []

  def initialize(name)
    @name = name
  end

  def self.all
    @@all = scrape_sukajans
  end

  def test_open
    Launchy.open("http://google.com")
  end

  private
    def self.scrape_sukajans
      all_sukajans = []
      search = Nokogiri::HTML(open("http://www.ebay.com/sch/Clothing-Shoes-Accessories/11450/i.html?ipg=200&_sop=15&_nkw=sukajan"))
      search.css(".mimg").collect do |item|
        sukajan = Sukajan.new(item.css(".gvtitle h3").text.delete "\n" "\r" "\t")
        sukajan.profile_url = item.css(".gvtitle h3 a").attribute("href").value
        item.css(".gvshipping .ship .bfsp").empty? ? sukajan.shipping = item.css(".gvshipping .amt").text : sukajan.shipping = "Free shipping!"
        if !(item.css(".gvprices .bid").empty?)
          sukajan.bids = item.css(".gvprices .bid .lbl").text
          sukajan.price = item.css(".gvprices .bid .amt").text
        else
          sukajan.bids = "Buy It Now"
          sukajan.price = item.css(".gvprices .bin span .bold").text
        end
        all_sukajans << sukajan
      end
    end

    scrape_sukajans

    binding.pry


end
