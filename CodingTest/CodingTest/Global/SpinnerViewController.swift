//
//  SpinnerViewController.swift
//  Contact
//
//  Created by Aklesh Rathaur on 27/11/19.
//  Copyright © 2019 Aklesh Rathaur. All rights reserved.
//

import UIKit

class SpinnerViewController: UIViewController {
  var spinner:UIActivityIndicatorView!
  
    override func loadView() {
      if #available(iOS 13.0, *) {
        spinner = UIActivityIndicatorView(style: .large)
      } else {
        spinner = UIActivityIndicatorView(style: .gray)
      }
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
