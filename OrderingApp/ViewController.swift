//
//  ViewController.swift
//  OrderingApp
//
//  Created by Griffin Healy on 4/5/18.
//  Copyright © 2018 Griffin Healy. All rights reserved.
//
// April 12th, 2018 7PM
import UIKit
import Firebase

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    
   let appNameText: UILabel = {
        let appNametext = UILabel()
        appNametext.text = "Add/Change your profile pic!"
        appNametext.translatesAutoresizingMaskIntoConstraints = false
        appNametext.textColor = UIColor.rgb(red: 30, green: 255, blue: 170)
        appNametext.font = UIFont(name: "AppleSDGothicNeo-Light", size: 10)
        appNametext.numberOfLines = 0
        //appNametext.lineBreakMode = NSLineBreakMode.byWordWrapping
        return appNametext
    }()
    // Adding Image
    let appnameImageView: UIImageView = {
        let appnameImageView = UIImageView()
        appnameImageView.image = UIImage(named: "WordArt.png")
        appnameImageView.translatesAutoresizingMaskIntoConstraints = false //You need to call this property so the image is added to your view
        return appnameImageView
    }()
    
    let userHomeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "addUserIcon"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleAddPhoto), for: .touchUpInside)
        return button;
    }()
    
    @objc func handleAddPhoto() {
       let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
        
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            userHomeButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            userHomeButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }

        userHomeButton.layer.cornerRadius = 20
        userHomeButton.layer.borderColor = UIColor.blue.cgColor
        userHomeButton.layer.masksToBounds = true
        dismiss(animated: true, completion: nil)
    }

    let emailTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter Email"
        textfield.backgroundColor = UIColor(white: 0, alpha: 0.07)
        textfield.borderStyle = .roundedRect
        
        textfield.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textfield
    }()
    @objc func handleTextInputChange() {
    let isWholeFormValid = emailTextField.text!.characters.count ?? 0 > 0 && usernameTextField.text!.characters.count ?? 0 > 0 && passwordTextField.text!.characters.count ?? 0 > 0
        
        if isWholeFormValid {
            createAccountButton.isEnabled = true
            createAccountButton.backgroundColor = UIColor.rgb(red: 50, green: 250, blue: 250)
        }
        else {
            createAccountButton.isEnabled = false
            createAccountButton.backgroundColor = UIColor.rgb(red: 149, green: 255, blue: 200)
        }
    }
    
    let usernameTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter Username"
        textfield.backgroundColor = UIColor(white: 0, alpha: 0.07)
        textfield.borderStyle = .roundedRect
        textfield.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textfield
    }()
    let passwordTextField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Enter Password"
        textfield.backgroundColor = UIColor(white: 0, alpha: 0.07)
        textfield.borderStyle = .roundedRect
        textfield.isSecureTextEntry = true
        textfield.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textfield
    }()
    
    let createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Your Account", for: .normal)
        button.backgroundColor = UIColor.rgb(red: 149, green: 255, blue: 200)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        
        return button;
    }()
    
    @objc func handleSignup()
    {
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let username = usernameTextField.text, username.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        
        
        Auth.auth().createUser(withEmail: email, password: password, completion: {(user: User?, error: Error?) in
            
            if let err = error {
                
                print("Failed to create User", err)
                return
            }
            print("Successfuly created user:", user?.uid ?? "")
            
            guard let image = self.userHomeButton.imageView?.image else { return }
            
            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
            let filename = NSUUID().uuidString
            Storage.storage().reference().child("profile_images").child(filename).putData(uploadData, metadata: nil, completion: {(metadata, err)
            in
            if let err = err {
                
                print("Failed to upload profile picture", err)
            }
                
                guard let profileImageURL = metadata?.downloadURL()?.absoluteString else { return }
                print("Successfully uploaded profile picture", profileImageURL)
                
                
                guard let uid = user?.uid else { return }
                
                let dictValues = ["username": username, "profileImageUrl" : profileImageURL]
                let values = [uid : dictValues]
                Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                    
                    if let err = err {
                        print("Failed to save a new user info to database:", err)
                    }
                    print("Successfully saved user infro to database")
                    
                })
                
            })
            
    
            })
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(userHomeButton) //Constraints for button, the 4 lines
        userHomeButton.anchor(top: view.topAnchor, left: nil, right: nil, bottom: nil, paddingTop: 190, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 90, height: 90)
         userHomeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

       view.addSubview(appNameText)
        appNameText.anchor(top: view.topAnchor, left: nil, right: nil, bottom: nil, paddingTop: 248, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 90, height: 90)
        appNameText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(appnameImageView) // App name image
        appnameImageView.anchor(top: view.topAnchor, left: nil, right: nil, bottom: nil, paddingTop: 10, paddingLeft: 0, paddingRight: 0, paddingBottom: 0, width: 180, height: 180)
        appnameImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        setupInputFields()

       // view.addSubview(emailTextField)
    }
    
    fileprivate func setupInputFields() {
        //let gview = UIView()
        //gview.backgroundColor = UIColor.green
        
        let  stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, createAccountButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 12
        
        view.addSubview(stackView)
        
        // NSLayoutConstraint.activate([
          //  stackView.heightAnchor.constraint(equalToConstant: 180)
           // ])
        // stackView.topAnchor.constraint(equalTo: userHomeButton.bottomAnchor, constant: 20),
        // stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
        // stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
            
        
        stackView.anchor(top: userHomeButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, bottom: nil, paddingTop: 30, paddingLeft: 40, paddingRight: -40, paddingBottom: 0, width: 0, height: 190)
    }
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, right: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor? ,paddingTop: CGFloat, paddingLeft: CGFloat, paddingRight: CGFloat, paddingBottom: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
        self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        if width != 0 {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            
             self.heightAnchor.constraint(equalToConstant: height).isActive = true
            
        }
    }
    
}

