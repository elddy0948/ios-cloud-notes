//
//  MemoTableViewController.swift
//  CloudNotes
//
//  Created by 임성민 on 2021/02/16.
//

import UIKit

class MemoTableViewController: UIViewController {
    private let memoListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MemoTableViewCell.self, forCellReuseIdentifier: MemoTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var memoModel: [Memo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memoModel = MemoModel.getData()
        configureTableView()
        setupNavigationItem()
    }
    private func setupNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        navigationItem.title = "메모"
    }
    
    @objc private func didTapAddButton() {
        if let memoSplitViewController = splitViewController as? MemoSplitViewController {
            let addMemoViewcontroller = memoSplitViewController.addMemoViewController
            memoSplitViewController.showDetailViewController(addMemoViewcontroller, sender: nil)
        }
    }
}

//MARK: - TableView
extension MemoTableViewController {
    func configureTableView() {
        memoListTableView.delegate = self
        memoListTableView.dataSource = self
        memoListTableView.frame = view.frame
        view.addSubview(memoListTableView)
        configureConstraints()
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            memoListTableView.topAnchor.constraint(equalTo: view.topAnchor),
            memoListTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            memoListTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            memoListTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension MemoTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoModel?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.reuseIdentifier, for: indexPath) as? MemoTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: memoModel?[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let memoModel = self.memoModel else {
            return
        }
        let memo = memoModel[indexPath.row].body
        if let memoSplitViewController = splitViewController as? MemoSplitViewController {
            let memoViewController = memoSplitViewController.memoViewController
            memoViewController.setMemo(memo)
            memoSplitViewController.showDetailViewController(memoViewController, sender: nil)
        }
    }
}
