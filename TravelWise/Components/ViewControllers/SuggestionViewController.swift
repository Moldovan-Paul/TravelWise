import UIKit

protocol SuggestionViewControllerDelegate: AnyObject {
    func didSelect(model: SuggestionTableViewCellModel)
}

class SuggestionViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    weak var delegate: SuggestionViewControllerDelegate?

    var data: [SuggestionTableViewCellModel] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self!.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "SuggestionTableViewCell", bundle: nil), forCellReuseIdentifier: "SuggestionTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension SuggestionViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionTableViewCell", for: indexPath) as? SuggestionTableViewCell else {
            print("Could not load table cell.")
            return UITableViewCell()
        }
        let cellData = data[indexPath.row]
        cell.setupWithModel(model: cellData)
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(model: data[indexPath.row])
        dismiss(animated: true)
    }
}
