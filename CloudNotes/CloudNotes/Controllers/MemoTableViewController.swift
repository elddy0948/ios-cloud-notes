//
//  MemoTableViewController.swift
//  CloudNotes
//
//  Created by 임성민 on 2021/02/16.
//
import CoreData
import UIKit

class MemoTableViewController: UIViewController {
    private let memoListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MemoTableViewCell.self, forCellReuseIdentifier: MemoTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var memoModel: [Memo]?
    lazy var coreDataStack = CoreDataStack(modelName: "CloudNotes")
    lazy var fetchedResultsController: NSFetchedResultsController<Memo> = {
        let fetchRequest: NSFetchRequest<Memo> = Memo.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(Memo.lastModified), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: coreDataStack.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupNavigationItem()
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetch Error: \(error), \(error.userInfo)")
        }
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
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableViewCell.reuseIdentifier, for: indexPath) as? MemoTableViewCell else {
            return UITableViewCell()
        }
        let memo = fetchedResultsController.object(at: indexPath)
        cell.configure(with: memo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let memoModel = self.memoModel else {
            return
        }
        let memo = memoModel[indexPath.row].body
        if let memoSplitViewController = splitViewController as? MemoSplitViewController {
            let memoViewController = memoSplitViewController.memoViewController
//            memoViewController.setMemo(memo)
            memoSplitViewController.showDetailViewController(memoViewController, sender: nil)
        }
    }
}
