//
//  LoaderCell.swift
//  Test
//
//  Created by Дмитрий Мартьянов on 02.03.2025.
//

import UIKit

struct LoaderCellConfig {

    /// Идентификатор для переиспользования ячейки.
    static let reuseId = String(describing: LoaderCellConfig.self)

    /// Идентификатор конфигурации. Можно использовать для поиска конфигурации в массиве.
    let id = UUID()
    /// Кол-во отзывов.
    fileprivate let layout = LoaderCellLayout()
}

// MARK: - TableCellConfig

extension LoaderCellConfig: TableCellConfig {

    /// Метод обновления ячейки.
    /// Вызывается из `cellForRowAt:` у `dataSource` таблицы.
    func update(cell: UITableViewCell) {
        guard let cell = cell as? LoaderCell else { return }
        cell.config = self
    }

    /// Метод, возвращаюший высоту ячейки с данным ограничением по размеру.
    /// Вызывается из `heightForRowAt:` делегата таблицы.
    func height(with size: CGSize) -> CGFloat {
        layout.height(config: self, maxWidth: size.width)
    }
}

// MARK: - Cell
/// Ячейка, отображающая подгрузку отзывов.
final class LoaderCell: UITableViewCell {
    
    fileprivate var config: Config?
    
    fileprivate let activityView = CustomActivityView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(activityView)
        activityView.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let layout = config?.layout else { return }
        activityView.frame = layout.activityViewFrame
    }
    
}


// MARK: - Layout

private final class LoaderCellLayout {
    
    // MARK: - Фреймы
    fileprivate var activityViewFrame = CGRect.zero
    
    // MARK: - Отступы
    /// Отступы от краёв ячейки до её содержимого.
    private let insets = UIEdgeInsets(top: 9.0, left: 0, bottom: 9.0, right: 0)
    private let activityViewHeight = 9.0
    func height(config: Config, maxWidth: CGFloat) -> CGFloat {
        activityViewFrame = CGRect(
            origin: CGPoint(x: 0, y: insets.top),
            size: CGSize(width: maxWidth, height: activityViewHeight)
        )
        return activityViewFrame.maxY + insets.bottom
    }
}
// MARK: - Typealias

fileprivate typealias Config = LoaderCellConfig
fileprivate typealias Layout = LoaderCellLayout
