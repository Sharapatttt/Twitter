//
//  InfoTableViewCell.swift
//  Twitter
//
//  Created by Sharapat Azamat on 12/4/20.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var tweetName: UILabel!
    @IBOutlet weak var hashtag: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
