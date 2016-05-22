Fabricator(:video) do
  category
  title { Faker::Superhero.name }
  description { Faker::Hacker.say_something_smart }
  small_cover_url { ["tmp/family_guy.jpg", "tmp/monk.jpg", "tmp/futurama.jpg", "tmp/south_park.jpg"].sample }
  large_cover_url { "/tmp/monk_large.jpg" }
end
