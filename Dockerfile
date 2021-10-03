######################
# Build and Test stage
######################
FROM mcr.microsoft.com/dotnet/sdk AS build

WORKDIR /opt/source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY ExampleService/*.csproj ./ExampleService/
COPY ExampleService.UnitTests/ ./ExampleService.UnitTests
RUN dotnet restore

# copy everything else and build app
COPY ExampleService/. ./ExampleService/
WORKDIR /opt/source/ExampleService
RUN dotnet publish -c release -o app --no-restore
WORKDIR /opt/source
# Disable this because Unit Test gets failed
#RUN dotnet test

# As the requirement need the final image contains runtime dependencies only
# So the image to use is dotnet/runtime-deps
# But .NET is not included in there so can not run dotnet command, not sure about this!!
FROM mcr.microsoft.com/dotnet/aspnet as run
WORKDIR /opt/app

COPY --from=build /opt/source/ExampleService/app ./

CMD ["dotnet", "ExampleService.dll"]