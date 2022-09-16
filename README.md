# About TravelWise
<img width="500" alt="Flight Screen" src="https://user-images.githubusercontent.com/98110966/190630679-b41791bc-aff7-4808-bf7b-feafcb9298ad.png"><img width="500" alt="Accommodation Screen" src="https://user-images.githubusercontent.com/98110966/190630713-4f8e7474-d5d8-4d36-b9aa-922b935f8f3d.png">
# Overview
TravelWise is an iOS app that helps travellers gather information regarding flights and accommodations available around the globe. It is built using the **Swift** programming language and its **UIKit** framework. **Two APIs** are used for fetching **real time legitimate data**. More about API usage [here].

FOR **VIDEO DEMONSTRATION** PLEASE REFER TO THE FOLLOWING ANCHORS: 

[Flights Section Demo](#flights-section-demo)

# Flights Section

The user is presented with multiple interactable fields that represent information based on which the search for available flights will be made:
* ***Leaving From*** **Text Field** - represents the airport that the desired flight will leave from; the user will input it from the keyboard and will select a valid airport from the presented suggestion list
* ***Going To***  **Text Field** - represents the airport that the desired flight will land on; the user will input it from the keyboard and will select a valid airport from the presented suggestion list
* **One Way button** - a toggleable option that when selected will make the app omit returning flights
* **Departure date**
* **Return date** - if one way flight search is not selected, represents the date of departure of the returning flight, otherwise, this field is not available
* **Number of adult passengers**

Users can double check their choice by observing the airports **3 letter IATA codes** in the bottom right corner of their respective text fields.

Upon pressing the **Search Button**, a new view displays a scrollable list of results. Each result contains the airline's name and logo, departure and arrival times, flight duration, number of stops and price (including the return flight if a search was performed for a round trip).

### Flights Section Demo

The following video shows this section's functionality through an example of both round trip and one way flight searches.

https://user-images.githubusercontent.com/98110966/190646451-39838129-dd39-4143-abdd-522bdc44219e.mp4



# Accommodations Section

The user is presented with multiple interactable fields that represent information based on which the search for available accommodations will be made:
* ***Location*** **Text Field** - represents the location of the desired accommodation; the user will input it from the keyboard and will select a valid city or region from the presented suggestion list
* **Minimum Star Rating** - a series of interactable buttons that when tapped change the minimum star rating of the desired accommodation
* **Check In Date**
* **Check Out Date**
* **Number of Adult Guests**

Upon pressing the **Search Button**, a new view displays a scrollable list of results. Each result contains the accommodation's name and logo, adress, number of rooms left that are available, star rating and price for one night. The user can sort the results by pressing the button provided in the top right corner of the results screen and choosing one of the following 6 criteria: 
* Best Selling
* Price (Ascending)
* Price (Descending)
* Star Rating (Highest First)
* Star Rating (Lowest First)
* Guest Rating

### Accommodations Section Demo

The following video shows this section's functionality through an example of an accommodation search.

https://user-images.githubusercontent.com/98110966/190646451-39838129-dd39-4143-abdd-522bdc44219e.mp4





