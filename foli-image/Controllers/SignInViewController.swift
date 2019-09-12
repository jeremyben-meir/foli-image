import UIKit
import GoogleSignIn

class SignInViewController: UIViewController {
    
    var signInButton: GIDSignInButton!
    var imageView: UIImageView!
    let verticalSpace: CGFloat = 125
    var wid: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "icon")
        view.addSubview(imageView)
        
        signInButton = GIDSignInButton()
        signInButton.style = .wide
        signInButton.colorScheme = .light
        signInButton.center = view.center
        view.addSubview(signInButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: (1/4) * view.frame.size.height - 20),
            imageView.widthAnchor.constraint(equalToConstant: (3/7) * view.frame.size.width)
            //imageView.widthAnchor.constraint(equalToConstant: 150)
            ])
    }
}
