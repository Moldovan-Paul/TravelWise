# About TravelWise
<p align="center">
<img width="400" alt="Screenshot 2022-09-17 at 11 39 59" src="https://user-images.githubusercontent.com/98110966/190848301-835a4106-183c-4453-8a92-b6e849852533.png"><img width="400" alt="Screenshot 2022-09-17 at 11 20 22" src="https://user-images.githubusercontent.com/98110966/190847886-dadcb37b-1fe7-4645-8362-5285de3929be.png">
</p>

# Overview
TravelWise is an iOS app that helps travellers gather information regarding flights and accommodations available around the globe. It is built using the **Swift** programming language and its **UIKit** framework. **Two APIs** are used for fetching **real time legitimate data**. More about API usage [here](#api-usage).

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

<p align="center">
<img width="200" heigth="200" alt="Round Trip" src="https://user-images.githubusercontent.com/98110966/190850520-19161af0-f0c3-4991-baa6-e0665fd0ce1e.png">
<img width="200" heigth="200" alt="Round Trip Results" src="https://user-images.githubusercontent.com/98110966/190850525-eb2ee9a7-0583-47bb-aab2-a9fd73077d1b.png">
<img width="200" heigth="200" alt="One Way Results" src="https://user-images.githubusercontent.com/98110966/190850550-60111a6f-02b6-498c-a582-c7b7513d2dce.png">
<img width="200" heigth="200" alt="One Way" src="https://user-images.githubusercontent.com/98110966/190850547-fc844337-f7e2-4c7f-af77-21bd78599df0.png">
</p>

### Flights Section Demo

The following video shows this section's functionality through an example of both round trip and one way flight searches. When the user scrolls to the bottom of the first few available results, more are loaded (infinite scrolling).



https://user-images.githubusercontent.com/98110966/190848497-f9c5de9f-1d1f-4fc7-a99d-08e4c0013faa.mp4



# Accommodations Section

The user is presented with multiple interactable fields that represent information based on which the search for available accommodations will be made:
* ***Location*** **Text Field** - represents the location of the desired accommodation; the user will input it from the keyboard and will select a valid city or region from the presented suggestion list
* **Minimum Star Rating** - a series of interactable buttons that when tapped change the minimum star rating of the desired accommodation
* **Check In Date**
* **Check Out Date**
* **Number of Adult Guests**

Upon pressing the **Search Button**, a new view displays a scrollable list of results. Each result contains the accommodation's name and logo, adress, number of rooms left that are available, star rating and price for one night. 

The user can **sort the results** by pressing the button provided in the top right corner of the results screen and choosing one of the following 6 criteria: 
* **Best Selling**
* **Price (Ascending)**
* **Price (Descending)**
* **Star Rating (Highest First)**
* **Star Rating (Lowest First)**
* **Guest Rating**

### Accommodations Section Demo

The following video shows this section's functionality through an example of an accommodation search. When the user scrolls to the bottom of the first few available results, more are loaded (infinite scrolling).

https://user-images.githubusercontent.com/98110966/190646451-39838129-dd39-4143-abdd-522bdc44219e.mp4

# API Usage

The two APIs used for making this app are https://rapidapi.com/tipsters/api/priceline-com-provider (flights) and https://rapidapi.com/apidojo/api/hotels4/ (accommodations).

The first screen of each section makes an API call after the user has input 3 or more characters. A dropdown menu will subsequently display a scrollable list of suggestions to the user based on the response recieved from the API for the given keyword.
<p align="center">
<img width="200" heigth="200" alt="Airport Suggestions" src="https://user-images.githubusercontent.com/98110966/190848808-f2b6b0fe-c5ed-49d8-8d48-641eed35d43b.png">
<img width="200" heigth="200" alt="Accommodation Suggestions" src="https://user-images.githubusercontent.com/98110966/190848671-f75e8dcd-ba87-4296-b205-e04f8b133318.png">
</p>
Upon pressing the Search Button, a new API call is made with the parameters chosen by the user and the response entity is used for filling the results screen's cells. For the accommodations section, each time the user choses a sorting criteria, a new API call is made with said criteria, keeping other parameters unchanged.

# Input Validation

A search cannot be performed unless the mandatory fields are filled with valid information - that is selecting a valid airport for the flights section, respectively a valid location for the accommodations section. An appropriate alert pop-up will inform the user about this.

<p align="center">
<img width="200" heigth="200" alt="Flights Alert" src="https://user-images.githubusercontent.com/98110966/190849733-7b90156f-343e-46a8-91b9-f2456ac57160.png">
<img width="200" heigth="200" alt="Accommodations Alert" src="https://user-images.githubusercontent.com/98110966/190849735-735971d6-e6d7-406c-a650-f8db31f991b6.png">
</p>



