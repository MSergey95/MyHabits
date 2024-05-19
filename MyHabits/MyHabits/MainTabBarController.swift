import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let habitsVC = UINavigationController(rootViewController: HabitsViewController())
        habitsVC.tabBarItem = UITabBarItem(title: "Привычки", image: UIImage(systemName: "list.bullet"), tag: 0)

        let infoVC = UINavigationController(rootViewController: InfoViewController())
        infoVC.tabBarItem = UITabBarItem(title: "Информация", image: UIImage(systemName: "info.circle"), tag: 1)

        viewControllers = [habitsVC, infoVC]

        tabBar.tintColor = UIColor(red: 161/255, green: 22/255, blue: 204/255, alpha: 1)
    }
}
