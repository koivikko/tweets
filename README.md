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


### Data model


### REST Api



## Testing


### Unit tests


### UI tests




