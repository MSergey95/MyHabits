import UIKit

class HabitDetailsViewController: UIViewController {
    private var habit: Habit

    init(habit: Habit) {
        self.habit = habit
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let habitTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Править", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        updateUI()
    }

    private func setupUI() {
        navigationItem.title = "Сегодня"
        view.addSubview(habitTitleLabel)
        view.addSubview(editButton)

        NSLayoutConstraint.activate([
            habitTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            habitTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            editButton.topAnchor.constraint(equalTo: habitTitleLabel.bottomAnchor, constant: 16),
            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        editButton.addTarget(self, action: #selector(editHabit), for: .touchUpInside)
    }

    private func updateUI() {
        habitTitleLabel.text = habit.name
    }

    @objc private func editHabit() {
        let editVC = HabitViewController()
        editVC.habit = habit // Передаем привычку для редактирования
        let navController = UINavigationController(rootViewController: editVC)
        present(navController, animated: true, completion: nil)
    }
}
