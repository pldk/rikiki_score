# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Player.create([
                # { name: 'Cress', description: Faker::Quote.jack_handey },
                # { name: 'Charly', description: Faker::Quote.jack_handey },
                { name: 'Doud', description: Faker::Quote.jack_handey },
                { name: 'Gad', description: Faker::Quote.jack_handey },
                # { name: 'Mat', description: Faker::Quote.jack_handey },
                { name: 'Pipo', description: Faker::Quote.jack_handey },
                { name: 'Tom', description: Faker::Quote.jack_handey },
                # { name: 'Toony', description: Faker::Quote.jack_handey }
              ])