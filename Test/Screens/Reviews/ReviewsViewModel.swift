import UIKit

/// Класс, описывающий бизнес-логику экрана отзывов.
final class ReviewsViewModel: NSObject {
    
    /// Замыкание, вызываемое при изменении `state`.
    var onStateChange: ((State) -> Void)?
    
    var dataSourceCellProvider: DataSource.CellProvider = { tableView, indexPath, itemIdentifier in
        let config = itemIdentifier.config
        let cell = tableView.dequeueReusableCell(withIdentifier: config.reuseId, for: indexPath)
        config.update(cell: cell)
        return cell
    }
    
    private var state: State
    private let reviewsProvider: ReviewsProvider
    private let ratingRenderer: RatingRenderer
    private let imageLoader: ImageLoader
    private let decoder: JSONDecoder
    
    init(
        state: State = State(),
        reviewsProvider: ReviewsProvider = ReviewsProvider(),
        ratingRenderer: RatingRenderer = RatingRenderer(),
        imageLoader: ImageLoader = ImageLoader(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.state = state
        self.reviewsProvider = reviewsProvider
        self.ratingRenderer = ratingRenderer
        self.imageLoader = imageLoader
        self.decoder = decoder
    }
    
}

// MARK: - Internal

extension ReviewsViewModel {
    
    typealias State = ReviewsViewModelState
    
    /// Метод получения отзывов.
    func getReviews() {
        guard state.shouldLoad else { return }
        state.shouldLoad = false
        state.items.append(makeLoaderItem())
        onStateChange?(state)
        
        reviewsProvider.getReviews(offset: state.offset, completion: { [weak self] in
            self?.state.items.removeLast()
            self?.gotReviews($0)
        })
        
    }
    
    func resetReviews() {
        state.items.removeAll()
        state.offset = 0
        state.shouldLoad = true
        getReviews()
    }
}

// MARK: - Private

private extension ReviewsViewModel {
    
    /// Метод обработки получения отзывов.
    func gotReviews(_ result: ReviewsProvider.GetReviewsResult) {
        do {
            let data = try result.get()
            let reviews = try decoder.decode(Reviews.self, from: data)
            state.items += reviews.items.map(makeReviewItem)
            state.offset += state.limit
            state.shouldLoad = state.offset < reviews.count
            if !state.shouldLoad {
                state.items.append(makeFooterItem(reviews.count))
            } else {
                
            }
        } catch {
            state.shouldLoad = true
        }
        onStateChange?(state)
    }
    
    /// Метод, вызываемый при нажатии на кнопку "Показать полностью...".
    /// Снимает ограничение на количество строк текста отзыва (раскрывает текст).
    func showMoreReview(with id: UUID) {
        guard
            let index = state.items.firstIndex(where: { ($0.config as? ReviewItem)?.id == id }),
            var item = state.items[index].config as? ReviewItem
        else { return }
        item.maxLines = .zero
        state.items[index] = AnyTableCellConfig(config: item)
        onStateChange?(state)
    }
    
}

// MARK: - Items

private extension ReviewsViewModel {
    
    typealias ReviewItem = ReviewCellConfig
    typealias FooterItem = FooterCellConfig
    typealias LoaderItem = LoaderCellConfig
    
    func makeReviewItem(_ review: Review) -> AnyTableCellConfig {
        let usernameText = "\(review.firstName) \(review.lastName)".attributed(font: .username)
        let reviewText = review.text.attributed(font: .text)
        let created = review.created.attributed(font: .created, color: .created)
        let item = ReviewItem(
            imageLoader: imageLoader,
            avatarUrl: review.avatarUrl,
            usernameText: usernameText,
            ratingImage: ratingRenderer.ratingImage(review.rating),
            photoUrls: review.photos,
            reviewText: reviewText,
            created: created,
            onTapShowMore: { [weak self] in
                self?.showMoreReview(with: $0)
            }
        )
        return AnyTableCellConfig(config: item)
    }
    
    func makeFooterItem(_ count: Int) -> AnyTableCellConfig {
        AnyTableCellConfig(config: FooterItem(reviewCount: count))
    }
    
    func makeLoaderItem() -> AnyTableCellConfig {
        AnyTableCellConfig(config: LoaderItem())
    }
}

// MARK: - UITableViewDataSourcePrefetching
extension ReviewsViewModel: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let config = state.items[indexPath.row].config as? ReviewCellConfig {
                imageLoader.load(by: config.avatarUrl, completion: nil)
                for photoUrl in config.photoUrls {
                    imageLoader.load(by: photoUrl, completion: nil)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let config = state.items[indexPath.row].config as? ReviewCellConfig {
                imageLoader.cancelLoad(by: config.avatarUrl)
                for photoUrl in config.photoUrls {
                    imageLoader.cancelLoad(by: photoUrl)
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension ReviewsViewModel: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        state.items[indexPath.row].height(with: tableView.bounds.size)
    }
    
    /// Метод дозапрашивает отзывы, если до конца списка отзывов осталось два с половиной экрана по высоте.
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        if shouldLoadNextPage(scrollView: scrollView, targetOffsetY: targetContentOffset.pointee.y) {
            getReviews()
        }
    }
    
    private func shouldLoadNextPage(
        scrollView: UIScrollView,
        targetOffsetY: CGFloat,
        screensToLoadNextPage: Double = 2.5
    ) -> Bool {
        let viewHeight = scrollView.bounds.height
        let contentHeight = scrollView.contentSize.height
        let triggerDistance = viewHeight * screensToLoadNextPage
        let remainingDistance = contentHeight - viewHeight - targetOffsetY
        return remainingDistance <= triggerDistance
    }
    
}

