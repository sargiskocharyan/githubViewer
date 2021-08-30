//
//  RepoTableViewCell.swift
//  GithubViewer
//
//  Created by Sargis Kocharyan on 31.08.21.
//

import UIKit

class RepoTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWith(item: RepoItemModel) {
        self.nameLabel.text = item.name
        self.descriptionLabel.text = item.description
    }
    
}
