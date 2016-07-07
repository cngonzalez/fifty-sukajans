class CLI

  def initialize
  end

def start
  puts "A sukajan is a silk emboidered jacket, first popularized by American GIs in Japan the 1940s. If you get a scorpion one, you can look like Ryan Gosling in Drive (WOW!). \n
  Which 200 jackets on eBay would you like to look at? \n
  -- type CHEAPEST \n
  -- type ENDING SOON \n
  -- type TOP RANKED \n
  If you're here by mistake, feel free to type EXIT."
  case gets.chomp
  when "CHEAPEST"
    option_url = "http://www.ebay.com/sch/Clothing-Shoes-Accessories/11450/i.html?ipg=200&_sop=15&_nkw=sukajan"
  when "TOP RANKED"
    option_url = "http://www.ebay.com/sch/i.html?_nkw=sukajan&ipg=200"
  when "ENDING SOON"
    option_url = "http://www.ebay.com/sch/i.html?ipg=200&_sop=1&_nkw=sukajan&rt=nc"
  end
  narrow_fork(option_url)
end

def narrow_fork(option_url)
  Sukajan.scrape_sukajans(option_url)
  puts "Great! Before we get started, you can narrow your options: \n
  KEYWORD: to only see items with a certain word or words in the name. I automatically eliminate common words from item names, so you might look for things like \"#{Sukajan.sample_keywords}\"\n
  REVERSE KEYWORD: to eliminate items with certain words in its name \n
  PRICE ____ : to only see items below a certain price \n
  NONE: to move forward with all 200 jackets"
  binding.pry
  case gets.chomp
  when "KEYWORD"
    puts "Please enter a keyword you'd like to search for."
    keyword = gets.chomp
    narrowed_array = Sukajan.keyword_search(keyword)
  when "REVERSE KEYWORD"
    puts "Please enter a word you'd like to avoid."
    keyword = gets.chomp
    narrowed_array = Sukajan.reverse_keyword(keyword)
  when "PRICE"
    puts "Please enter a price point you'd like to stay under."
    price = gets.chomp
    narrowed_array = Sukajan.price_search(price)
  when "NONE"
    puts "Okay! Moving on..."
    narrowed_array = Sukajan.all
  end
  sort_fork(narrowed_array)
end

def sort_fork(sukajans)
  puts "We're currently working with #{sukajans.length} jackets. Before I show them to you, should I sort them by:\n
  NAME \n
  PRICE \n
  BIDS \n
  NONE: JUST LET ME SEE THE JACKETS"
  case gets.chomp
  when "NAME"
    sorted = sukajans.sort_by{|sukajan| sukajan.name}
  when "PRICE"
    binding.pry
    sorted = sukajans.sort_by{|sukajan| sukajan.price}
  when "BIDS"
    sorted = sukajans.sort_by{|sukajan| sukajan.bids}
  when "NONE"
    sorted = sukajans
  end
  Sukajan.number_jackets(sorted)
  display_CLI(sorted)
end

def display_CLI(sorted_sukajans)
  until sorted_sukajans.empty?
    display_sukajans = sorted_sukajans.slice!(0,24) || display_sukajans = sorted_sukajans.slice!(0, last)
    display_25(display_sukajans)
    puts "To see the next 25, type any key. To look closer at a particular jacket, type its number."
    if gets.chomp != "EXIT"
      display_sukajans = sorted_sukajans.slice!(0,24) || display_sukajans = sorted_sukajans.slice!(0, last)
      display_25(display_sukajans)
    end
  end
end

def display_25(sukajans)
  sukajans.each do |sukajan|
    puts "#{sukajan.number}. \"#{sukajan.name}\""
    puts "Price (shipping included!): $#{sukajan.price_and_shipping}"
    puts "Current bids: #{sukajan.bids}"
  end
end

def jacket_profile
end

def launch_url
end



end



#     option = gets.chomp (options == cheapest, most on demand)
#     options fork from option scrape
#   end
#
#   options fork
# winnowing options (search by name, search by price, eliminate things (such as Disney in name))
#
# sorting options (by price, by name, by bids)
# group together by colors mentioned, etc.

#refine to key words and unique terms


#
#
#   ask for sorting, name compression, eliminate stuff
#   possible groupings?
#
# end
