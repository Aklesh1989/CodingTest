//
//  DetailTableViewCell.swift
//  CodingTest
//
//  Created by Aklesh on 17/01/21.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
  
  @IBOutlet var lblUserID: UILabel!
  @IBOutlet var lblDescription: UILabel!



  var comment:Comment! {
    didSet {
      displayData()
    }
  }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  
  //MARK:- UTILITY METHODS
  private func displayData() {
    lblUserID.text = comment.userID
    lblDescription.text = comment.body
  }
 
  


}
