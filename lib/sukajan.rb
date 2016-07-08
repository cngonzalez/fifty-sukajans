require 'pry'
require 'open-uri'
require 'nokogiri'
require 'launchy'

class Sukajan

  @@all = []

  attr_accessor :name, :profile_url, :bids, :price, :shipping, :image_link, :number

  def initialize(name)
    @name = name
  end

  def self.all
    @@all
  end

  def self.url_options(option)
    option_hash = {
      "CHEAPEST" => "http://www.ebay.com/sch/Clothing-Shoes-Accessories/11450/i.html?ipg=200&_sop=15&_nkw=sukajan",
      "TOP RANKED" => "http://www.ebay.com/sch/i.html?_nkw=sukajan&ipg=200",
      "ENDING SOON" => "http://www.ebay.com/sch/i.html?ipg=200&_sop=1&_nkw=sukajan&rt=nc"
    }
    option_hash[option]
  end

  def self.name_scraping
    words = all.collect{|jacket| jacket.name.downcase.split(" ")}.flatten
    frequency = words.each_with_object(Hash.new(0)) {|word, counts| counts[word] += 1}
  end

  def self.sample_keywords
    samples = name_scraping.sort_by{|k,v| v}.reverse[10..15].to_h.keys
    samples.join(", ")
  end

  def self.keyword_search(keyword)
    all.select {|jacket| jacket.name.downcase.split(" ").include?(keyword)}
  end

  def self.reverse_keyword(keyword)
    all - keyword_search(keyword)
  end

  def self.price_search(price)
    all.select{|jacket| jacket.price.to_f < price.gsub("$", "").to_f}
  end

  def self.number_jackets(sorted_jackets)
    sorted_jackets.each_with_index{|jacket, index| jacket.number = index + 1}
  end

  def price_and_shipping
    sprintf('%.2f', (price.to_f + shipping.to_f))
  end

  def profile_description(profile_url)
    profile = Nokogiri::HTML(open(profile_url))
  end

  private
    def self.scrape_sukajans(url_option)
      all_sukajans = []
      search = Nokogiri::HTML(open(url_option))
      search.css(".sresult").each do |item|
        sukajan = Sukajan.new(item.css(".gvtitle h3").text.delete "\n" "\r" "\t")
        sukajan.profile_url = item.css(".gvtitle h3 a").attribute("href").value
        item.css(".gvshipping .ship .bfsp").empty? ? sukajan.shipping = item.css(".gvshipping .amt").text.gsub("$", "").to_f : sukajan.shipping = 0
        sukajan.image_link = item.css(".multiImgHolder div img").attribute("src").value
        if !(item.css(".gvprices .bid").empty?)
          sukajan.bids = item.css(".gvprices .bid .lbl").text
          sukajan.price = item.css(".gvprices .bid .amt").text
        else
          sukajan.bids = "Buy It Now"
          if !item.css(".gvprices .bin span .bold").empty?
            sukajan.price = item.css(".gvprices .bin span .bold").text.gsub("$", "").to_f
          else sukajan.price = item.css(".gvprices .bin .amt").text.delete "\n" "\t"
          end
        end
        all_sukajans << sukajan
      end
      @@all = all_sukajans
    end

    Sukajan.scrape_sukajans(url_options("CHEAPEST"))


end
