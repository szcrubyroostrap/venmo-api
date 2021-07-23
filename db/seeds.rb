user_a = User.create!(amount: 10)
user_b = User.create!(amount: 7500)
user_c = User.create!(amount: 16_000)
user_d = User.create!(amount: 1700)

user_a.add_friend(user_b)
user_b.add_friend(user_c)
user_c.add_friend(user_d)
