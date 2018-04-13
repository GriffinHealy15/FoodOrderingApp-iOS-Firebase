//
//  UserProfileController.swift
//  OrderingApp
//
//  Created by Griffin Healy on 4/12/18.
//  Copyright © 2018 Griffin Healy. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        navigationItem.title = Auth.auth().currentUser?.uid
      
        fetchUser()
        
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerID")

    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerID", for: indexPath)
        //header.backgroundColor = .green
        
        return header
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    
    fileprivate func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot)
            in print(snapshot.value ?? "")
            
            guard let dictionary = snapshot.value as? [String : Any] else { return }
            //let profileImageUrl = dictionary["profileImageUrl"] as? String
            let username = dictionary["username"] as? String
            self.navigationItem.title = username
            
            //self.collectionView?.reloadData()
            
           
        }) { (err) in
            print ("Failed to fetch user", err)
        }
    }
}

//struct User {
  //  let username : String
   // let profileImageUrl : String

//}


