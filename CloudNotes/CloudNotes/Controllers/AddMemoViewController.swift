import CoreData
import UIKit

class AddMemoViewController: UIViewController {
    //MARK: - Views
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .secondarySystemBackground
        textField.font = UIFont.systemFont(ofSize: 30)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    private let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    var managedObjectContext: NSManagedObjectContext?
    
    lazy var memo: Memo? = {
        guard let context = managedObjectContext else {
            return nil
        }
        return Memo(context: context)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButton))
        view.addSubview(titleTextField)
        view.addSubview(bodyTextView)
        configureConstraints()
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bodyTextView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor),
            bodyTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bodyTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bodyTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    //MARK: - Actions
    @objc private func didTapDoneButton() {
        //Save in CoreData
        print("Did tap done")
        guard let memo = memo,
              let managedObjectContext = managedObjectContext else {
            return
        }
        managedObjectContext.performAndWait {
            memo.title = titleTextField.text ?? ""
            memo.body = bodyTextView.text
            memo.lastModified = 146000
        }
        
        do {
            try managedObjectContext.save()
            print("Saved!")
        } catch let error as NSError {
            print("Save Error: \(error), \(error.userInfo)")
        }
    }
}
