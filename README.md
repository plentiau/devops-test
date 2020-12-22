# Example weather service

This is a simple weather service that returns some weather forecasts using the well known meteorological method of random number generation.

## Using this test

Complete the required tasks, making regular commits of working code as you go. Make sure your commit comments reference the task you're working on.

This test shouldn't take you more than 1.5 hours.

Consult the [To Do list](TODO.md) for required tasks to complete this test.

Tasks are in order of priority.

Bonus points for adding recommendations to the end of the task list.

## Running the service

You can run the service using `dotnet run -p ./ExampleService`

The service is available on https://localhost:5000 and you can view the Swagger UI at http://localhost:5000/swagger

## Running tests

Tests can be executed by running `dotnet test` in the root of the repo.

## Deployment
#### Docker
```
# To run application with docker
cd ExampleService
docker build -t weather-service . # Build docker image
docker run -d -p 5000:5000 weather-service # Start application

# To run unit testing (Will use single Dockerfile for build, test)
cd ExampleService.UnitTests
docker build -t weather-service-test . 
```
#### Architecture
```
SCM ->(push docker image) ECR -> (helm upgrade) EKS Cluster
SCM ->(push helm chart) ->Chartmusium
```
- EKS cluster to run application
- Self-host chartmusium to host helm chart
- ECR to hosted docker images

#### Deploy
Helm uses a simple packaging format called charts. A chart is a group of files that describe a related set of Kubernetes resources available. 
A single chart can be used to deploy something simple.
```
helm repo add --username ${HELM_USER} --password ${HELM_PASSWORD} weather-charts http://chart.weather-service.com
helm repo update
helm upgrade
      --install ${HELM_RELEASE_NAME} weather-charts/umbrella-chart 
      --namespace ${ENV}
      --values values.yaml
      --set image.repository=${DOCKER_IMAGE}
      --set image.tag=${DOCKER_TAG}

```
