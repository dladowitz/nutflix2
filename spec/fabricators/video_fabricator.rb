Fabricator(:video) do
  category
  title { Faker::Superhero.name }
  description { Faker::Hacker.say_something_smart }
  small_cover_url { "http://localhost:3000/tmp/family_guy.jpg"}
  large_cover_url { "http://localhost:3000/tmp/monk_large.jpg"}
end
