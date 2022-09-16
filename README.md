# About TravelWise
<img width="500" alt="Flight Screen" src="https://user-images.githubusercontent.com/98110966/190630679-b41791bc-aff7-4808-bf7b-feafcb9298ad.png"><img width="500" alt="Accommodation Screen" src="https://user-images.githubusercontent.com/98110966/190630713-4f8e7474-d5d8-4d36-b9aa-922b935f8f3d.png">
# Overview
TravelWise is an iOS app that helps travellers gather information regarding flights and accommodations available around the globe. It is built using the **Swift** programming language and its **UIKit** framework.

### Flights Section

The user is presented with multiple interactable fields that represent information based on which the search for available flights will be made:
* ***Leaving From*** **Text Field** - represents the airport that the desired flight will leave from; the user will input it from the keyboard and will select a valid airport from the presented suggestion list
* ***Going To***  **Text Field** - represents the airport that the desired flight will land on; the user will input it from the keyboard and will select a valid airport from the presented suggestion list
* **One Way button** - a toggleable option that when selected will make the app omit returning flights
* **Departure date**
* **Return date** - if one way flight search is not selected, represents the date of departure of the returning flight
* **Number of adult passengers**

Users can double check their choice by observing the airports **3 letter IATA codes** in the bottom right corner of their respective text fields.

### Flights Section Demo

The following GIF shows an example of both round trip and one way flight searches.
