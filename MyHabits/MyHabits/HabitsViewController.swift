import UIKit

class HabitsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 130)
        layout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = .systemGray4
        progressView.progressTintColor = .systemPurple
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()

    private let progressLabel: UILabel = {
        let label = UILabel()
        label.text = "Всё получится!"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(habitsDidChange), name: .habitsDidChange, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .habitsDidChange, object: nil)
    }

    private func setupUI() {
        let headerView = UIView()
        headerView.backgroundColor = .white
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)

        let titleLabel = UILabel()
        titleLabel.text = "Сегодня"
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)

        headerView.addSubview(progressView)
        headerView.addSubview(progressLabel)

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addHabit))
        navigationItem.rightBarButtonItem = addButton

        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HabitCollectionViewCell.self, forCellWithReuseIdentifier: "HabitCell")

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),

            progressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            progressLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            progressView.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 4),
            progressView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            progressView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -16),

            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        updateProgress()
    }

    @objc func addHabit() {
        let habitVC = HabitViewController()
        let navController = UINavigationController(rootViewController: habitVC)
        present(navController, animated: true, completion: nil)
    }

    @objc func habitsDidChange() {
        collectionView.reloadData()
        updateProgress()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HabitsStore.shared.habits.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HabitCell", for: indexPath) as! HabitCollectionViewCell
        let habit = HabitsStore.shared.habits[indexPath.item]
        cell.configure(with: habit, indexPath: indexPath, delegate: self)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let habit = HabitsStore.shared.habits[indexPath.item]
        let habitDetailsVC = HabitDetailsViewController(habit: habit)
        navigationController?.pushViewController(habitDetailsVC, animated: true)
    }

    func updateProgress() {
        let habitsCount = HabitsStore.shared.habits.count
        let completedCount = HabitsStore.shared.habits.filter { $0.isAlreadyTakenToday }.count
        let progress = habitsCount > 0 ? Float(completedCount) / Float(habitsCount) : 0
        progressView.setProgress(progress, animated: true)
    }
}

extension HabitsViewController: HabitCollectionViewCellDelegate {
    func didTapCheckmark(at indexPath: IndexPath) {
        let habit = HabitsStore.shared.habits[indexPath.item]
        if habit.isAlreadyTakenToday {
            HabitsStore.shared.untrack(habit)
        } else {
            HabitsStore.shared.track(habit)
        }
        collectionView.reloadItems(at: [indexPath])
        updateProgress()
    }
}

extension Notification.Name {
    static let habitsDidChange = Notification.Name("habitsDidChange")
}
