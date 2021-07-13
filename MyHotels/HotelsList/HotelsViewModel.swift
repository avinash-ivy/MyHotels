//
//  HotelsViewModel.swift
//  MyHotels
//
//  Created by Banisetty Avinash on 7/11/21.
//

import Foundation

enum HotelsViewState {
    case view
    case add
    case edit
}

class HotelsViewModel: BaseViewModel<HotelsViewState> {
    
    // List of HotelModel data
    var hotelsData: [HotelEntity]
    var selectedIndex: Int?
    
    init() {
        hotelsData = []
        super.init(initialState: .view)
    }
    
    func addHotel(withDetails hotelData: HotelEntity) {
        
        hotelsData.append(hotelData)
        // Change the state to let View know about the change
        state = .add
    }
    
    func editHotel(withDetails hotelData: HotelEntity) {
        
        if let validIndex = selectedIndex, validIndex < hotelsData.count {
            hotelsData[validIndex] = hotelData
        }
        // Change the state to let View know about the change
        state = .edit
    }
    
    func deleteHotel() {
        
        if let validIndex = selectedIndex, validIndex < hotelsData.count {
            hotelsData.remove(at: validIndex)
        }
        // Change the state to let View know about the change
        state = .edit
    }
    
}
