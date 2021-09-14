//
//  MainPageViewController.swift
//  Twitter
//
//  Created by Sharapat Azamat on 11/30/20.
//
import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

class MainPageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate {
    
    
    var current_user: User?
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mytableview: UITableView!
    var tweets: [Tweet] = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as? CustomTableViewCell
        cell!.authorName?.text = tweets[indexPath.row].author
        cell!.tweetText?.text = tweets[indexPath.row].content
        cell!.hashtag?.text = tweets[indexPath.row].hashtag
        cell!.dateLabel?.text = tweets[indexPath.row].date
        


        cell?.hashtag.textColor = .blue
        
        
        

        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let tweets = self.tweets[indexPath.row]
        if tweets.content != nil{
            Database.database().reference().child("tweets").child(uid).child(tweets.content!).onDisconnectRemoveValue { (error, ref) in
                if error != nil {
                    print("asf",error as Any)
                    return
                }
                self.tweets.remove(at: indexPath.row)
                self.mytableview.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        current_user = Auth.auth().currentUser
        // Do any additional setup after loading the view.
        let parent = Database.database().reference().child("tweets")
        parent.observe(.value) { [self] (snapshot) in
            tweets.removeAll()
            for child in snapshot.children{
                if let snap = child as? DataSnapshot{
                    let tweet = Tweet(snapshot: snap)
                    tweets.append(tweet)
                }
            }
            tweets.reverse()
            mytableview.reloadData()
            
        }
        mytableview.allowsMultipleSelectionDuringEditing = true
        
        
    }
    
    
    
    @IBAction func signout(_ sender: UIBarButtonItem) {
        do{
        try Auth.auth().signOut()
        }catch{
            print("Error message")
        }
        self.dismiss(animated: true , completion: nil)
    }
    
    @IBAction func compose(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New tweet", message: "Enter a text", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "What's   up?"
        }
        alert.addTextField { (textFieldHash) in
            textFieldHash.placeholder = "Hashtag"
        }
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Tweet", style: .default, handler: { [self, weak alert] (_) in
            let textField = alert?.textFields![0]
            let textFieldHash = alert?.textFields![1]
            let tweet = Tweet(textField!.text!, (current_user?.email)!,textFieldHash!.text!,result)
            Database.database().reference().child("tweets").childByAutoId().setValue(tweet.dict)

            
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: { (_) in
            
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
   
}


