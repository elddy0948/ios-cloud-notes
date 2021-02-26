import UIKit

class AddMemoViewController: UIViewController {
    //MARK: - Views
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .red
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    private let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .yellow
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButton))
        print(navigationController?.navigationBar.isHidden)
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
        self.navigationController?.popViewController(animated: true)
    }
}
