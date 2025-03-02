/// Модель, хранящая состояние вью модели.
struct ReviewsViewModelState {

    var items = [AnyTableCellConfig]()
    var limit = 5
    var offset = 0
    var shouldLoad = true
    var isRefreshing = false
}
