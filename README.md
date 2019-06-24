# YAKOSA

Mobile application for Yakosa Project, using Flutter Framework (DART).

## Project structure

* main.dart : Main file called when starting the application
* main_debug.dart : Debug Main file used to start the application with different variables
* routes.dart : Dedicated file for screens routing
* screens/ : One file per screen, containing only the layout and including components
* components/ : One dir per screen for components
* common/ : Contains every UI components used in more than one screen or component
* utils/ : Every files needed for computing/processing

## Generate the GraphQL types

Modify the `codegen.yml` to point to your graphql schema and run:
```
$ yarn install
$ yarn generate
```


## Launch the app !

From the root of the project :

$ flutter packages get
$ flutter pub run build_runner build
$ flutter run

When Flutter is running : 
* use the "r" or "R" key to reload or hot reload the app
* use the "q" key to quit the app

### Local backend

To launch flutter with the local backend (127.0.0.1:3000) use:

$ flutter run -t lib/main_debug.dart
