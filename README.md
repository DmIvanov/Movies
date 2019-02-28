# Movies
Sample project utilising The Movie DB API (https://www.themoviedb.org/)

Also a playground for learning DI-containers - [Swinject branch](https://github.com/DmIvanov/Movies/tree/swinject)

The project is built under XCode 10, Swift 4.2

### Functionality:
- downloading movies from API 
- displaying movies in collection view with pagination
- search for the specific query in the backend
- detail view of the movie


### Parts of the app:
1. **AppCoordinator**
  - general business logic inside the app
  - switching between different scenes (now it's only one)
  - processing app events from the AppDelegate
  - storing instances of global objects like DataSourse, NetworkManager, BackgroundServices, UserSession... (there's not so much of it so far =)).
2. **Presenter**
  - Handling MainWindow and UI part of all the navigation
  - Specific implementation of transitions between screens and scenes
3. **DataService**
  - The global realtime storage over the entire app
  - interacting with API when necessary
4. **APIClient**
  - API interaction
5. **MoviesVCFactory**
  - Instantiating app scenes/viewControllers
  - Binding together view controllers, view models, necessary services and delegates
6. **ServicesFactory**
  - Instantiating the services (replacing them with mocks for testing)
7. **Scenes (List view, Detail view):** ViewControllers + DataModels.
  - View Controllers are only responsible for the layout, catching user interactions, displaying data from the models.
  - View Models are responsible for VCs' busines logic, state and interactind with the services and higher level interactors/coordinators


### Some used approaches:
  - Modularity. Each piece of functionality is incapsulated in a proper class (set of classes).
  - Clear objects' responsibilities (Not everywhere it's one responsibility, but not more than couple of them) and APIs.
  - Dependency management suitable for clear understanding and testing. In most cases it's Dependency Injection or instantiating through factories.


### TODO:
- Additional functionality
  * OperationQueue for the NetworkRequests
  * additional info in the detail screen
  * persistency and offline mode
- Utilising more API capabilities
- Design
- UnitTests
