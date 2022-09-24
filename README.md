# About TravelWise
<p align="center">
<img width="400" alt="Screenshot 2022-09-17 at 11 39 59" src="https://user-images.githubusercontent.com/98110966/190848301-835a4106-183c-4453-8a92-b6e849852533.png"><img width="400" alt="Screenshot 2022-09-17 at 11 20 22" src="https://user-images.githubusercontent.com/98110966/190847886-dadcb37b-1fe7-4645-8362-5285de3929be.png">
</p>

# Overview
**TravelWise** is an iOS app that allows travelers to gather information regarding flights and accommodations available around the globe. It is built using the **Swift** programming language and the **UIKit** framework. **Two APIs** are used for fetching **real-time legitimate data**. More about API usage [here](#api-usage). This app was made in **collaboration** with Bogdan Fomin, a Computer Science student from Iasi, Romania. I worked on the [Accommodations Section](#accommodations-section), while he was tasked with the [Flights Section](#flights-section). We strived to design and implement a **fluent**, **user-friendly** UI. I also implemented asynchronous downloading of images and a local image cache to remove scrolling lag, **boosting overall user experience**.

FOR **VIDEO DEMONSTRATION** PLEASE REFER TO THE FOLLOWING ANCHORS: 

[Flights Section Demo](#flights-section-demo)


[Accommodations Section Demo](#accommodations-section-demo)

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

If no matching results are found, an appropriate message is displayed. An example of this can be seen in the [API Usage](#api-usage) section.

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

Upon pressing the **Search Button**, a new view displays a scrollable list of results. Each result contains the accommodation's name and logo, address, number of rooms left that are available, star rating and price for one night. 

If no matching results are found, an appropriate message is displayed. An example of this can be seen in the [API Usage](#api-usage) section.

The user can **sort the results** by pressing the button provided in the top right corner of the results screen and choosing one of the following 6 criteria: 
* **Best Selling**
* **Price (Ascending)**
* **Price (Descending)**
* **Star Rating (Highest First)**
* **Star Rating (Lowest First)**
* **Guest Rating**

<p align="center">
<img width="200" heigth="200" alt="Accommodation Screen" src="https://user-images.githubusercontent.com/98110966/190850935-5716ac4e-5bdd-41ed-84a1-92e08cb37381.png">
<img width="200" heigth="200" alt="Accommodation Results" src="https://user-images.githubusercontent.com/98110966/190850939-c327c534-95b9-427d-8b25-3d348fd00058.png">
<img width="200" heigth="200" alt="Accommodation Sort By Button" src="https://user-images.githubusercontent.com/98110966/190850942-12e49869-00b5-4405-8794-0ee0a71941f4.png">
</p>


### Accommodations Section Demo

The following video shows this section's functionality through an example of an accommodation search. The results are subsequently sorted by ascending prices. When the user scrolls to the bottom of the first few available results, more are loaded (infinite scrolling).


https://user-images.githubusercontent.com/98110966/190852090-9e62e488-1b9f-46d9-a54c-ca5af3fabd72.mp4


# API Usage

The two APIs used for making this app are https://rapidapi.com/tipsters/api/priceline-com-provider (flights) and https://rapidapi.com/apidojo/api/hotels4/ (accommodations).

The first screen of each section makes an API call after the user has input 3 or more characters. A dropdown menu will subsequently display a **scrollable list of suggestions** to the user based on the response recieved from the API for the given keyword.
<p align="center">
<img width="200" heigth="200" alt="Airport Suggestions" src="https://user-images.githubusercontent.com/98110966/190848808-f2b6b0fe-c5ed-49d8-8d48-641eed35d43b.png">
<img width="200" heigth="200" alt="Accommodation Suggestions" src="https://user-images.githubusercontent.com/98110966/190848671-f75e8dcd-ba87-4296-b205-e04f8b133318.png">
</p>


Upon pressing the **Search Button**, a new API call is made with the parameters chosen by the user and the response entity is used for filling the results screen's cells. For the accommodations section, each time the user choses a **sorting criteria**, a new API call is made with said criteria, keeping other parameters unchanged.


**Infinite scrolling** is implemented. Each time the user scrolls to the bottom of the result list, a new API call is made, loading more data. An **activity indicator** informs the user that more data is loading. For video demonstration refer to the [Flights Section Demo](#flights-section-demo) or [Accommodations Section Demo](#accommodations-section-demo).

<p align="center">
<img width="200" heigth="200" alt="Airport Suggestions" src="https://user-images.githubusercontent.com/98110966/190851148-104a9a2d-20bd-4829-a4ef-274315274fcc.png">
</p>


If the response entity contains no data regarding available flights/accommodations, an appropriate message will be displayed.
<p align="center">
<img width="200" heigth="200" alt="No Flights Found Message" src="https://user-images.githubusercontent.com/98110966/190854829-f356ef8a-b252-43ce-a4ba-8d6cdb76037e.png">
<img width="200" heigth="200" alt="No Accommodations Found Message" src="https://user-images.githubusercontent.com/98110966/190854524-20d07a3a-7ba3-4b3c-a9e2-d141f7b538df.png">
</p>

# Input Validation

A search cannot be performed unless the mandatory fields are filled with valid information - that is selecting a valid airport for the flights section, respectively a valid location for the accommodations section. An appropriate alert pop-up will inform the user about this.

<p align="center">
<img width="200" heigth="200" alt="Flights Alert" src="https://user-images.githubusercontent.com/98110966/190849733-7b90156f-343e-46a8-91b9-f2456ac57160.png">
<img width="200" heigth="200" alt="Accommodations Alert" src="https://user-images.githubusercontent.com/98110966/190849735-735971d6-e6d7-406c-a650-f8db31f991b6.png">
</p>


