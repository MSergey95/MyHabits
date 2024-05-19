import UIKit

class InfoViewController: UIViewController {

    private let textView: UITextView = {
        let textView = UITextView()
        textView.text = """
        Привычки за 21 день:

        Этот раздел содержит информацию о том, как формируются привычки и советы по их внедрению в вашу повседневную жизнь. Формирование привычек занимает 21 день и состоит из нескольких этапов.
        """
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(textView)

        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
