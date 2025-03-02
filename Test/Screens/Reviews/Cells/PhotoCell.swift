//
//  PhotoCell.swift
//  Test
//
//  Created by Дмитрий Мартьянов on 01.03.2025.
//

import UIKit

final class PhotoCell: UICollectionViewCell {
    
    static var reuseId: String {
        String(describing: Self.self)
    }
    
    let photoImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(photoImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        photoImageView.frame = contentView.bounds
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
}
