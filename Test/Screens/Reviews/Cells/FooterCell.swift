//
//  FooterCell.swift
//  Test
//
//  Created by Дмитрий Мартьянов on 25.02.2025.
//

import UIKit

struct FooterCellConfig {

    /// Идентификатор для переиспользования ячейки.
    static let reuseId = String(describing: FooterCellConfig.self)

    /// Идентификатор конфигурации. Можно использовать для поиска конфигурации в массиве.
    let id = UUID()
    /// Кол-во отзывов.
    let reviewCount: Int
    /// Текст количества отзывов с учетом окончания слова.
    fileprivate var reviewCountText: NSAttributedString {
        return Self.pluralizeText(reviewCount)
            .attributed(font: .reviewCount, color: .reviewCount)
    }
    fileprivate let layout = FooterCellLayout()
}

// MARK: - TableCellConfig

extension FooterCellConfig: TableCellConfig {

    /// Метод обновления ячейки.
    /// Вызывается из `cellForRowAt:` у `dataSource` таблицы.
    func update(cell: UITableViewCell) {
        guard let cell = cell as? FooterCell else { return }
        cell.reviewCountLabel.attributedText = reviewCountText
        cell.config = self
    }

    /// Метод, возвращаюший высоту ячейки с данным ограничением по размеру.
    /// Вызывается из `heightForRowAt:` делегата таблицы.
    func height(with size: CGSize) -> CGFloat {
        layout.height(config: self, maxWidth: size.width)
    }
}
// MARK: - Private
private extension FooterCellConfig {
    static func pluralizeText(_ count: Int) -> String {
        let lastDigit = count % 10
        let lastTwoDigits = count % 100
        
        if lastTwoDigits >= 11 && lastTwoDigits <= 14 {
            return "\(count) отзывов"
        }
        
        switch lastDigit {
        case 1:
            return "\(count) отзыв"
        case 2...4:
            return "\(count) отзыва"
        default:
            return "\(count) отзывов"
        }
    }
}
// MARK: - Cell
/// Ячейка, отображающая количество отзывов в конце списка.
final class FooterCell: UITableViewCell {
    
    fileprivate var config: Config?
    
    fileprivate let reviewCountLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let layout = config?.layout else { return }
        reviewCountLabel.frame = layout.reviewCountLabelFrame
    }
    
}

// MARK: - Private
private extension FooterCell {
    
    func setupCell() {
        contentView.addSubview(reviewCountLabel)
        reviewCountLabel.textAlignment = .center
    }
    
}

// MARK: - Layout
private final class FooterCellLayout {
    
    // MARK: - Фреймы
    fileprivate var reviewCountLabelFrame = CGRect.zero
    
    // MARK: - Отступы
    /// Отступы от краёв ячейки до её содержимого.
    private let insets = UIEdgeInsets(top: 9.0, left: 0, bottom: 9.0, right: 0)
    
    func height(config: Config, maxWidth: CGFloat) -> CGFloat {
        reviewCountLabelFrame = CGRect(
            origin: CGPoint(x: 0, y: insets.top),
            size: CGSize(width: maxWidth, height: config.reviewCountText.size().height)
        )
        return reviewCountLabelFrame.maxY + insets.bottom
    }
}
// MARK: - Typealias
fileprivate typealias Config = FooterCellConfig
fileprivate typealias Layout = FooterCellLayout
