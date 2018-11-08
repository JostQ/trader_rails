require 'open-uri'

class TraderOfTheDeath

  def initialize
    @url = "https://coinmarketcap.com/all/views/all/"
  end

  def save(tab)

    tab.each do |hash|
      if Crypto.find_by(name: hash[:name])
        crypto = Crypto.find_by(name: hash[:name]).update(value: hash[:price])
      else
        crypto = Crypto.new(name: hash[:name], value: hash[:price]).save
      end
    end

  end

  def perform

    tab_coins = Array.new
    tab_price = Array.new #Création de nos tableaux
    tab_name = Array.new

    coins = Nokogiri::HTML(open(@url))

    coins.xpath("//a[@class = 'currency-name-container link-secondary']").each do |name|
        tab_name << name.text
    end

    coins.xpath("//a[@class = 'price']").each do |price|
        if price.text == "?" #Si on à un ? on remplace dans notre tableau par nil
            tab_price << nil
        else
            tab_price << price.text #Si on trouve un cours, on l'ajoute au tableau
        end
    end

    tab_name.length.times do |i|
        hash_coins = Hash.new

        hash_coins[:name] = tab_name[i]
        hash_coins[:price] = tab_price[i]

        tab_coins << hash_coins #On met les hashs dans un tableau
    end

    save(tab_coins)

  end
end
