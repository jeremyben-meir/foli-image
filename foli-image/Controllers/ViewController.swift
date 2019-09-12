//
//  ViewController.swift
//  foli-image
//
//  Created by Jeremy Ben-Meir on 7/1/19.
//  Copyright © 2019 Jeremy Ben-Meir. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary
import MapKit
import CoreLocation

class ViewController: UIViewController, UINavigationControllerDelegate, CLLocationManagerDelegate {

    var titleLabel: UILabel!
    var imageView: UIImageView! = UIImageView()
    var findButton: UIButton!
    var addButton: UIButton!
    
    var imageLocation: CLLocation?
    
    var imagePicker: UIImagePickerController!
    let locationManager = CLLocationManager()
    
    enum ImageSource {
        case photoLibrary
        case camera
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        self.title = "Add Image"
        
        titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = UIColor(displayP3Red: 9/255, green: 116/255, blue: 79/255, alpha: 1)
        titleLabel.text = "Select an image"
        titleLabel.font =  UIFont(name: "Georgia-Bold", size: 35)
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        
        findButton = UIButton()
        findButton.translatesAutoresizingMaskIntoConstraints = false
        findButton.setTitle("Camera Roll", for: .normal)
        findButton.setTitleColor(.white, for: .normal)
        findButton.layer.cornerRadius = 8
        findButton.backgroundColor = UIColor(displayP3Red: 9/255, green: 116/255, blue: 79/255, alpha: 0.7)
        findButton.addTarget(self, action: #selector(loadFind), for: .touchUpInside)
        view.addSubview(findButton)
        
        addButton = UIButton()
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle("Take Image", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.layer.cornerRadius = 8
        addButton.backgroundColor = UIColor(displayP3Red: 9/255, green: 116/255, blue: 79/255, alpha: 0.7)
        //addButton.setImage(UIImage(named: "acct"), for: .normal)
        addButton.addTarget(self, action: #selector(loadAdd), for: .touchUpInside)
        view.addSubview(addButton)
        
        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (1/6) * view.frame.size.height),
            titleLabel.widthAnchor.constraint(equalToConstant: view.frame.size.width)
            ])
        NSLayoutConstraint.activate([
            findButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (1/3) * view.frame.size.height),
            findButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            findButton.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: -4),
            findButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
            ])
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (1/3) * view.frame.size.height),
            addButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            addButton.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 4),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
            ])
    }
    
    @objc func loadFind(){
        locationManager.stopUpdatingLocation()
        selectImageFrom(.photoLibrary)
        
    }
    
    @objc func loadAdd(){
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            selectImageFrom(.photoLibrary)
            return
        }
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        selectImageFrom(.camera)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
        imageLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
    }
    
    func selectImageFrom(_ source: ImageSource){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        switch source {
        case .camera:
            imagePicker.sourceType = .camera
        case .photoLibrary:
            imagePicker.sourceType = .photoLibrary
        }
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Saving Image here
    @IBAction func save(_ sender: AnyObject) {
        guard let selectedImage = imageView.image else {
            print("Image not found!")
            return
        }
        UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            showAlertWith(title: "Save error", message: error.localizedDescription)
        } else {
            showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
        }
    }
    
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

extension ViewController: UIImagePickerControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        if let url =  info[UIImagePickerController.InfoKey.referenceURL] as? URL {
            if let asset: PHAsset = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil)[0] {
                print(asset.location ?? "None")
                imageLocation = asset.location
                // TODO: add image and imageLocation to backend
            }
        }
        
        
        
        imageView.image = selectedImage
    }
}


