//
//  HamryBarrageRule.swift
//  HamryBarrage
//
//  Created by 韩卫星 on 2020/9/25.
//  Copyright © 2020 Hamry. All rights reserved.
//

import Foundation
import UIKit

protocol HamryBarrageItemProtocol {
    func updateBarrageItemData(data: Any?)
    func barrageItemSize() -> CGSize
}

protocol HarmyBarrageCollectorProtocol: class {
    func collectBarrageView(view: UIView&HamryBarrageItemProtocol)
    func judgeBarrageIsOutOfCanvas(barrageFrame: CGRect) -> Bool
    func emitAnBarrageItemData() -> Any?
}
