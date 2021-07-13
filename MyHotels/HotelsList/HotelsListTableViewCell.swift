//
//  HotelsListTableViewCell.swift
//  MyHotels
//
//  Created by Banisetty Avinash on 7/13/21.
//

import UIKit

class HotelsListTableViewCell: UITableViewCell {

    @IBOutlet weak var hotelImage: UIImageView!
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    
    var hotelImg: UIImage?
    
}
