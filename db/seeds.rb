# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# <administratorデータ>
User.create!(
  name: "KNG", 
  email: 'KNG@example.com', 
  password: '11101252', 
  password_confirmation: '11101252', 
  admin: true)
  
# <userデータ>
10.times do |i|
  User.create!(
    name: "KNG#{i + 2}", 
    email: "KNG#{i + 2}@example.com", 
    password: '11101252', 
    password_confirmation: '11101252')
end

users = User.all
users = users.map{|user| user.id}
start_day = DateTime.new(2023, 1, 5, 0, 0, 0)
last_day = DateTime.new(2023, 3, 15, 23, 59, 59)

# <repositoryデータ>
10.times do |i|
  Repository.create!(
    name: "リポジトリ#{i + 1}",
    description: "ジャスティス#{i + 1}",
    user_id: users.sample)
end
