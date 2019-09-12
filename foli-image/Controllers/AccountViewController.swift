import UIKit
import GoogleSignIn
import MapKit
import CoreLocation


class AccountViewController: UIViewController {
    
    
    var image: UIImageView!
    var accountImage: UIImage!
    var nameLabel: UILabel!
    
    var email: String
    var firstName: String
    var lastName: String
    
    var thisUser: User!
    
    var collectionView: UICollectionView!
    var treeArray: [Tree] = []
    
    let photoCellReuseIdentifier = "photoCellReuseIdentifier"
    let headerReuseIdentifier = "headerReuseIdentifier"
    let padding: CGFloat = 5
    let headerHeight: CGFloat = 30
    
    init(email: String, firstName: String, lastName: String) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "My Account"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOut))
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = padding
        layout.minimumInteritemSpacing = padding
        
        //TODO: Get all Tree objects from backend
        //treeArray = [Tree(inputImage: UIImage(named: "1")!, inputLocation: CLLocation(latitude: 40.7928698, longitude: -73.9646114)), Tree(inputImage: UIImage(named: "2")!, inputLocation: nil), Tree(inputImage: UIImage(named: "3")!, inputLocation: nil), Tree(inputImage: UIImage(named: "4")!, inputLocation: nil), Tree(inputImage: UIImage(named: "5")!, inputLocation: nil), Tree(inputImage: UIImage(named: "6")!, inputLocation: nil), Tree(inputImage: UIImage(named: "7")!, inputLocation: nil), Tree(inputImage: UIImage(named: "8")!, inputLocation: nil), Tree(inputImage: UIImage(named: "9")!, inputLocation: nil), Tree(inputImage: UIImage(named: "10")!, inputLocation: nil), Tree(inputImage: UIImage(named: "11")!, inputLocation: nil), Tree(inputImage: UIImage(named: "12")!, inputLocation: nil)]
        
        NetworkManager.getUser(email: email, completion: { user in
            if (user == nil){
                NetworkManager.signUp(firstName: self.firstName, lastName: self.lastName, email: self.email, completion: { (newUser) in
//                    NetworkManager.getPhotos(id: newUser.id, completion: { (newTreeArray) in
//                        self.treeArray=newTreeArray
//                    })
                })
            } else {
                self.thisUser = user
                NetworkManager.getPhotos(id: self.thisUser.id, completion: { (newTreeArray) in
                    self.treeArray=newTreeArray
                })
            }
        })
        
        image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "prof") //get image
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.gray.cgColor
        image.layer.cornerRadius = 75
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        view.addSubview(image)
        
        nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = UIColor(displayP3Red: 9/255, green: 116/255, blue: 79/255, alpha: 1)
        nameLabel.text = firstName + " " + lastName
        nameLabel.font =  UIFont(name: "Georgia-Bold", size: 35)
        nameLabel.textAlignment = .center
        view.addSubview(nameLabel)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TreeCollectionViewCell.self, forCellWithReuseIdentifier: photoCellReuseIdentifier)
        view.addSubview(collectionView)
        
        setupConstraints()
    }
    
    func setupConstraints(){
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            image.widthAnchor.constraint(equalToConstant: 150),
            image.heightAnchor.constraint(equalToConstant: 150)
            ])
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 25)
            ])
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 25),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -1*padding),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    func changeTextLabel(newstring:String) {
        nameLabel.text = newstring
    }
    
    @objc func signOut(){
        GIDSignIn.sharedInstance().signOut()
        let signInVC = SignInViewController()
        present(signInVC, animated: true, completion: nil)
    }
    
    
}

extension AccountViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return treeArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellReuseIdentifier, for: indexPath) as! TreeCollectionViewCell
        let tree = treeArray[indexPath.item]
        cell.configure(for: tree)
        return cell
    }
    
    
}

extension AccountViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let treeViewController = TreeViewController(inputTree: treeArray[indexPath.item])
        navigationController?.pushViewController(treeViewController, animated: true)
    }
}

extension AccountViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = (collectionView.frame.width - 2*padding)/3
        return CGSize(width: length, height: length)
        
    }
}
