//
//  Tweet.swift
//  Twitter
//
//  Created by Sharapat Azamat on 12/2/20.
//

import Foundation
import FirebaseDatabase

struct Tweet {
    var content: String?
    var author: String?
    var hashtag: String?
    var date : String?
    var dateformatter = DateFormatter()
    var dict: [String: Any]{
        return [
            "tweet": content!,
            "author": author!,
            "date" : date!,
            "hashtag": hashtag!
            
        ]
    }
    
        
    
    /*func datetostring() -> String{
        dateformatter.dateFormat = "MMM dd,yyyy"
        return dateformatter.string(from: date)
    }*/

        
    func generateCurrentTimeStamp () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss a"
        return (formatter.string(from: Date()) as NSString) as String
    }

    
    
    
    init(_ content: String, _ author: String, _ hashtag: String, _ date: String){
        self.content = content
        self.author = author
        self.hashtag = hashtag
        self.date = date
        
    }
    init(snapshot: DataSnapshot){
        if let value = snapshot.value as? [String: String]{
            content = value["tweet"]
            author = value["author"]
            hashtag = value["hashtag"]
            date = value["date"]
            
        }
    }
}
