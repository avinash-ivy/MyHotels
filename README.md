# MyHotels

**Problem Statement:** To show a list of hotels, add a new hotel and edit existing hotel details.

**How to run:** Open MyHotels.xcodeproj. Select MyHotels target and desired iPhone/iPad simulator. Click on Run button.

**Architecture:** MVVM. 

**Components:**

  - HotelsList
  - HotelDetail
  - Base

**HotelsList**

Entities that are required to create Hotels List View. It has custom TableViewController and TableViewCell classes for UI and HotelEntity structure for Model. A ViewModel class to communicate effectively between ViewController and Model.

**Hotel Detail**

Entities in this component are written following the Tempo Architecture. Since, details page doesn't have a complex UI, component part of tempo is ignored here. Component duty is delegated to Presenter. 

**Base**

Base classes required for binding between ViewModel and ViewController. ViewControllers are subscribed for required changes in the ViewModel.


**Screenshots**

<img src="https://github.com/avinash-ivy/ProductListView/blob/main/TempoProductList.png"
  alt="Tempo Detail"
  width="289" height="600">
</p>

<img src="https://github.com/avinash-ivy/ProductListView/blob/main/TempoDetail.png"
  alt="Tempo Detail"
  width="289" height="600">
</p>
