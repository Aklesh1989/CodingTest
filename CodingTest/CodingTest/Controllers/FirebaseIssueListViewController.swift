//
//  MovieListViewController.swift
//  CodingTest
//
//  Created by Aklesh on 21/11/20.
//

import UIKit

class FirebaseIssueListViewController: ParentVC {
  
  @IBOutlet var tableViewMovieList: UITableView!

  var issueList = [FBIssue]()
  var currentSelectedIssueNumber = 0
    override func viewDidLoad() {
        super.viewDidLoad()
      prepareView()
      getFirebaseIssueList()

    }
  
  //MARK:- UTILITY METHODS
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == SegueIdentifier.IssueDetail {
      if let destinationVC = segue.destination as? IssueDetailVC {
        destinationVC.commentID = currentSelectedIssueNumber
      }
    }
  }
  private func prepareView() {
    tableViewMovieList.tableFooterView = UIView()
  }
  
  //MARK:- WEB CALLS

  private func getFirebaseIssueList() {
    self.showSpinnerView()
    FBIssue.getAllIssues { [weak self] (list, error) in
      guard let `self` = self else { return }

      self.hideSpinnerView()
      if let array = list, array.count > 0 {
        
        // filter for open issues only.
        var openIssues = array.filter { (issue) -> Bool in
          return issue.isOpen
        }
        
        openIssues.sort { (issue1, issue2) -> Bool in
          return (issue1.updatedDate.compare(issue2.updatedDate) == .orderedDescending)
        }
        self.issueList.append(contentsOf: openIssues)
      
        DispatchQueue.main.async {
          self.tableViewMovieList.reloadData()
        }
      }
    }
  }
    

}


//MARK:- TableViewDelegate TableViewDataSource

extension FirebaseIssueListViewController:UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return issueList.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: FirebaseIssueTableViewCell.nameOfClass, for: indexPath) as! FirebaseIssueTableViewCell
    let issue = issueList[indexPath.row]
    cell.issue = issue
    cell.selectionStyle = .none
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let issue = issueList[indexPath.row]
    currentSelectedIssueNumber = issue.number
    if issue.commentsCount == 0{
      let alertVC = UIAlertController(title: nil, message: "No comments available for this issue.", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
      alertVC.addAction(okAction)
      self.present(alertVC, animated: true, completion: nil)
    } else {
      self.performSegue(withIdentifier: SegueIdentifier.IssueDetail, sender: nil)
    }
  }
  
  
}
