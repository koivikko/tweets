# tweets

This app demonstrates basic functionality of a over simplified Twitter client. It allows user to login & logout, display a list of tweets and post a tweet.

Features:
- Login & Logout
	- Any username & password combination will work
	- To illustrate asynchronous nature of network requests, login request has a random chance of failing with relevant error message
	- Logout will clear all the previous tweets for that account
- Tweets list
	- App refreshes the list of tweets everytime the tweets list is displayed (either after loging, app launch or compose)
	- Refreshing the list of tweets may randomly add a new tweet from a pretended friend
	- Refresh may also fail randomly and display an error message
	- You may refresh the list by dragging the list down
- Compose tweet
	- It is possible to type a message and post it. After the message has been "received" by the server, the app goes back to the tweets list
	- Posting a message may fail randomly as well with an appropriate error message
	- For now, there is not upper bound to the message size


## App architecture

The app is designed by following MVC-pattern. Views are associated with view controllers. Data model is extracted to two logical modules, AccountManager and TweetManager which provide data access methods for the UI. Data model layer will interact with a simulated asynchronous REST api. 


### View controllers

Each main screen of the app is associated with its corresponding view controller. View controllers are responsible for populating the view content and passing any inputs to data model. Each view controller is to be initialized with their dependencies injected. In the context of this excercise, the required dependency is the account after the user is logged in.

App contains following View Controllers:
- Initial VC which is responsible to ensure app displays correct view controller upon launch (login / tweets list)
- Login VC which will receive user input and attempts to login by using the Account Manager object
- Tweets list which will display the list of tweets for the given account
	- Tweets list will automatically refresh the list from the server when ever it is displayed
	- Note: No consideriation at all was put to the usability of the list and the placement of compose and logout buttons :)
- Tweet composer posts a new tweet to the server. Tweet must contain more than 0 characters. 
	- If posting was successful, the view is dismissed and the app will display the tweets list with a new tweet added


### Data model
Data model contains two singleton data manager objects; AccountManager and TweetManager. Both objects are responsible for accessing locally stored data and interacting with the rest API. Rest api is passed to both managers during app initialization in order to achieve higher object decoupling. 

- AccountManager stores the account info in a local file. In a proper production app this would be done by using more secure methods, most likely core data with appropriate security settings.
	- Additionally user credentials would be stored in the device key chains for additional security
- TweetManager stores the tweets in a single ordered file. Similar to account manager, proper production app would use core data to achieve must better data management in terms of queries and security. 

### REST Api
Since the point of this app was not to connect to real twitter service, the app contains a dummy rest api object. In order to help testing, the app will randomly throw errors or post tweets from fake followers. 

- TweetRESTApi publishes all the required network operations for the data model. Operations will take a closure as a parameter for returning asynchronous request results. 
	- It is important to note that this app does not handle account authentication in any proper manner. In a real production applications, typical issue would be around invalid / experied user credentials and handling those error scenarios in a user friendly manner would need some additional work (Imagine an app that has queued several network requests and user's password got changed..)
- NetworkOperations contains all asynchronous fake network operations
	- This would be replaced by a 3rd party networking framework or urlsession, depending on the networking needs of the app

## Testing
This project contains few unit tests and UI tests to illustrate how such app would be testable. 

### Unit tests
Since the app is built with object decoupling in mind, unit tests are fairly easy for most of the components. A good example is the tweet manager which relies on ansynchronous network service. Because the network service is passed to the tweet manager, mocking it in the unit tests becomes easy and would allow simulating various network situations fairly easily.

### UI tests
UI tests will only cover a single login & logout sequence to illustrate a simple feature test case. Most important aspect for the UI tests is to find a safe and robust assertion check and to leave the app in a clean state after each test case. 


## External dependencies
Since this app is was relatively small, there are no external components for now. 
