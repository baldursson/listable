class TopicalItems < ActiveRecord::Base
  acts_as_listable_view
end

class Page < ActiveRecord::Base
  listable_through :topical_items, :listables
  scope :listables, select([:title, :body])
end

class Employee < ActiveRecord::Base
  listable_through :topical_items, :listables
  scope :listables, concat_select([:first_name, ' ', :last_name], :title).select(:biography)
end

class NewsArticle < ActiveRecord::Base
  listable_through :topical_items, :listables
  scope :listables, select_as(headline: 'title').select(:body)
end

# Seeding pages
Page.create(title: "I'm serious as a heart attack",
            body: "Well, the way they make shows is, they make one show.
                   That show's called a pilot. Then they show that show to the people who make shows,
                   and on the strength of that one show they decide if they're going to make more shows.
                   Some pilots get picked and become television programs. Some don't, become nothing.
                   She starred in one of the ones that became nothing.")

Page.create(title: "Are you ready for the truth?",
            body: "Look, just because I don't be givin' no man a foot massage don't make it right
                   for Marsellus to throw Antwone into a glass motherfuckin' house, fuckin' up
                   the way the nigger talks. Motherfucker do that shit to me, he better paralyze my ass,
                   'cause I'll kill the motherfucker, know what I'm sayin'?")

# Seeding employees
Employee.create(first_name: 'Johannes',
                last_name: 'Baldursson',
                biography: "Normally, both your asses would be dead as fucking fried chicken,
                            but you happen to pull this shit while I'm in a transitional period so
                            I don't wanna kill you, I wanna help you. But I can't give you this case,
                            it don't belong to me. Besides, I've already been through too much shit
                            this morning over this case to hand it over to your dumb ass.")


NewsArticle.create(headline: 'Is she dead, yes or no?',
                   body: "Do you see any Teletubbies in here? Do you see a slender plastic tag clipped
                          to my shirt with my name printed on it? Do you see a little Asian child with
                          a blank expression on his face sitting outside on a mechanical helicopter that
                          shakes when you put quarters in it? No? Well, that's what you see at a toy store.
                          And you must think you're in a toy store, because you're here shopping for an infant named Jeb.")