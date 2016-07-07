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

  def open(url)
    Launchy.open("http://google.com")
  end

  def self.name_scraping
    words = all.collect{|jacket| jacket.name.downcase.split(" ")}.flatten
    frequency = words.each_with_object(Hash.new(0)) {|word, counts| counts[word] += 1}
  end

  def self.commonest
    commonest = name_scraping.sort_by{|k,v| v}.reverse[0..10].to_h.keys
  end

  def self.sample_keywords
    samples = name_scraping.sort_by{|k,v| v}.reverse[10..15].to_h.keys
    samples.join(", ")
  end

  def self.keyword_search(keyword)
    all.collect{|jacket| jacket.name.include?(keyword)}
  end

  def self.reverse_keyword(keyword)
    all - keyword_search(keyword)
  end

  def self.price_search(price)
    all.select{|jacket| jacket.price.gsub("$", "").to_f < price.gsub("$", "").to_f}
  end

  def self.number_jackets(sorted_jackets)
    sorted_jackets.each_with_index{|jacket, index| jacket.number = index + 1}
  end

  def price_and_shipping
    price.gsub("$", "").to_f + shipping.gsub("$", "").to_f
  end



  #
  # def name_cleaning
  #   name = self.name.split(" ").select{|word| !(self.class.commonest.include?(word.downcase))}
  #   @name = name.join(" ")
  # end
  #
  # def self.clean_all
  #   all.each{|jacket| jacket.name_cleaning}
  # end



  private
    def self.scrape_sukajans(url_option)
      all_sukajans = []
      search = Nokogiri::HTML(open(url_option))
      search.css(".mimg").collect do |item|
        sukajan = Sukajan.new(item.css(".gvtitle h3").text.delete "\n" "\r" "\t")
        sukajan.profile_url = item.css(".gvtitle h3 a").attribute("href").value
        item.css(".gvshipping .ship .bfsp").empty? ? sukajan.shipping = item.css(".gvshipping .amt").text : sukajan.shipping = "Free shipping!"
        if !(item.css(".gvprices .bid").empty?)
          sukajan.bids = item.css(".gvprices .bid .lbl").text
          sukajan.price = item.css(".gvprices .bid .amt").text
        else
          sukajan.bids = "Buy It Now"
          if !item.css(".gvprices .bin span .bold").empty?
            sukajan.price = item.css(".gvprices .bin span .bold").text
          else sukajan.price = item.css(".gvprices .bin .amt").text.delete "\n" "\t"
          end
        end
        all_sukajans << sukajan
      end
      binding.pry
      @@all = all_sukajans
    end


end
