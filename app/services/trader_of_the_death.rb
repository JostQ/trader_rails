require 'open-uri'

class TraderOfTheDeath

  def initialize
    @url = "https://coinmarketcap.com/all/views/all/"
  end

  def save(tab)

    tab.each do |hash|
      if Crypto.find_by(name: hash[:name])
        unless Crypto.find_by(name: hash[:name]).value == hash[:price]
          crypto = Crypto.find_by(name: hash[:name]).update(value: hash[:price])
        end
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

    verif_value = coins.xpath("//a[@class = 'price']")[1].text
    verif_name = coins.xpath("//a[@class = 'currency-name-container link-secondary']")[1].text

    unless Crypto.find_by(name: verif_name, value: verif_value)

      coins.xpath("//a[@class = 'price']").each do |price|
          if price.text == "?" #Si on à un ? on remplace dans notre tableau par nil
              tab_price << nil
          else
              tab_price << price.text #Si on trouve un cours, on l'ajoute au tableau
          end
      end

      coins.xpath("//a[@class = 'currency-name-container link-secondary']").each do |name|
          tab_name << name.text
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
end
