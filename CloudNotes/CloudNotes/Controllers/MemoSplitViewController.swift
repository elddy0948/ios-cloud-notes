//
//  MemoSplitViewController.swift
//  CloudNotes
//
//  Created by 임성민 on 2021/02/16.
//

import UIKit

class MemoSplitViewController: UISplitViewController {
    let memoTableViewController = UINavigationController(rootViewController: MemoTableViewController())
    let memoViewController = UINavigationController(rootViewController: MemoViewController())
    let addMemoViewController = UINavigationController(rootViewController: AddMemoViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewControllers = [memoTableViewController]
        self.preferredPrimaryColumnWidthFraction = 1/3
        self.preferredDisplayMode = .oneBesideSecondary
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewControllers.append(memoViewController)
    }
}
