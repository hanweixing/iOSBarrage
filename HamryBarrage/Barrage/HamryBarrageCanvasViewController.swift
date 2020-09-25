//
//  HamryBarrageCanvasViewController.swift
//  HamryBarrage
//
//  Created by 韩卫星 on 2020/9/25.
//  Copyright © 2020 Hamry. All rights reserved.
//

import UIKit

/// 弹幕的画布.
class HamryBarrageCanvasViewController: UIViewController {
    static let barrageLineHeight: CGFloat = 50
    static let barrageLineGapSpacing: CGFloat = 10
    static let barrageLineInterSpacing: CGFloat = 60
    private var reuseBarrageViewArr: [UIView&HamryBarrageItemProtocol] = []
    private var barrageTimer: CADisplayLink?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.startDisplayBarrage()
    }
    public func startDisplayBarrage() {
        self.barrageTimer?.invalidate()
        self.barrageTimer = nil
        self.barrageTimer = CADisplayLink(target: self, selector: #selector(startBarrageTimer))
        self.barrageTimer?.preferredFramesPerSecond = 30
        self.barrageTimer?.add(to: RunLoop.main, forMode: .default)
        self.barrageTimer?.add(to: RunLoop.main, forMode: .tracking)
    }
    @objc func startBarrageTimer() {
        DispatchQueue.main.async {
            // 让所有的已有弹幕向前进.
                    let allBarrageInScreen = self.view.subviews.filter({ $0 is UIView&HamryBarrageItemProtocol })
            print("+++++++++========")
            print(self.reuseBarrageViewArr.count)
                    for barrage in allBarrageInScreen {
                        let newRect = CGRect(x: barrage.frame.minX - 1, y: barrage.frame.minY, width: barrage.bounds.width, height: barrage.bounds.height)
            //            UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
                            barrage.frame = newRect
            //            }, completion: { [weak self] finished in
                            if self.judgeBarrageIsOutOfCanvas(barrageFrame: newRect) == true {
                                barrage.removeFromSuperview()
                                self.collectBarrageView(view: barrage as! (UIView&HamryBarrageItemProtocol))
                            }
            //            })
                    }
                    // 新增要添加的弹幕.
                    let needGiveNewBarragePtArr = self.findAllNeedGiveNewBarragePtArr()
                    for iterator in 0..<needGiveNewBarragePtArr.count {
                        let barragePt = needGiveNewBarragePtArr[iterator]
                        let itemData = HarmryBarrageItemData.init(title: "++\(iterator)随机序号的弹幕")
                        let barrageView = self.createBarrage(itemData: itemData)
                        let barrageFrame = CGRect.init(origin: barragePt, size: barrageView.barrageItemSize())
                        barrageView.frame = barrageFrame
                        if let itemView = barrageView as? HamryBarrageItemView {
                            itemView.delegate = self
                        }
                        barrageView.sizeToFit()
                        self.view.addSubview(barrageView)
                    }
        }
    }
}

extension HamryBarrageCanvasViewController {
    
    /// 找出所有需要补上新弹幕的Pt.
    private func findAllNeedGiveNewBarragePtArr() -> [CGPoint] {
        let allSubFrameArr = self.view.subviews.filter({ $0 is HamryBarrageItemProtocol }).compactMap({ $0.frame })
        var eachLineLastViewFrameArr: [CGRect] = []
        for rect in allSubFrameArr {
            if let lastViewInTheSameLine = allSubFrameArr.filter({ $0.minY == rect.minY }).last {
                eachLineLastViewFrameArr.append(lastViewInTheSameLine)
            }
        }
        // 判断每一条轨道最后一个弹幕之后是否需要补上一个新的弹幕.
        var needGiveBarrage: [CGPoint] = []
        for rect in eachLineLastViewFrameArr {
            if self.view.bounds.width - rect.maxX >= HamryBarrageCanvasViewController.barrageLineInterSpacing {
                needGiveBarrage.append(CGPoint(x: rect.maxX + HamryBarrageCanvasViewController.barrageLineInterSpacing, y: rect.minY))
            }
        }
        // 找到离底部最近的那条弹幕的frame.以此来判断是否从最后的这个rect到底部需要新增轨道.
        var maxYViewFrame: CGRect = .zero
        for rect in eachLineLastViewFrameArr {
            if rect.minY > maxYViewFrame.minY {
                maxYViewFrame = rect
            }
        }
        let needAddNewLineCount: Int = Int((self.view.frame.height - maxYViewFrame.maxY) / (HamryBarrageCanvasViewController.barrageLineHeight + HamryBarrageCanvasViewController.barrageLineGapSpacing))
        var upPt = maxYViewFrame.origin
        for _ in 0..<needAddNewLineCount {
            let nextPt = CGPoint(x: self.view.bounds.width, y: upPt.y + HamryBarrageCanvasViewController.barrageLineHeight + HamryBarrageCanvasViewController.barrageLineGapSpacing)
            needGiveBarrage.append(nextPt)
            upPt = nextPt
        }
        return needGiveBarrage
    }
    private func createBarrage(itemData: HarmryBarrageItemData) -> UIView&HamryBarrageItemProtocol {
        var barrageView: UIView&HamryBarrageItemProtocol
        if let view = self.reuseBarrageViewArr.popLast() {
            barrageView = view
        } else {
            barrageView = HamryBarrageItemView()
            barrageView.updateBarrageItemData(data: itemData)
        }
        return barrageView
    }
}

extension HamryBarrageCanvasViewController: HarmyBarrageCollectorProtocol {
    func collectBarrageView(view: UIView & HamryBarrageItemProtocol) {
        self.reuseBarrageViewArr.append(view)
    }
    func judgeBarrageIsOutOfCanvas(barrageFrame: CGRect) -> Bool {
        if barrageFrame.maxX < 0 {
            return true
        }
        return false
    }
}
