rails db:create
rails g scaffold Member Name:string Sex:string
rails db:migrate
rails s -b 0.0.0.0