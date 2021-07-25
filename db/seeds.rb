user_a = User.create!(amount: 10, email: 'user_a@email.com', username: 'user_a')
user_b = User.create!(amount: 7500, email: 'user_b@email.com', username: 'user_b')
user_c = User.create!(amount: 16_000, email: 'user_c@email.com', username: 'user_c')
user_d = User.create!(amount: 1700, email: 'user_d@email.com', username: 'user_d')

user_a.add_friend(user_b)
user_b.add_friend(user_c)
user_c.add_friend(user_d)
