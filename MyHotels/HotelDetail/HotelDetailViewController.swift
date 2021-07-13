//
//  HotelDetailViewController.swift
//  MyHotels
//
//  Created by Banisetty Avinash on 7/11/21.
//

import UIKit

enum DetailViewOpenState {
    case add
    case edit
}

class HotelDetailViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: HotelsViewModel?
    var openState: DetailViewOpenState?
    var imageName: String?
    
    // MARK: - IBOutlets

    @IBOutlet weak var nameValue: UITextField!
    @IBOutlet weak var addressValue: UITextView!
    @IBOutlet weak var dateValue: UIDatePicker!
    @IBOutlet weak var roomRateValue: UITextField!
    @IBOutlet weak var photoValue: UIImageView!
    @IBOutlet weak var ratingView: RatingView!
    @IBOutlet weak var deleteHotel: UIButton!
    
    // MARK: - Init
    
    func setDefaultValues() {
        dateValue.date = Date()
        
        if openState == .edit {
            // Fill all the values
            if let validIndex = viewModel?.selectedIndex, let hotelData = viewModel?.hotelsData[validIndex] {
                nameValue.text = hotelData.name
                addressValue.text = hotelData.address
                dateValue.date = hotelData.dateOfStay
                if hotelData.roomRate > 0 {
                    roomRateValue.text = String(hotelData.roomRate)
                }
                imageName = hotelData.imageName
                let cachedImage = ImageCache.cache.image(name: imageName!)
                photoValue.image = cachedImage
                ratingView.currentRating = hotelData.rating
            }
            
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Setup UI
    
    func setBorderForTextEntryFields() {
        
        let borderColor = CGColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        addressValue.layer.borderColor = borderColor
        addressValue.layer.borderWidth = 1.0
                
        nameValue.layer.borderColor = borderColor
        roomRateValue.layer.borderColor = borderColor
    }
    
    func setNavigationItems() {
        
        if openState == .add {
            self.navigationItem.title = "Add Favourite Hotel"
        } else {
            self.navigationItem.title = "Edit Hotel Details"
        }

        // Set bar buttons in navigation item
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveDetails(sender:)))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel(sender:)))
    }
    
    func setDynamicComponents() {
        
        switch openState {
        case .add:
            deleteHotel.isHidden = true
        case .edit:
            deleteHotel.isHidden = false
        case .none:
            break
        }
    }
    
    func setControlBehaviour() {
        roomRateValue.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        setDefaultValues()
        setBorderForTextEntryFields()
        setNavigationItems()
        setDynamicComponents()
        setControlBehaviour()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - IBActions
    
    @IBAction func selectPhoto(_ sender: Any) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {_ in
            self.takePhoto()
        }))
        
        alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
            self.choosePhoto()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // To cover the iPad cases
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            let sourceButton = sender as? UIButton
            alert.popoverPresentationController?.sourceView = sourceButton
            alert.popoverPresentationController?.sourceRect = sourceButton?.bounds ?? CGRect.zero
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        present(alert, animated: true, completion: nil)

    }
    
    @objc func saveDetails(sender: UIButton) {
        
        let roomRate: Float
        if let roomRateString = roomRateValue.text, let roomRateNum = Float(roomRateString) {
            roomRate = roomRateNum
        } else {
            roomRate = 0
        }
        
        let currentHotelData = HotelEntity(name: nameValue.text ?? "",
                                           address: addressValue.text,
                                           dateOfStay: dateValue.date,
                                           roomRate: roomRate,
                                           rating: ratingView.currentRating,
                                           imageName: imageName ?? "placeholder")
        
        switch openState {
        case .add:
            if let hotelName = nameValue.text, !hotelName.isEmpty {
                viewModel?.addHotel(withDetails: currentHotelData)
                dismiss(animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Invalid Data", message: "Enter a name", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                    alert.dismiss(animated: true, completion: nil)
                }))
                present(alert, animated: true, completion: nil)
            }
            break
        case .edit:
            viewModel?.editHotel(withDetails: currentHotelData)
            dismiss(animated: true, completion: nil)
            break
        default:
            break
        }
        
    }
    
    @objc func cancel(sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteHotelEntry(_ sender: Any) {
        
        viewModel?.deleteHotel()
        dismiss(animated: true, completion: nil)
    }
        
    //MARK: - Open the camera
    
    private func takePhoto(){
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Error", message: "Camera is not supported", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Choose Camera roll
    
    private func choosePhoto(){
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            //If you dont want to edit the photo then you can set allowsEditing to false
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            present(imagePicker, animated: true, completion: nil)
        } else {
            let alert  = UIAlertController(title: "Error", message: "Photo Library is not supported", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension HotelDetailViewController: UITextFieldDelegate {
    
    // Allow only numbers
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let newCharacters = CharacterSet(charactersIn: string)
        let boolIsNumber = NSCharacterSet.decimalDigits.isSuperset(of: newCharacters)
        return boolIsNumber
    }
}

// MARK: - Image Picker Delegate

extension HotelDetailViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            // Generate a unique string for the image name and store in cache
            let uuidString = UUID.init().uuidString
            imageName = uuidString
            photoValue.image = selectedImage
            ImageCache.cache.saveImage(name: uuidString, image: selectedImage)
        }
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //Dismiss the UIImagePicker after selection
        picker.dismiss(animated: true, completion: nil)
    }
}
