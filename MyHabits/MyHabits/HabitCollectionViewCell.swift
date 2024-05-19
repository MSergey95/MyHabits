import UIKit

protocol HabitCollectionViewCellDelegate: AnyObject {
    func didTapCheckmark(at indexPath: IndexPath)
}

class HabitCollectionViewCell: UICollectionViewCell {
    weak var delegate: HabitCollectionViewCellDelegate?
    private var indexPath: IndexPath?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let counterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let checkmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(counterLabel)
        contentView.addSubview(checkmarkButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: checkmarkButton.leadingAnchor, constant: -20),

            timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            counterLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 4),
            counterLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            counterLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            checkmarkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            checkmarkButton.widthAnchor.constraint(equalToConstant: 32),
            checkmarkButton.heightAnchor.constraint(equalToConstant: 32)
        ])

        checkmarkButton.addTarget(self, action: #selector(didTapCheckmark), for: .touchUpInside)

        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .white
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentView.layer.shadowRadius = 4
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with habit: Habit, indexPath: IndexPath, delegate: HabitCollectionViewCellDelegate) {
        self.indexPath = indexPath
        self.delegate = delegate
        titleLabel.text = habit.name
        titleLabel.textColor = habit.color
        timeLabel.text = " \(habit.dateString)"
        counterLabel.text = "Счётчик: \(habit.trackDates.count)"

        if habit.isAlreadyTakenToday {
            checkmarkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            checkmarkButton.tintColor = habit.color
        } else {
            checkmarkButton.setImage(UIImage(systemName: "circle"), for: .normal)
            checkmarkButton.tintColor = habit.color
        }
    }

    @objc private func didTapCheckmark() {
        guard let indexPath = indexPath else { return }
        delegate?.didTapCheckmark(at: indexPath)
    }
}
