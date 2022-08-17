# cite_finder_admin

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Setup
Run flutter pub get after the cloning of the project or addition of new packages

## The project is structured as follows:
- *assets*: This is located in the root  of the application. It contains all necessary assets used in the project e.g. fonts, images, locales and json model files
- *Screens* : For each module which corresponds to a screen or view it should contain bindings, controllers and view folders for a screen or module and also components and providers specific to thagt module if possible.
- *Components*: This should contains any custom components(those used throughout the application).
- *Models*: This should contain files with models(classes) corresponding to the class diagram with all attributes and methods. It may also contain helper classes. 
- *Providers*: This will contain all the general providers in folders used throughout the application. Here also, a base provider will be created with the setup and behavior that all other providers will inherit feom 
- *Utils*: This folder will contain all other utilities that do not fit into the previous categories e.g. config files for general variables, enum files, themes e.t.c.
 
## NB!!!
Be sure to store all variables in the *config* file 
Be sure to only use colors and themes specified in *theme* files.
Input all assets as variables in *config* file under Assets class before usage
For the usage of getStorage, add all keys to the Key Section in config files and import before usage.

Add to this Readme file any other info deemed necessary

Happy Coding :) 
