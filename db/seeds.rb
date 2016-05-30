# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Use rake db:reset, which drops the database and runs this seed file

# Users
10.times { Fabricate(:user); puts "Created User: #{User.last.full_name}" }
User.first.update(email: "david@ladowitz.com"); puts "Updated first user's email to be david@ladowitz.com for signing purposes"

# Categories
action = Category.create(name: "Action"); puts "Created Category: Action"
comedy = Category.create(name: "Comedy"); puts "Created Category: Comedy"
drama = Category.create(name: "Drama"); puts "Created Category: Drama"

# Videos
50.times { Fabricate(:video, category: (Category.find Category.ids.sample)); puts "Created Video: #{Video.last.title}" }


# Video.create(title: "Family Guy", category: action, small_cover_url: "tmp/family_guy.jpg", large_cover_url: "tmp/monk_large.jpg", description: "The wacky, occasionally irreverent misadventures of a Rhode Island family whose number includes a morbidly obese moron; his martini loving, genius dog; his sexpot wife; his gigantic thirteen year old son; his whiny, awkward daughter; and his homicidal infant son.")
# Video.create(title: "Monk", category: comedy, small_cover_url: "tmp/monk.jpg", large_cover_url: "tmp/monk_large.jpg", description: "Former police detective Adrian Monk (Tony Shalhoub) has suffered from intensified obsessive- compulsive disorder and a variety of phobias since the murder of his wife, Trudy, in 1997. Despite his photographic memory and his amazing ability to piece tiny clues together, he is now on psychiatric leave from the San Francisco Police Department. Aided by his friend and practical nurse, Sharona Fleming (Bitty Schram), Monk works as a freelance detective/consultant, hoping to convince his former boss, Captain Stottlemeyer (Ted Levine), to allow him to return to the force.")
# Video.create(title: "South Park", category: drama, small_cover_url: "tmp/south_park.jpg", large_cover_url: "tmp/monk_large.jpg", description: "The curious, adventure-seeking, fourth grade group of boys, Stan, Kyle, Cartman, and Kenny, all join in in buffoonish adventures that sometimes evolve nothing. Sometimes something that was simple at the start, turns out to get out of control. Everything is odd in the small mountain town, South Park, and the boys always find something to do with it.")
# Video.create(title: "Futurama",  category: comedy, small_cover_url: "tmp/futurama.jpg", large_cover_url: "tmp/monk_large.jpg", description: "Pizza boy Philip J. Fry awakens in the 31st century after 1,000 years of cryogenic preservation in this animated series. After he gets a job at an interplanetary delivery service, Fry embarks on ridiculous escapades to make sense of his predicament.")

# Reviews
200.times { Review.create(video_id: Video.ids.sample, user_id: User.ids.sample, rating: [1,2,3,4,5].sample, text: Faker::Hacker.say_something_smart ); puts "Created Review with text: #{Review.last.text}" }

# Queue items
100.times { QueueItem.create(video_id: Video.ids.sample, user_id: User.ids.sample); puts "Created QueueItem for #{QueueItem.last.user.full_name} with position of #{QueueItem.last.position}" }
