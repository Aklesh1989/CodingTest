//
//  MovieTableViewCell.swift
//  CodingTest
//
//  Created by Aklesh on 21/11/20.
//

import UIKit

class FirebaseIssueTableViewCell: UITableViewCell {
  
  @IBOutlet var lblTitle: UILabel!
  @IBOutlet var lblDescription: UILabel!
  @IBOutlet var lblUpdatedDate: UILabel!
  @IBOutlet var lblCommentsCount: UILabel!
  @IBOutlet var lblIsseNumber: UILabel!



  var issue:FBIssue! {
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
    lblTitle.text = issue.title
    lblDescription.text = issue.body
    lblCommentsCount.text = "\(issue.commentsCount ?? 0)"
    lblUpdatedDate.text = issue.updated_at.convertToDate()
    lblTitle.text = issue.title
    lblIsseNumber.text = "\(issue.number ?? 0)"
  }
 
  


}
