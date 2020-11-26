# TODOs

## Complete the below tasks to the best of your ability

_If you are unsure of how to complete any of the tasks, add notes explaining where you had difficulties and how you think you might be able to progress._

* Add a docker file that builds, tests, and runs the web api
  - ensure that the final container image only contains runtime dependencies

* Add NLog logging provider

* Configure logging to json log format to the console

* Add a cloudformation or terraform template to the `Deployment` folder to create an elastic container registry to store the container
    - enable image scanning on upload
    - images tags should be immutable

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

## Written question

_This is a short written answer, do not worry about providing infrastructure code for the below._

* Deployment of this service will be on either AWS ECS, hosting on Fargate compute, or on AWS EKS using managed nodes. Choose one of either of these platforms and:
  - Provide an brief overview of the infrastructure components required to deploy this plaform.
  - Provide a brief overview of how you would go about deploying the application to this infrastructure.
