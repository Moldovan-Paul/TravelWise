import UIKit

class FlightResultsViewController: UIViewController {
    @IBOutlet private weak var searchParametersView: CommonSearchFilterView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noResultsStackView: UIStackView!

    private var flightService = FlightService()
    private var endOfResults = false
    private var didFoundResults = false

        var searchParameters: FlightsSearchParams?

        private var data: [FlightEntity] = [] {
            didSet {
                tableView.tableFooterView = nil
                self.tableView.reloadData()
                if oldValue.count < data.count {
                    didFoundResults = true
                }
                if didFoundResults == false && data.count == 0 {
                    DispatchQueue.main.async { [weak self] in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.noResultsStackView.isHidden = false
                       _ = [strongSelf.tableView, strongSelf.activityIndicator].map { $0.isHidden = true }
                    }

                }
            }
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            setupSearchParametersView()

            ImageCache.sharedImageCache.clearImageCache()
            tableView.isHidden = true
            noResultsStackView.isHidden = true

            tableView.register(UINib(nibName: "FlightTableViewCell", bundle: nil), forCellReuseIdentifier: "FlightTableViewCell")
            tableView.dataSource = self
            tableView.delegate = self

            loadFlights()

        }

        private func setupSearchParametersView() {
            guard let searchParameters = searchParameters else {
                print("Search parameters not found in FlightResultsViewController")
                return
            }
            searchParametersView.setUpViewFor(type: .flightsType)

            searchParametersView.firstLocation = searchParameters.departureAirportName
            searchParametersView.flightDestinationLocation = searchParameters.arrivalAirportName

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            let departureDate = dateFormatter.string(from: searchParameters.departureDate).uppercased()

            if let returnDepartureDate =  searchParameters.returnDepartureDate {
                searchParametersView.secondDate = dateFormatter.string(from: returnDepartureDate).uppercased()
            } else {
                searchParametersView.isSecondDateHidden = true
            }

            searchParametersView.firstDate = departureDate
            searchParametersView.adultCount = searchParameters.numberOfPassengers
        }

        private func presentTableView() {
            self.activityIndicator.stopAnimating()
            self.tableView.isHidden = false
        }

        private func loadFlights() {
            guard let searchParameters = searchParameters else {
                print("searchParameters are nil in FlightResultsViewController")
                return
            }

            flightService.searchFlights(searchParameters: searchParameters) { [weak self] result in
                guard let strongSelf = self else {
                    print("Self is nil when loading flights")
                    return
                }
                switch result {
                case .success(let results):

                    if strongSelf.flightService.currentPage > 1 && results.count == 0 {
                        strongSelf.endOfResults = true
                    }
                    DispatchQueue.main.async { [weak self] in
                        self?.data.append(contentsOf: results)
                        self?.presentTableView()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

    extension FlightResultsViewController: UITableViewDataSource, UITableViewDelegate {
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FlightTableViewCell", for: indexPath) as? FlightTableViewCell, indexPath.row < data.count else {
                print("Could not load table cell.")
                return UITableViewCell()
            }
            let flight = data[indexPath.row]
            cell.setupWith(flightEntity: flight)
            return cell
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return data.count
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

    extension FlightResultsViewController: UIScrollViewDelegate {
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let scrollPosition = scrollView.contentOffset.y
            if scrollPosition < (tableView.contentSize.height-100-scrollView.frame.size.height) || flightService.isPaginating == true {
                return
            }

            guard endOfResults == false else {
                return
            }

            tableView.tableFooterView = createFooterSpinner()

            loadFlights()
        }

    }
