class FiftySukajans::CLI

  def initialize
  end

def start
  input = ""
  until input == "EXIT"
    puts "A sukajan is a silk emboidered jacket, first popularized by American GIs in Japan the 1940s. If you get a scorpion one, you can look like Ryan Gosling in Drive (WOW!).\nWhich 200 jackets on eBay would you like to look at?"
    puts "-- type 1 for CHEAPEST\n-- type 2 for ENDING SOON\n-- type 3 for TOP RANKED\nIf you're here by mistake, feel free to type EXIT."
    input = gets.chomp
    if !([1, 2, 3].include?(input.to_i)) && input != "EXIT"
      puts "Sorry! That's not a valid input. Try again."
    elsif input == "EXIT"
      puts "See you later!"
    else
      narrowed = narrow_fork(FiftySukajans::Sukajan.url_options(input))
      sorted = sort_fork(narrowed)
      list(sorted)
    end
  end

end

def narrow_fork(option_url)
  FiftySukajans::Sukajan.scrape_sukajans(option_url)
  spiel = "Great! Before we get started, you can narrow your options: \n
  1. KEYWORD: to only see items with a certain word or words in the name. You might look for things like \"#{FiftySukajans::Sukajan.sample_keywords}\"\n
  2. REVERSE KEYWORD: to eliminate items with certain words in its name \n
  3. PRICE: to only see items below a certain price \n
  4. NONE: to move forward with all 50 jackets"
  puts spiel
  input = gets.chomp
  while !([1, 2, 3, 4].include?(input.to_i))
    puts "Sorry! That's not a valid input. Try again."
   input = gets.chomp
  end
    case input
    when "1"
      puts "Please enter a keyword you'd like to search for."
      keyword = gets.chomp
      narrowed_array = FiftySukajans::Sukajan.keyword_search(keyword)
    when "2"
      puts "Please enter a word you'd like to avoid."
      keyword = gets.chomp
      narrowed_array = FiftySukajans::Sukajan.reverse_keyword(keyword)
    when "3"
      puts "Please enter a price point you'd like to stay under."
      price = gets.chomp
      narrowed_array = FiftySukajans::Sukajan.price_search(price)
    when "4"
      puts "Okay! Moving on..."
      narrowed_array = FiftySukajans::Sukajan.all.dup
    end
end


def sort_fork(sukajans)
  spiel = "We're currently working with #{sukajans.length} jackets. Before I show them to you, should I sort them by: \n 1. NAME, 2. PRICE, 3. BIDS 4. NONE"
  puts spiel
  input = gets.chomp
  while !([1, 2, 3, 4].include?(input.to_i))
    puts "Sorry! That's not a valid input. Try again."
   input = gets.chomp
  end
  case input
  when "1"
    sorted = sukajans.sort_by{|sukajan| sukajan.name}
  when "2"
    sorted = sukajans.sort_by{|sukajan| sukajan.price.to_f}
  when "3"
    sorted = sukajans.sort_by{|sukajan| sukajan.bids.to_i}
  when "4"
    sorted = sukajans
  end
  FiftySukajans::Sukajan.number_jackets(sorted)
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
  until input == "BACK"
    jacket = FiftySukajans::Sukajan.all.detect{|jacket| jacket.number == number}
    puts "You're currently looking at jacket \##{jacket.number}."
    puts "Its name is #{jacket.name}"
    puts "Its total cost is $#{sprintf('%.2f', jacket.price_and_shipping)}, of which $#{sprintf('%.2f', jacket.shipping.to_f)} is shipping."
    puts "type PROFILE to launch this jacket's profile into your browser."
    puts "type BACK to get back to your list of jackets."
    input = gets.chomp
    Launchy.open(jacket.profile_url) if input == "PROFILE"
  end
end

end
