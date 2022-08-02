# Airtable_Integration
> This project uses rails hotwire to show the ping time from server from one to one second without page reload.

## Problem
> Laravel Sail is a light-weight command-line interface for interacting with Laravel's default Docker development environment. Sail provides a great starting point for building a Laravel application using PHP, MySQL, and Redis without requiring prior Docker experience.
>
> At its heart, Sail is the docker-compose.yml file and the sail script that is stored at the root of your project. The sail script provides a CLI with convenient methods for interacting with the Docker containers defined by the docker-compose.yml file.
>
> Laravel Sail is supported on macOS, Linux, and Windows (via WSL2).
> 
## Requirements

## Solution
- Install ```gem "turbo-rails"```
- Install ```gem 'net-ping'```
- Create controller and helper for pings_controller
- Create views for pings
- ```app/views/pings/index.html.erb``` is here have the start view page
- ```app/views/pings/create.html.erb``` is here the user can create a new ping
- The create view have a partial: ```app/views/pings/_form.html.erb``` here is based the form to be submitted to the backend reply with the ping time result
- On the ```app/views/pings/_form.html.erb``` we also have a ```<tubo-frame>``` tag that will be replied by ```app/views/pings/create.turbo_stream.erb``` with the ping time form backend response
- On controller ```app/controllers/pings_controller.rb``` we have the create method that replies for frontend a ```format.turbo_stream ``` with the view to be rendered and with the ping result
- On  ```app/helpers/pings_helper.rb``` we have the method ```get_duration``` it calls ```get_ping``` that sends a ```Net::Ping::HTTP``` request to the root url and return a instance of ```Net::Ping::HTTP``` with the duration of the ping. On ```get_duration``` method it checks if the ping was successfully if yes, it returns the duration of the ping if not it returns the string ```ping could not be sent```
