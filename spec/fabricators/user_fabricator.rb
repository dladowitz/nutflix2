Fabricator(:user) do
  email { Faker::Internet.email }
  full_name { Faker::StarWars.character }
  password  "asdfasdf"
end
