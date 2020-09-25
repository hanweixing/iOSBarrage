//
//  HamryBarrageItemView.swift
//  HamryBarrage
//
//  Created by 韩卫星 on 2020/9/25.
//  Copyright © 2020 Hamry. All rights reserved.
//

import UIKit

class HamryBarrageItemView: UIView  {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "text label"
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .heavy)
        label.textColor = UIColor.purple
        return label
    }()
    weak var delegate: HarmyBarrageCollectorProtocol?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }
    private func createUI() {
        self.backgroundColor = UIColor.orange
        self.titleLabel.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
        self.addSubview(self.titleLabel)
    }
}

extension HamryBarrageItemView: HamryBarrageItemProtocol {
    func barrageItemSize() -> CGSize {
        return CGSize(width: 80 + CGFloat(arc4random()%10), height: HamryBarrageCanvasViewController.barrageLineHeight)
    }
    func updateBarrageItemData(data: HarmryBarrageItemData) {
        self.titleLabel.text = data.title
    }
}
