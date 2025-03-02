import UIKit

final class ReviewsViewController: UIViewController {

    private lazy var reviewsView = makeReviewsView()
    private let viewModel: ReviewsViewModel
    private var dataSource: DataSource?
    
    init(viewModel: ReviewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = reviewsView
        title = "Отзывы"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        viewModel.getReviews()
    }

}

// MARK: - Private

private extension ReviewsViewController {

    func makeReviewsView() -> ReviewsView {
        let reviewsView = ReviewsView()
        dataSource = DataSource(tableView: reviewsView.tableView, cellProvider: viewModel.dataSourceCellProvider)
        reviewsView.tableView.delegate = viewModel
        reviewsView.tableView.dataSource = dataSource
        reviewsView.tableView.prefetchDataSource = viewModel
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(resetData), for: .valueChanged)
        reviewsView.tableView.refreshControl = refreshControl
        return reviewsView
    }

    func setupViewModel() {
        viewModel.onStateChange = { [weak reviewsView, weak self] state in
            guard let view = reviewsView else { return }
            self?.update(state.items)
            view.tableView.setContentOffset(view.tableView.contentOffset, animated: false)
            reviewsView?.tableView.refreshControl?.endRefreshing()
        }
    }
    
    func update(_ items: [AnyTableCellConfig]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(items)
        dataSource?.apply(snapshot)
        
    }
    
    @objc func resetData(_ sender: Any) {
        viewModel.resetReviews()
    }

}
// MARK: - Type Aliases
typealias DataSource = UITableViewDiffableDataSource<Int, AnyTableCellConfig>
typealias Snapshot = NSDiffableDataSourceSnapshot<Int, AnyTableCellConfig>
