# Airtable_Integration
> This project is a integration with airtable https://www.airtable.com with three endpoints plus a rake task to get records from an airtable project and load it in a local json file that is used to do the data management from airtable data.

## Problem
> Create a rake task to load data from airtable project and store it in a local json file, when backend server starts.
>
> Create an endpoint to show all the records loaded from airtable and be able to filter by the added data into airtable.
>
> Create and endpoint to refresh the copy from airtable project without need to run the rake task.
> 
> Create an endpoint to show only one record and replace the strings from airtable data

## Requirements
> Ruby 3.1.2
>
> Rails 7.0.3.1
>
> Airtable account API key

## Airtable instructions
- Create airtable.com account
- Go to [https://airtable.com/account](https://airtable.com/account) and generate & copy the API key
- Go to [https://airtable.com](https://airtable.com/) and click on `Add a base` from scratch and call it `Copy`
- Set 2 columns called `Key` and `Copy`
- Add 3 rows

| Key              | Copy                                    |
|------------------|-----------------------------------------|
| greeting         | Hi {name}, welcome to {app}!            |
| intro.created_at | Intro created on {created_at, datetime} |
| intro.updated_at | Intro updated on {updated_at, datetime} |


## Solution
- Gems installed: ```dotenv-rails```,```byebug```,```httparty```
- Rake task: ```lib/tasks/copy.rake```
- Service to integrate with airtable: ```app/services/airtable/airtable_integration_service.rb```
- Service to do the json data management: ```app/services/airtable/airtable_json_management_service.rb```
- Controller that do the endpoints management: ```app/controllers/api/v1/copy_controller.rb```
- Setting rake task to be loaded after backend starts and default application folder: ```config/application.rb```
- Controller tests: ```test/controllers/api/v1/copy_controller_test.rb```
- Rake task tests: ```test/lib/copy_test.rb```
- ```/copy``` API endpoint that returns all the copy in JSON format and accepts ```since=1659380400``` to filter by created_time
- ```/copy/{key}``` API endpoint that returns the correct value associated with the key, ```for example:```
> ```/copy/greeting?name=John&app=Bridge``` should return ```{value: 'Hi John, welcome to Bridge!'}``` 
- ``/copy/refresh`` API endpoint that fetches latest copy data from airtable and updates the copy data without needing to re-run the rake task & restart the backend server