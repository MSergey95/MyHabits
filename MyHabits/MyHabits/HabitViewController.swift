import UIKit

class HabitViewController: UIViewController {
    var habit: Habit?

    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Название привычки"
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let colorLabel: UILabel = {
        let label = UILabel()
        label.text = "Цвет"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let colorButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 15
        button.backgroundColor = .black // Default color
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Время"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let timePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()

    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Сохранить", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Удалить привычку", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupActions()
        if let habit = habit {
            nameTextField.text = habit.name
            colorButton.backgroundColor = habit.color
            timePicker.date = habit.date
        }
    }

    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [
            nameTextField,
            colorLabel,
            colorButton,
            timeLabel,
            timePicker,
            saveButton,
            cancelButton,
            deleteButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func setupActions() {
        colorButton.addTarget(self, action: #selector(selectColor), for: .touchUpInside)
        timePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        saveButton.addTarget(self, action: #selector(saveHabit), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteHabit), for: .touchUpInside)
    }

    @objc private func selectColor() {
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.selectedColor = colorButton.backgroundColor ?? .black
        colorPickerVC.delegate = self
        present(colorPickerVC, animated: true, completion: nil)
    }

    @objc private func timeChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        timeLabel.text = "Каждый день в \(dateFormatter.string(from: timePicker.date))"
    }

    @objc private func saveHabit() {
        guard let name = nameTextField.text, !name.isEmpty else { return }
        let color = colorButton.backgroundColor ?? .black
        let date = timePicker.date

        if let habit = habit {
            habit.name = name
            habit.color = color
            habit.date = date
        } else {
            let newHabit = Habit(name: name, date: date, color: color)
            HabitsStore.shared.habits.append(newHabit)
        }

        HabitsStore.shared.save()
        NotificationCenter.default.post(name: .habitsDidChange, object: nil)
        dismiss(animated: true, completion: nil)
    }

    @objc private func cancel() {
        dismiss(animated: true, completion: nil)
    }

    @objc private func deleteHabit() {
        guard let habit = habit else { return }

        let alert = UIAlertController(title: "Удалить привычку", message: "Вы хотите удалить привычку \"\(habit.name)\"?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Удалить", style: .destructive, handler: { _ in
            if let index = HabitsStore.shared.habits.firstIndex(of: habit) {
                HabitsStore.shared.habits.remove(at: index)
                HabitsStore.shared.save()
                NotificationCenter.default.post(name: .habitsDidChange, object: nil)
                self.dismiss(animated: true, completion: nil)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension HabitViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        colorButton.backgroundColor = viewController.selectedColor
    }
}
