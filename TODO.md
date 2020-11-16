# TODOs

* Add a docker file that builds, tests, and runs the web api
  - ensure that the final container image only contains runtime dependencies

* Add NLog logging provider

* Configure logging to json log format

* Add a cloudformation or terraform template to create an elastic container registry to store the container 
    - enable image scanning on upload
    - images tags should be immutable

* Update this todo list with a list required infrastructure components to deploy service to AWS ECS on Fargate

* Extend the functionality of the service to return a Summary for the weather based on the below rules:
  - A unit test for this behaviour already exists.

| TemperatureC | Summary      |
|:------------:|:-------------|
|   <=  0      | "Freezing"   |
|  1 -  7      | "Bracing"    |
|  7 - 11      | "Chilly"     |
| 12 - 15      | "Cool"       |
| 16 - 19      | "Mild"       |
| 20 - 23      | "Warm"       |
| 24 - 27      | "Balmy"      |
| 28 - 30      | "Hot"        |
| 31 - 35      | "Sweltering" |
|   >= 36      | "Scorching"  |