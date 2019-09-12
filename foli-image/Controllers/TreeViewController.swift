//
//  TreeViewController.swift
//  foli-image
//
//  Created by Jeremy Ben-Meir on 8/1/19.
//  Copyright © 2019 Jeremy Ben-Meir. All rights reserved.
//

import UIKit
import Photos
import MapKit
import CoreLocation
import AssetsLibrary

class TreeViewController: UIViewController {
    
    var imageView: UIImageView!
    var locButton: UIButton!
    
    var tree: Tree
    
    init(inputTree: Tree) {
        tree = inputTree
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tree"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(deleteImage))
        
        imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = tree.image
        view.addSubview(imageView)
        
        locButton = UIButton()
        locButton.translatesAutoresizingMaskIntoConstraints = false
        locButton.setTitle("Edit Location", for: .normal)
        locButton.setTitleColor(.white, for: .normal)
        locButton.layer.cornerRadius = 8
        locButton.backgroundColor = UIColor(displayP3Red: 9/255, green: 116/255, blue: 79/255, alpha: 0.7)
        locButton.addTarget(self, action: #selector(changeLocation), for: .touchUpInside)
        view.addSubview(locButton)
        
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: view.frame.width),
            ])
        NSLayoutConstraint.activate([
            locButton.centerYAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 78),
            locButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            locButton.widthAnchor.constraint(equalToConstant: view.frame.width * (3/5)),
            locButton.heightAnchor.constraint(equalToConstant: 30),
            
            ])
    }
    
    @objc func deleteImage(){
        let alert = UIAlertController(title: "Are you sure you want to delete the image?", message: "The image will be removed from the database.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler:
            { action in
                if let navController = self.navigationController {
                    navController.popViewController(animated: true)
                }
                //TODO: delete photo from database
        
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }

    @objc func changeLocation(){
        let mapViewController = MapViewController(inputTree: tree)
        navigationController?.pushViewController(mapViewController, animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
