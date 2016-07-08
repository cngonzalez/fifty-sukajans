class CLI

  def initialize
  end

def start
  input = ""
  until input == "EXIT"
    puts "A sukajan is a silk emboidered jacket, first popularized by American GIs in Japan the 1940s. If you get a scorpion one, you can look like Ryan Gosling in Drive (WOW!).\nWhich 200 jackets on eBay would you like to look at?"
    puts "-- type CHEAPEST\n-- type ENDING SOON\n-- type TOP RANKED\nIf you're here by mistake, feel free to type EXIT."
    input = gets.chomp
    narrowed = narrow_fork(Sukajan.url_options(input))
    sorted = sort_fork(narrowed)
    list(sorted)
  end
  puts "See you later!"
end

def narrow_fork(option_url)
  Sukajan.scrape_sukajans(option_url)
  puts "Great! Before we get started, you can narrow your options: \n
  KEYWORD: to only see items with a certain word or words in the name. You might look for things like \"#{Sukajan.sample_keywords}\"\n
  REVERSE KEYWORD: to eliminate items with certain words in its name \n
  PRICE  to only see items below a certain price \n
  NONE: to move forward with all 50 jackets"
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
end


def sort_fork(sukajans)
  puts "We're currently working with #{sukajans.length} jackets. Before I show them to you, should I sort them by: NAME, PRICE (please format as $xx.xx), BIDS \n
  You can also choose NONE if you just want to see jackets!"
  case gets.chomp
  when "NAME"
    sorted = sukajans.sort_by{|sukajan| sukajan.name}
  when "PRICE"
    sorted = sukajans.sort_by{|sukajan| sukajan.price.to_f}
    binding.pry
  when "BIDS"
    sorted = sukajans.sort_by{|sukajan| sukajan.bids.to_f}
  when "NONE"
    sorted = sukajans
  end
  Sukajan.number_jackets(sorted)
end

def list(sorted)
  sorted_sukajans = sorted
  input = ""
  until input == "HOME"
    until sorted_sukajans.empty?
      display_sukajans = sorted_sukajans.slice!(0,9) || display_sukajans = sorted_sukajans.slice!(0, last)
      display_10(display_sukajans)
      puts "To see the next 10, type any key. To look closer at a particular jacket, type its number."
      input = gets.chomp.to_i
      jacket_profile(input.to_i) if input.to_i > 0
    end
    puts "You've reached the end of your list! You can review your list and type the number of the jacket you want to look at. You can also type HOME to start a new search or exit."
    binding.pry
    input = gets.chomp
    jacket_profile(input.to_i) if input.to_i > 0
  end
end

def display_10(sukajans)
  sukajans.each do |sukajan|
    puts "#{sukajan.number}. \"#{sukajan.name}\""
    puts "Price (shipping included!): $#{sukajan.price_and_shipping}"
    puts "Current bids: #{sukajan.bids} \n"
  end
end

def jacket_profile(number)
  input = ""
  binding.pry
  until input == "BACK"
    jacket = Sukajan.all.detect{|jacket| jacket.number == number}
    puts "You're currently looking at jacket \##{jacket.number}."
    puts "Its name is #{jacket.name}"
    puts "Its total cost is $#{sprintf('%.2f', jacket.price_and_shipping)}, of which $#{sprintf('%.2f', jacket.shipping.to_f)} is shipping."
    puts "type IMAGE to see a picture of this jacket in your browser."
    puts "type PROFILE to launch this jacket's profile into your browser."
    puts "type DESC to see a longer item decription from the seller."
    puts "type BACK to get back to your list of jackets."
    input = gets.chomp
    case input
    when "IMAGE"
      Launchy.open(jacket.image_link)
    when "PROFILE"
      Launchy.open(jacket.profile_url)
    when "DESC"
      puts jacket.description
    end
  end
end

end
