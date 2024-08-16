//
//  TableViewCell.swift
//  text
//
//  Created by imac 1682's MacBook Pro on 2024/8/6.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var lbseetb: UILabel!
    static let identifier = "TableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
