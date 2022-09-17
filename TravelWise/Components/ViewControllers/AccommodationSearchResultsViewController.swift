import Foundation
import UIKit

final class AccommodationSearchResultsViewController: UIViewController {

    @IBOutlet private weak var accommodationSearchFilterView: CommonSearchFilterView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var noResultsStackView: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var accommodationFilterModel: AccommodationFilterEntity!
    private var accommodationService = AccommodationService()
    private var accommodationsRequestParameters = AccommodationsRequestParameters(destinationId: "", pageNumber: 1, checkIn: "", checkOut: "", minStarRating: "", adultCount: "",
                                                                                  sortOrder: "BEST_SELLER")
    private var didFindData = false
    private let formatter = DateFormatter()
    private let filterViewDateFormat = "dd MMM YYYY"
    private let requestDateFormat = "yyyy-MM-dd"
    var locationId: String = ""

    // Mock data
    private var data: [AccommodationEntity] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {
                    print("Could not access instance of AccommodationSearchResultsViewController")
                    return
                }
                strongSelf.activityIndicator.stopAnimating()
                strongSelf.tableView.tableFooterView = nil
                if oldValue.count < strongSelf.data.count {
                    strongSelf.didFindData = true
                    let indexRangeToReload = (oldValue.count..<strongSelf.data.count).map { IndexPath(row: $0, section: 0) }
                    strongSelf.tableView.insertRows(at: indexRangeToReload, with: .none)
                    strongSelf.tableView.reloadRows(at: indexRangeToReload, with: .none)
                }
                if strongSelf.data.count == 0 {
                    if !strongSelf.didFindData {
                        strongSelf.noResultsStackView.isHidden = false
                        strongSelf.tableView.isHidden = true
                    } else {
                        strongSelf.activityIndicator.startAnimating()
                        strongSelf.tableView.reloadData()
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setup()
    }

    private func setupUI() {
        activityIndicator.startAnimating()
        setupAccommodationFilterView()
        fillFilterData(data: accommodationFilterModel)
        tableView.register(UINib(nibName: "AccommodationTableViewCell", bundle: nil), forCellReuseIdentifier: "AccommodationTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func setup() {
        ImageCache.sharedImageCache.clearImageCache()
        accommodationService.firstRequestWasMade = false
        accommodationService.noMoreData = false
        getHotelData(data: accommodationsRequestParameters)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
              let identifierCase = AccommodationsSegueIdentifiers(rawValue: identifier) else {
            print("Could not map segue identifier to a segue case")
            return
        }
        switch identifierCase {
        case .sortBySegue:
            guard let popoverViewController = segue.destination as? SortByPopUpTableViewController else {
                print("PopoverViewController is not of type TableViewController")
                return
            }
            popoverViewController.modalPresentationStyle = .popover
            popoverViewController.searchResultsViewControllerDelegate = self
            guard let popoverPresentationController = popoverViewController.popoverPresentationController else {
                return
            }
            popoverPresentationController.delegate = self
        default:
            return
        }
    }

    @IBAction func performSortBySegue(_ sender: Any) {
        performSegue(withIdentifier: "sortBySegue", sender: self)
    }

    func fillFilterData(data: AccommodationFilterEntity) {
        // Filter view data
        accommodationSearchFilterView.firstLocation = data.location
        accommodationSearchFilterView.setStarRating(stars: data.minStarRating)
        formatter.dateFormat = filterViewDateFormat
        accommodationSearchFilterView.firstDate = formatter.string(from: data.checkInDate).uppercased()
        accommodationSearchFilterView.secondDate = formatter.string(from: data.checkOutDate).uppercased()
        accommodationSearchFilterView.adultCount = data.adultCount
        // Request parameters
        accommodationsRequestParameters.destinationId = locationId
        formatter.dateFormat = requestDateFormat
        accommodationsRequestParameters.checkIn = formatter.string(from: data.checkInDate)
        accommodationsRequestParameters.checkOut = formatter.string(from: data.checkOutDate)
        accommodationsRequestParameters.minStarRating = accommodationsRequestParameters.createStarCountString(stars: data.minStarRating)
        accommodationsRequestParameters.adultCount = String(data.adultCount)
    }

    func getHotelData(data: AccommodationsRequestParameters) {
        accommodationService.searchLocation(data: data) { [weak self] result in
            guard let strongSelf = self else {
                print("Cannot access instance of AccommodationSearchResultsViewController class.")
                return
            }
            switch result {
            case let .success(locations):
                strongSelf.data.append(contentsOf: locations)
            case let .failure(error):
                print(error)
            }
        }
    }

    func setLocationId(locationId: String) {
        self.locationId = locationId
    }

    private func setupAccommodationFilterView() {
        accommodationSearchFilterView.setScreenType(type: .accommodationsType)
        accommodationSearchFilterView.firstLocationType = .accommodationsType
        accommodationSearchFilterView.firstDateType = .accommodationsType
        accommodationSearchFilterView.secondDateType = .accommodationsType
        accommodationSearchFilterView.adultBgColor = UIColor(named: "greenColor")
    }

    private func createFooterSpinner() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
 }

 extension AccommodationSearchResultsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AccommodationTableViewCell", for: indexPath) as? AccommodationTableViewCell else {
                print("Could not load table cell.")
                return UITableViewCell()
        }
        let accommodation = data[indexPath.row]
        cell.setupWithAccommodation(accommodation: accommodation)
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.count != 0 {
            self.noResultsStackView.isHidden = true
            self.tableView.isHidden = false
        }
        return data.count
    }
 }

extension AccommodationSearchResultsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if accommodationService.noMoreData == false {
            let position = scrollView.contentOffset.y
            if position > self.tableView.contentSize.height-100-scrollView.frame.size.height {
                guard !accommodationService.isPaginating else {
                    return
                }
                tableView.tableFooterView = createFooterSpinner()
                accommodationsRequestParameters.pageNumber += 1
                getHotelData(data: self.accommodationsRequestParameters)
            }
        }
    }
}

extension AccommodationSearchResultsViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension AccommodationSearchResultsViewController: SortByPopUpTableViewControllerDelegate {
    func didSelect(option: String) {
        accommodationsRequestParameters.sortOrder = HelperClass.getOrder(option)
        accommodationService.firstRequestWasMade = false
        accommodationService.noMoreData = false
        data = []
        getHotelData(data: accommodationsRequestParameters)
    }
}
