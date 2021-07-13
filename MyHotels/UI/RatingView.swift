//
//  RatingView.swift
//  MyHotels
//
//  Created by Banisetty Avinash on 7/12/21.
//

import UIKit

class RatingView: UIView {
    
    private var contentView: UIView?
    var currentRating: Int = 0 {
        didSet {
            setRatingImages()
        }
    }
            
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    private func setup() {
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        contentView = view
        // Add tap gesture recognizer for Image Views
        for aView in view.subviews {
            if let imageView = aView as? UIImageView {
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ratingStarTapped(sender:)))
                imageView.isUserInteractionEnabled = true
                imageView.addGestureRecognizer(tapGestureRecognizer)
            }
        }
        addSubview(view)
    }

    private func loadViewFromNib() -> UIView? {
        let nibName = String(describing: type(of: self))
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self,options: nil).first as? UIView
    }
    
    @objc func ratingStarTapped(sender: UITapGestureRecognizer) {
        let tappedImage = sender.view as! UIImageView
        let imageTag = tappedImage.tag
        currentRating = imageTag
        
        setRatingImages()
    }
    
    func setRatingImages() {
        
        if let containerView = contentView {
            for i in 1...5 {
                if let starImageView = containerView.viewWithTag(i) as? UIImageView {
                    if i <= currentRating {
                        starImageView.image = UIImage(named: "yellow-star")
                    } else {
                        starImageView.image = UIImage(named: "grey-star")
                    }
                }
            }
        }
    }
    
}
