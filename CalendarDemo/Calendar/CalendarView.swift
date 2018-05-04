//
//  CalendarView.swift
//  CalendarDemo
//
//  Created by 国投 on 2018/4/11.
//  Copyright © 2018年 FlyKite. All rights reserved.
//

import Foundation
import UIKit

class CalendarV:UIView {

    private weak var manager:CalendarManager!

    //private var calendarlabs:[CalendarItemBtn] = []

    var delegate:ZJCalendarDelegate!

    var dataSource:ZJCalendarDataSource!

    var weekType:WeekType = .FIRSTDAY_SUN

    private var monthdates:[Date] = []

    var SIZE:CGSize {
        get {
            return CGSize.init(width: self.frame.width/7, height: self.frame.height/7)
        }
    }

    //设置当前日期
    var currentDate:Date! {
        didSet {
            // TODO: 获取当前月份所有日期集合
            let dates = manager.getCurrentMonthAllDate(month: currentDate).sorted()
            // TODO: 获取当前月份的上个月所有日期集合
            let lastdates = manager.getLastAllMonthAllDate(month: currentDate).sorted()
            // TODO: 获取当前月份的下个月所有日期集合
            let nextdates = manager.getNextAllMonthAllDate(month: currentDate).sorted()
            // TODO: 获取当前月份的第一天是周几
           // let firstWeek = manager.getFirstDayWeekForMonth(currentDate)!

            // 1 日  2 一  3 二 4 三 5 四 6 五 7 六
            var firstWeek:Int! {
                get {
                    if weekType == .FIRSTDAY_SUN {
                        return manager.getFirstDayWeekForMonth(currentDate)!
                    }
                    return manager.getFirstDayWeekForMonth(currentDate)! - 1
                }
            }
            for index in 0..<42 {
                if index < firstWeek - 1 {
                    let date = lastdates[lastdates.count - 1 - (firstWeek - 2) + index]
                    monthdates.append(date)
                }else if index < manager.getCurrentMothForDays(currentDate) + firstWeek - 1{
                    let date = dates[index - firstWeek + 1]
                     monthdates.append(date)
                }else {
                    let date = nextdates[index - (manager.getCurrentMothForDays(currentDate) +  firstWeek - 1)]
                     monthdates.append(date)
                }
            }
            self.setNeedsDisplay()
//            calendarlabs.forEach {
//                let index = calendarlabs.index(of: $0)!
//                if index < firstWeek - 1 {
//                    let date = lastdates[lastdates.count - 1 - (firstWeek - 2) + index]
//                    $0.setDate(date)
//                }else if index < manager.getCurrentMothForDays(currentDate) + firstWeek - 1{
//                    let date = dates[index - firstWeek + 1]
//                    $0.setDate(date)
//                }else {
//                    let date = nextdates[index - (manager.getCurrentMothForDays(currentDate) + firstWeek - 1)]
//                    $0.setDate(date)
//
//                }
//            }
        }
    }

    //TODO: 遍历初始化 将manager传递进来
    convenience init(frame:CGRect,manager:CalendarManager) {
        self.init(frame: frame)
        self.manager = manager
        self.backgroundColor = UIColor.white
      //  initView()
    }

    override init(frame:CGRect) {
        super.init(frame: frame)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    private func initView() {
//        addWeekView()
//        addMonthView()
//
//    }
//
//    private func addWeekView() {
//        let WIDTH = self.frame.width/7
//        let HEIGHT = self.frame.height/7
//
//        var weekArr:[String]! {
//            get {
//                if weekType == .FIRSTDAY_SUN {
//                    return ["日","一","二","三","四","五","六"]
//                }
//                return ["一","二","三","四","五","六","日"]
//            }
//        }
//
//        for index in 0..<7 {
//            let lab = CalendarItemBtn.init(manager: manager)
//            lab.layer.borderWidth = 0.5
//            lab.layer.borderColor = UIColor.blue.cgColor
//            self.addSubview(lab)
//            lab.frame = CGRect.init(x: WIDTH * CGFloat(index % 7) , y: 0, width: WIDTH, height: HEIGHT)
//            lab.setTitle(weekArr[index], for: UIControlState.normal)
//
//        }
//    }
//
//    private func addMonthView() {
//        let WIDTH = self.frame.width/7
//        let HEIGHT = self.frame.height/7
//
//        for index in 0..<42 {
//            let btn = CalendarItemBtn.init(manager: manager)
//            btn.layer.borderWidth = 0.5
//            btn.layer.borderColor = UIColor.blue.cgColor
//            self.addSubview(btn)
//            btn.frame = CGRect.init(x: WIDTH * CGFloat(index % 7) , y:HEIGHT + HEIGHT * CGFloat(index / 7), width: WIDTH, height: HEIGHT)
//            calendarlabs.append(btn)
//        }
//    }
//
//    private func reloadView() {
//        calendarlabs.forEach {
//            $0.setTitleColor(delegate.defaultBgColorOf($0.date), for: .normal)
//            $0.backgroundColor = delegate.defaultBgColorOf($0.date)
//            $0.titleLabel?.font = delegate.defaultFontOf($0.date)
//
//        }
//
//    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

       // let context = UIGraphicsGetCurrentContext()
        let context = NSStringDrawingContext()
        for index in 0..<monthdates.count {
            let info = "\(manager.getDayOfMonth(date: monthdates[index]))"
            (info as NSString).draw(with: CGRect.init(x: SIZE.width * CGFloat(index % 7), y: SIZE.height + SIZE.height * CGFloat(index / 7), width: SIZE.width, height: SIZE.height), options: NSStringDrawingOptions.usesFontLeading, attributes: nil, context: context)

        }

        UIGraphicsEndImageContext()
    }

}


















































