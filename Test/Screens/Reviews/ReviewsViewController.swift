import UIKit

final class ReviewsViewController: UIViewController {

    private lazy var reviewsView = makeReviewsView()
    private let viewModel: ReviewsViewModel
    
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
        reviewsView.tableView.delegate = viewModel
        reviewsView.tableView.dataSource = viewModel
        reviewsView.tableView.prefetchDataSource = viewModel
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .clear
        refreshControl.addTarget(self, action: #selector(resetData), for: .valueChanged)
        reviewsView.tableView.refreshControl = refreshControl
        return reviewsView
    }

    func setupViewModel() {
        viewModel.onStateChange = { [weak reviewsView] state in
            guard let view = reviewsView else { return }
            if let refreshing = view.tableView.refreshControl?.isRefreshing, refreshing {
                reviewsView?.tableView.refreshControl?.endRefreshing()
            }
            reviewsView?.tableView.reloadData()
        }
    }
    
    @objc func resetData(_ sender: Any) {
        viewModel.resetReviews()
    }

}

