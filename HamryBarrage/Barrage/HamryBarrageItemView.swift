//
//  HamryBarrageItemView.swift
//  HamryBarrage
//
//  Created by 韩卫星 on 2020/9/25.
//  Copyright © 2020 Hamry. All rights reserved.
//

import UIKit

struct HamryBarrageItemData {
    var icon: String = ""
    var content: String = ""
}

class HamryBarrageItemView: UIView {
    private var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        return imageView
    }()
    private var desLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()
    private var barrageItemData: HamryBarrageItemData?
    weak var delegate: HarmyBarrageCollectorProtocol?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadSubviews()
    }
    private func loadSubviews() {
        self.backgroundColor = .orange
        self.clipsToBounds = true
        self.layer.cornerRadius = 50/2.0
        
        self.iconImageView.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
        self.addSubview(self.iconImageView)
        
        self.desLabel.frame = CGRect(x: 50, y: (50 - 21)/2, width: UIScreen.main.bounds.width, height: 21)
        self.addSubview(self.desLabel)
    }
    
    static func calculateBarrageViewSize(itemData: HamryBarrageItemData) -> CGSize {
        let height: CGFloat = 50
        var width: CGFloat = 10 + 30 + 10
        let textWidth = NSAttributedString(string: itemData.content, attributes: [.font: UIFont.systemFont(ofSize: 14.0)]).boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size.width
        width = width + textWidth + 10
        return CGSize(width: width, height: height)
    }
}

extension HamryBarrageItemView: HamryBarrageItemProtocol {
    func barrageItemSize() -> CGSize {
        if let _commentData = self.barrageItemData {
            let size = HamryBarrageItemView.calculateBarrageViewSize(itemData: _commentData)
            return size
        } else {
            return CGSize.zero
        }
    }
    func updateBarrageItemData(data: Any?) {
        guard let itemData = data as? HamryBarrageItemData else { return }
        self.barrageItemData = itemData
        DispatchQueue.global().async {
            if let imgData = try? Data.init(contentsOf: URL.init(string: itemData.icon)!) {
                let image = UIImage.init(data: imgData)
                DispatchQueue.main.async {
                    self.iconImageView.image = image
                }
            }
        }
        self.desLabel.text = itemData.content
    }
}
