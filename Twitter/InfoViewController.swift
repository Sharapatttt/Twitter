//
//  InfoViewController.swift
//  Twitter
//
//  Created by Sharapat Azamat on 12/3/20.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class InfoViewController: UIViewController,UITableViewDelegate, UITableViewDataSource  {
    
    
    var current_user : User?
    var databaseRef = Database.database().reference()
    var storageRef = Storage.storage().reference()
    @IBOutlet weak var username_field: UILabel!
    @IBOutlet weak var name_field: UILabel!
    @IBOutlet weak var surname_field: UILabel!
    var tweet : Tweet?

    @IBOutlet weak var mytableview: UITableView!
    var mainVC = MainPageViewController()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainVC.tweets.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoTableViewCell") as? InfoTableViewCell
        
        cell?.authorName?.text = mainVC.tweets[indexPath.row].author
        cell?.tweetName?.text = mainVC.tweets[indexPath.row].content
        cell?.hashtag?.text = mainVC.tweets[indexPath.row].hashtag
        cell?.dateLabel?.text = mainVC.tweets[indexPath.row].generateCurrentTimeStamp()
        
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.current_user = Auth.auth().currentUser
        
        // Do any additional setup after loading the view.
        databaseRef.child("user_profile").child(self.current_user!.uid).observeSingleEvent(of: .value) { [weak self] (snapshot: DataSnapshot) in
            let value = snapshot.value as? NSDictionary
            self?.username_field.text = value?["email"] as? String ?? ""
            self?.name_field.text = value?["name"] as? String ?? ""
            self?.surname_field.text = value?["surname"] as? String ?? ""
        }
        mainVC.current_user = Auth.auth().currentUser
        // Do any additional setup after loading the view.
        let parent = Database.database().reference().child("tweets")
        parent.observe(.value) { [weak self](snapshot) in
            self?.mainVC.tweets.removeAll()
            for child in snapshot.children {
                if let snap = child as? DataSnapshot{
                    let tweet = Tweet(snapshot: snap)
                    self?.mainVC.tweets.append(tweet)
                }
            }
            self?.mainVC.tweets.reverse()
            
            self?.mytableview.reloadData()
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
}


