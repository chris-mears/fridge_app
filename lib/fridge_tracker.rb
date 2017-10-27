require_relative '../config/environment'
require_relative '../app/models/fridge'

def run_tracker
  puts <<~HEREDOC
         Welcome to the fridge Tracker
         What Would you like to do?
         1. See all of your fridges
         2. Add a Fridge
         3. Delete a Fridge
         Select a number:
       HEREDOC
  user_descision = gets.chomp.to_i

  if user_descision == 1
    show_fridges
  elsif user_descision == 2
    add_fridge
  elsif user_descision == 3
    delete_fridge
  end
end

def checkout_fridge(fridge_id)
  id = fridge_id
  fridge = Fridge.find(id)
  puts "#{fridge.brand} - #{fridge.location}"
  puts <<~HEREDOC
         What would you like to do with the fridge?
         1. Checkout the Food
         2. Checkout the Drinks
         3. Return to fridge Menu
         select a number:
       HEREDOC
  user_descision = gets.chomp.to_i

  if user_descision == 1
    run_food_menu(fridge)
  elsif user_descision == 2
    run_drink_menu(fridge)
  elsif user_descision == 3
    run_tracker
  end
end

def run_food_menu(fridge)
  fridge = fridge
  puts <<~HEREDOC
         1. View All Food Items in a specific Firdge
         2. Add a food item to a fridge
         3. Eat a food item from a fridge
         4. Go Back to Fridge Menu
         Select a number:
       HEREDOC
  user_descision = gets.chomp.to_i

  if user_descision == 1
    id = fridge.id
    food = fridge.foods
    show_food(food, id)
  elsif user_descision == 2
    fridge_id = fridge.id
    add_food(fridge_id)
  elsif user_descision == 3
    id = fridge.id
    food = fridge.foods
    eat_food(food, id)
  elsif user_descision == 4
    run_tracker
  end
end

def run_drink_menu(fridge)
  fridge = fridge
  puts <<~HEREDOC
         1. View all drink items in a specific fridge
         2. Add a drink item to a fridge
         3. Consume PART of a drink from a fridge
         4. Consume ALL of a drink from a fridge
         5. Go Back to Fridge Menu
         Select a number:
       HEREDOC
  user_descision = gets.chomp.to_i

  if user_descision == 1
    id = fridge.id
    drinks = fridge.drinks
    show_drinks(drinks, id)
  elsif user_descision == 2
    fridge_id = fridge.id
    add_drink(fridge_id)
  elsif user_descision == 3
    id = fridge.id
    drinks = fridge.drinks
    take_sip(drinks, id)
  elsif user_descision == 4
    id = fridge.id
    drinks = fridge.drinks
    consume_drink(drinks, id)
  elsif user_descision == 5
    run_tracker
  end
end

def show_drinks(drinks, id)
  fridge_id = id
  drinks = drinks
  drinks.each do |drink|
    puts "id:#{drink.id} - Food: #{drink.name}"
  end
  checkout_fridge(fridge_id)
end

def add_drink(fridge_id)
  fridge_id = fridge_id
  puts "Name:"
  name = gets.chomp
  puts "Size:"
  size = gets.chomp.to_i
  puts "Is it a Alcoholic option: true/false"
  alcoholic = gets.chomp.to_i
  new_drink = Drink.create(fridge_id: fridge_id, name: name, size: size, alcoholic: alcoholic)
  puts new_drink
  checkout_fridge(fridge_id)
end

def take_sip(drinks, fridge_id)
  drinsk = drinks
  fridge_id = fridge_id
  drinks.each do |drink|
    puts "id:#{drink.id} - Food: #{drink.name} Amount: #{drink.size}"
  end
  puts "Which you like to take a sip of? Please typ id:"
  drink_choice = gets.chomp.to_i
  puts "How much?"
  drink_amount = gets.chomp.to_i
  drink = Drink.find(drink_choice)
  size = drink.size - drink_amount
  drink.update(size: size)
  checkout_fridge(fridge_id)
end

def consume_drink(drinks, fridge_id)
  drinsk = drinks
  fridge_id = fridge_id
  drinks.each do |drink|
    puts "id:#{drink.id} - Food: #{drink.name}"
  end
  puts "Which you like to Drink? Please type id:"
  drink_choice = gets.chomp.to_i
  Drink.find(drink_choice).delete
  checkout_fridge(fridge_id)
end

def show_food(food, id)
  fridge_id = id
  foods = food
  foods.each do |food|
    puts "id:#{food.id} - Food: #{food.name}"
  end
  checkout_fridge(fridge_id)
end

def add_food(fridge_id)
  fridge_id = fridge_id
  puts "Name:"
  name = gets.chomp
  puts "Weight:"
  weight = gets.chomp.to_i
  puts "Is it a Vegan option: true/false"
  vegan = gets.chomp.to_i
  new_food = Food.create(fridge_id: fridge_id,name: name,weight: weight,vegan: vegan,added_to_fridge: Date.today)
  puts new_food
  checkout_fridge(fridge_id)
end

def eat_food(food, fridge_id)
  foods = food
  fridge_id = fridge_id
  foods.each do |food|
    puts "id:#{food.id} - Food: #{food.name}"
  end
  puts "Which Food would you like to eat? Please typ id:"
  food_choice = gets.chomp.to_i
  Food.find(food_choice).delete
  checkout_fridge(fridge_id)
end

def show_fridges
  puts <<~HEREDOC
         Here is the List of Fridges 
         Type the id of the fridge to check it out
         or type Exit to return to previous menu
       HEREDOC
  fridges = Fridge.all
  fridges.each do |fridge|
    puts "id:#{fridge.id} - Your #{fridge.brand} Fridge is in the #{fridge.location}"
  end
  fridge_id = gets.chomp.to_i
  checkout_fridge(fridge_id)
end

def add_fridge()
  puts "Location:"
  location = gets.chomp
  puts "Brand:"
  brand = gets.chomp
  puts "Size: "
  size = gets.chomp.to_i
  puts "Does it have Food: true/false"
  has_food = gets.chomp
  puts "Does it have Drinks: true/false"
  has_drink = gets.chomp
  new_fridge = Fridge.create(location: location, size: size, brand: brand, has_food: has_food, has_drink: has_drink)
  puts new_fridge
  run_tracker
end

def delete_fridge
  puts "Which fidge would you like to delete please type id"
  fridges = Fridge.all
  fridges.each do |fridge|
    puts "id:#{fridge.id} - Your #{fridge.brand} Fridge is in the #{fridge.location}"
  end
  fridge = gets.chomp.to_i
  Fridge.find(fridge).delete
  updated_fridges = Fridge.all
  updated_fridges.each do |fridge|
    puts "id:#{fridge.id} - Your #{fridge.brand} Fridge is in the #{fridge.location}"
  end
  run_tracker
end

run_tracker
