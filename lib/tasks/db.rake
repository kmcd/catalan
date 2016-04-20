require 'faker'

namespace :db do
  desc "Populate with sample data"
  task populate: :environment do
    20.times do
      content = Faker::Hipster.paragraphs( rand(1..10) ).join("\n\n")
      article = Article.create! title:Faker::Book.title, body:content

      rand(20).times do
        article.comments.create \
          name:Faker::Name.name, 
          email:Faker::Internet.email,
          website:Faker::Internet.url,
          body:Faker::Hipster.paragraphs( rand(4) ).join("\n\n")
      end
    end
  end
end