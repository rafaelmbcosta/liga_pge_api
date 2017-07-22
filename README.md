# Cartola PGE API

This repository holds the back end for the private league of a game called cartola. It lists the partials scores and keep track of some particular rules and data.

# What we use

  - Rails 5 API
  - RSpec
  - Heroku
  - Resque / Redis

# Installation

  after create/migrate:
  - rake db:seed
  - If you are below proxy check commented lines at lib/web/api_cartola/connection.rb
  - start workers: (soon)
