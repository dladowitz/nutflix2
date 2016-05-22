Fabricator(:review) do
  user
  video
  rating [1,2,3,4,5].sample
  text   { Faker::StarWars.quote }
end
