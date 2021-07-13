//
//  HotelsListViewController.swift
//  MyHotels
//
//  Created by Banisetty Avinash on 7/11/21.
//

import UIKit

class HotelsListViewController: UITableViewController {

    // MARK: - Properties
    // Create View Model at the time of Init
    var hotelsViewModel: HotelsViewModel = HotelsViewModel()
    
    // MARK: - Setup UI
    
    func setDefaults() {
        
        tableView.register(UINib(nibName: "HotelsListTableViewCell", bundle: nil), forCellReuseIdentifier: "HotelsListViewCell")
    }
    
    func setUpNativationItems() {
        
        self.navigationItem.title = "My Hotels"
        // Set bar buttons in navigation item
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addHotel(sender:)))
        self.navigationItem.leftBarButtonItem = editButtonItem
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Allow to edit the hotel details.
        tableView.allowsSelectionDuringEditing = true
        setUpNativationItems()
        setBindings()
        setDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        /*
        if viewModel?.hotelsData?.count != 0 {
            self.navigationItem.leftBarButtonItem = editButtonItem
        }
        else {
            self.navigationItem.leftBarButtonItem = nil
        }
        */
    }
    
    //MARK: - Binding
    func setBindings() {
        // Bind View to View Model to receive call backs for state change
        hotelsViewModel.subscribe(view: self)
    }
        
    //MARK: - Private
    
    private func showHotelScreen(withOpenType type: DetailViewOpenState, atIndex index: Int = 0) {
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailViewController = storyboard.instantiateViewController(withIdentifier: "HotelDetailViewController") as? HotelDetailViewController {
            let navigationController = UINavigationController(rootViewController: detailViewController)
            detailViewController.viewModel = hotelsViewModel
            switch type {
            case .add:
                detailViewController.openState = .add
            case .edit:
                detailViewController.openState = .edit
                hotelsViewModel.selectedIndex = index
            }
            present(navigationController, animated: true) {
                // Do nothing
            }
        }
    }
    
    //MARK: - IBAction
        
    @objc func addHotel(sender: UIButton) {
        showHotelScreen(withOpenType: .add)
    }
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotelsViewModel.hotelsData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HotelsListViewCell") as! HotelsListTableViewCell
        if indexPath.row < hotelsViewModel.hotelsData.count {
            // Since it is only a entity, we are using it in View component
            let hotelData = hotelsViewModel.hotelsData[indexPath.row]
            let image = ImageCache.cache.image(name: hotelData.imageName)
            if let validImage = image {
                cell.hotelImage.image = validImage
            } else {
                print("DEBUG:: Image not available with name \(hotelData.imageName)")
                cell.hotelImage.image = UIImage(named: "hotel-placeholder")
            }
            cell.hotelName.text = hotelData.name
            cell.ratingView.currentRating = hotelData.rating
        }
        return cell
    }
        
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            hotelsViewModel.selectedIndex = indexPath.row
            hotelsViewModel.deleteHotel()
        }
    }
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditing {
            showHotelScreen(withOpenType: .edit, atIndex: indexPath.row)
        }
    }
}

// MARK: - StatefulView

extension HotelsListViewController: StatefulView {
    
    func render(state: HotelsViewState) {
        switch state {
        case .add:
            // Present Hotel Detail View to add hotel details
            tableView.reloadData()
        case .edit:
            // Present Hotel Detail View to edit hotel details
            tableView.reloadData()
        case .view:
            // Default view state
            break
        }
        isEditing = false
    }
}
