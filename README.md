# MyHotels

**Problem Statement:** To show a list of hotels, provision to add a new hotel and edit existing hotel details.

**How to run:** Open MyHotels.xcodeproj. Select MyHotels target and desired iPhone/iPad simulator. Click on Run button.

**Architecture:** MVVM. 

**Components:**

  - HotelsList
  - HotelDetail
  - Base

**HotelsList**

This group has custom TableViewController and TableViewCell classes for UI, HotelEntity structure for Model and a ViewModel class to communicate effectively between ViewController and Model.

**Hotel Detail**

This group has custom UIViewController. Since, details page doesn't have a complex model part, Model and ViewModel of ListViewController are reused.

**Base**

This group has base classes required for binding between ViewModel and ViewController. ViewControllers should be subscribed to ViewModels to get required updates.

**Screenshots**

<img src="https://github.com/avinash-ivy/MyHotels/blob/main/Screenshots/HotelList.png"
  alt="Hotels List"
  width="289" height="600">
</p>

<img src="https://github.com/avinash-ivy/MyHotels/blob/main/Screenshots/HotelDetail.png"
  alt="Hotel Detail"
  width="289" height="600">
</p>
