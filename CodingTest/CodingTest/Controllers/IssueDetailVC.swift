//
//  IssueDetailVC.swift
//  CodingTest
//
//  Created by Aklesh on 17/01/21.
//

import UIKit

class IssueDetailVC: ParentVC {
  
  @IBOutlet var tableViewCommentList: UITableView!


  var commentID:Int!
  var commentList = [Comment]()

    override func viewDidLoad() {
        super.viewDidLoad()
      //navigationController?.navigationBar.tintColor = .white
      prepareView()
      getCommentList()
    }
  
  //MARK:- UTILITY METHODS
  private func prepareView() {
    tableViewCommentList.tableFooterView = UIView()
  }
  
  //MARK:- WEB CALLS
  private func getCommentList() {
    self.showSpinnerView()
    let issueNumber = "\(commentID!)"
    Comment.getAllComments(issueNumber: issueNumber) { [weak self] (list, error) in
      guard let `self` = self else { return }

      self.hideSpinnerView()
      if let array = list, array.count > 0 {
          self.commentList.append(contentsOf: array)
        DispatchQueue.main.async {
          self.tableViewCommentList.reloadData()
        }
      }
    }
    
  }
}

//MARK:- TableViewDelegate TableViewDataSource

extension IssueDetailVC:UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return commentList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.nameOfClass, for: indexPath) as! DetailTableViewCell
    let comment = commentList[indexPath.row]
    cell.comment = comment
    cell.selectionStyle = .none
    return cell
  }
  
  
  
}
