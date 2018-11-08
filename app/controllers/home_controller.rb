class HomeController < ApplicationController
  def index

    #TraderOfTheDeath.new.perform

    @cryptos = Crypto.all.sort

    @crypto = Crypto.new

    if request.post?
      @crypto_selected = Array.new
      ids = params["crypto"]["id"]
      ids.shift

      ids.each do |id|
        crypto_hash = Hash.new
        if Crypto.find_by(id: id)
          crypto = Crypto.find_by(id: id)
          crypto_hash[:name] = crypto.name
          crypto_hash[:value] = crypto.value
        else
          crypto_hash[:error] = "Undefined Crypto"
        end
        @crypto_selected << crypto_hash
      end
    end
  end
end
