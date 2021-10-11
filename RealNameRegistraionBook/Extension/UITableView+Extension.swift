//
//  UITableView+Extension.swift
//  iOS_MomDad
//
//  Created by Woody Liu on 2021/6/27.
//

import UIKit

extension UITableView {
    
    /// tableView 自適應高度
    /// VC viewDidLoad() 呼叫
    func autoLayoutTableHeaderView() {
        tableHeaderView?.layoutIfNeeded()
        tableHeaderView = tableHeaderView
    }
}
