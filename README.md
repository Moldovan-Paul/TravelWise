# About TravelWise
<img width="500" alt="Flight Screen" src="https://user-images.githubusercontent.com/98110966/190630679-b41791bc-aff7-4808-bf7b-feafcb9298ad.png"><img width="500" alt="Accommodation Screen" src="https://user-images.githubusercontent.com/98110966/190630713-4f8e7474-d5d8-4d36-b9aa-922b935f8f3d.png">
# Overview
TravelWise is an iOS app that helps travellers gather information regarding flights and accommodations available around the globe. It is built using the **Swift** programming language and its **UIKit** framework.

FOR VIDEO DEMNOSTRATION PLEASE REFER TO THE FOLLOWING SECTIONS: 

[Flights section demo](#flights-section-demo)

### Flights Section

The user is presented with multiple interactable fields that represent information based on which the search for available flights will be made:
* ***Leaving From*** **Text Field** - represents the airport that the desired flight will leave from; the user will input it from the keyboard and will select a valid airport from the presented suggestion list
* ***Going To***  **Text Field** - represents the airport that the desired flight will land on; the user will input it from the keyboard and will select a valid airport from the presented suggestion list
* **One Way button** - a toggleable option that when selected will make the app omit returning flights
* **Departure date**
* **Return date** - if one way flight search is not selected, represents the date of departure of the returning flight, otherwise, this field is not available
* **Number of adult passengers**

Users can double check their choice by observing the airports **3 letter IATA codes** in the bottom right corner of their respective text fields.

Upon pressing the **Search Button**, a new view displays the results. Each result contains information regarding

### Flights Section Demo

The following video shows this section's functionality through an example of both round trip and one way flight searches.

https://user-images.githubusercontent.com/98110966/190646451-39838129-dd39-4143-abdd-522bdc44219e.mp4



