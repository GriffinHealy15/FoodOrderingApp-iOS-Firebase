//
//  UserProfileHeader.swift
//  OrderingApp
//
//  Created by Griffin Healy on 4/12/18.
//  Copyright © 2018 Griffin Healy. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader:  UICollectionViewCell {
    
    let profileImageView: UIImageView = {
    
    let theProfImage = UIImageView()
    theProfImage.backgroundColor = .purple
        return theProfImage
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .blue
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor, left: nil, right: self.rightAnchor, bottom: nil, paddingTop: 10, paddingLeft: 0, paddingRight: -150, paddingBottom: 0, width: 70, height: 70)
        profileImageView.layer.cornerRadius = 20
        
        putProfilePicOnPage()
        
    }
    
    fileprivate func putProfilePicOnPage() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot)
            in print(snapshot.value ?? "")
            
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            guard let profileImageUrl = dictionary["profileImageUrl"] as? String else { return }
            guard let url = URL(string: profileImageUrl) else { return }
            
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                // Check for error, and construct image using data
                if let err = err {
                    print ("Could not fetch the Url profile image", err)
                }
                // Check for HTTP Status code : - 200 -
                print(data)
                
                guard let data = data else { return }
                let image = UIImage(data: data)
                // Need to get back on main UI thread
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
            }.resume()
            
            
        }) { (err) in
            print ("Failed to fetch user", err)
        }
        
        
        
        
        
        
        
       
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
