import UIKit

protocol SortByPopUpTableViewControllerDelegate: AnyObject {
    func didSelect(option: String)
}

class SortByPopUpTableViewController: UITableViewController {

    var searchResultsViewControllerDelegate: SortByPopUpTableViewControllerDelegate?

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let cellText = cell?.textLabel?.text {
            searchResultsViewControllerDelegate?.didSelect(option: cellText)
        }
        dismiss(animated: true)
    }
}
