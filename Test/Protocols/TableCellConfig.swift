import UIKit

/// Протокол, который описывает требования для конфигурации ячейки таблицы,
/// для того чтобы хранить разные по типу конфигурации ячеек в одном массиве.
protocol TableCellConfig {

    /// Идентификатор для переиспользования ячейки (по умолчанию тип конфигурации).
    var reuseId: String { get }

    /// Метод для обновления текстов, изображений и другого содержимого ячейки.
    /// Вызывается из `cellForRowAt:` у `dataSource` таблицы.
    func update(cell: UITableViewCell)

    /// Метод возвращающий актуальную высоту ячейки.
    /// Вызывается из `heightForRowAt:` делегата таблицы.
    func height(with size: CGSize) -> CGFloat
    
    func isEqual(to item: TableCellConfig) -> Bool

    func hash(into hasher: inout Hasher)
}

// MARK: - Internal

extension TableCellConfig {

    static var reuseId: String {
        String(describing: Self.self)
    }

    var reuseId: String {
        Self.reuseId
    }

}

extension TableCellConfig where Self: Hashable {
    func isEqual(to item: TableCellConfig) -> Bool {
        guard let item = item as? Self else { return false }
        return self == item
    }
}

struct AnyTableCellConfig: TableCellConfig {
    
    var config: TableCellConfig
    
    func update(cell: UITableViewCell) {
        config.update(cell: cell)
    }
    
    func height(with size: CGSize) -> CGFloat {
        config.height(with: size)
    }
}
extension AnyTableCellConfig: Hashable {
    public static func == (lhs: AnyTableCellConfig, rhs: AnyTableCellConfig) -> Bool {
        return lhs.config.isEqual(to: rhs.config)
    }

    public func hash(into hasher: inout Hasher) {
        self.config.hash(into: &hasher)
    }
}
