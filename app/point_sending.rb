class VendingMachine
  attr_accessor  # 使いこなせなかった・・・
  KIND_OF_MONEY = [10,50,100,500,1000].freeze
  MUL_KIND_OF_MONEY = [1, 5, 2000, 5000, 10000].freeze

  def initialize
    @money_array = [0, 0, 0, 0, 0]
    @slot_money = 0
    @drinks = [
      {name: :水, price: 100, stock: 5},
      {name: :炭酸水, price: 100, stock: 5},
      {name: :コーラ, price: 120, stock: 5},
      {name: :レッドブル, price: 200, stock: 5}
    ]
    @sales = 0
  end

  def information
    puts "----------------------------------------"
    @drinks.each do |drink|
      puts "#{drink[:name]}は#{drink[:price]}円で、残り#{drink[:stock]}個です"
    end  
  end

  def slot_money(money)
    if MUL_KIND_OF_MONEY.include?(money)
      puts "そのお金は使用できません"

    elsif KIND_OF_MONEY.include?(money)
      money_index = KIND_OF_MONEY.index(money)
      @money_array[money_index] = 1  # =の前の+をとった。お金の配列が保存されなくなるが、正常に作動するようになる。
      @slot_money += (KIND_OF_MONEY[money_index] * @money_array[money_index])
      puts "-----------------------------------------"
      puts "現在の投入金額は#{@slot_money}円です"
    
      availble_drinks = []
      @drinks.each do |drink|
        if drink[:price] <= @slot_money && drink[:stock] > 0
          availble_drinks << drink[:name]
        end
      end
      availble_drinks_str = availble_drinks.join(",")
      puts "#{availble_drinks_str}は購入可能です"
    end
  end

  def return_money
    puts "-----------------------------------------"
    puts "現在の投入合計の金額は#{@slot_money}円です。#{@slot_money}円返金致します。"
    @slot_money = 0
  end

  def point_sending(user)
    return puts "お買い求めいただけません" unless (0..3).include?(drink)
    drink_name = @drinks[drink][:name]
    drink_value = @drinks[drink][:price]
    drink_stock = @drinks[drink][:stock] 
    if drink >= 0 && drink <= 3
      puts "-----------------------------------------"
      if drink_value <= @slot_money  # お金足りてるルート
        if drink_stock > 0
          puts "ありがとうございました" 
          drink_stock -= 1  
          @drinks[drink][:stock] = drink_stock    # initializeの配列要素に再代入して在庫が減るようにした
          @sales += drink_value  
          @slot_money -= drink_value  
          puts "残高は#{@slot_money}円です"
        else #drink_stock == 0
          puts "現在売り切れです" 
        end
      else #drink_value > @slot_money  # お金足りないルート
        puts "お金が足りません。"
      end
    end
  end






  def sales
    puts "現在の売上は#{@sales}円です"
  end
end