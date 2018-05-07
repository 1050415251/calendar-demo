//
//  CalendarView.swift
//  CalendarDemo
//
//  Created by 国投 on 2018/4/11.
//  Copyright © 2018年 FlyKite. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore


class ZJCalendarView:UIView {

    internal enum ScrollDireCation {
        case LEFT,RIGHT,TOP,BOTTOM
    }
    //TOUCH 事件
    fileprivate var beginTouchPoint:CGPoint!
    fileprivate var moveTouchPoint:CGPoint!
    fileprivate var endTouchPoint:CGPoint!
    private var monthdates:[Date] = []
    private var lastmonthdates:[Date] = []
    private var nextmonthdates:[Date] = []
    // 手指滑动的距离
    private var scrollDistance:CGFloat = 0
    //TODO: 记录手指离开时的 滑动距离用来执行动画
    private var touchesEndDistance:CGFloat = 0
    /// 执行动画次数 1s 执行60次 用该次数绘制松开手指的动画
    private var animationRunCount:Int = 0
    /// 滑动方向 只读不支持手动设置
    fileprivate(set) var scrolldirection:ScrollDireCation!
    fileprivate var timer:CADisplayLink!
    /// 单个item显示的宽高
    private var SIZE:CGSize {
        get {
            return CGSize.init(width: self.frame.width/7, height: (self.frame.height - delegate.weekHeight())/6)
        }
    }
    //设置当前日期
    var currentDate:Date! {
        didSet {
            currentPage = manager.getMonthfromDate(currentDate)
            monthdates = getCurrentDates(currentDate)
            lastmonthdates = getCurrentDates(manager.getselectMonthDate(date: currentPage, year: 0, month: -1))
            nextmonthdates = getCurrentDates(manager.getselectMonthDate(date: currentPage, year: 0, month: 1))
            self.setNeedsDisplay()
        }
    }
    //TODO: 选中的日期
    var selectedDates:[Date] = []

    //MANAGER
    private lazy var manager:CalendarManager = CalendarManager()
    var delegate:ZJCalendarDelegate! {
        didSet {
            self.setNeedsDisplay()
        }
    }
    var dataSource:ZJCalendarDataSource!
    /// 滑动方向 横向滑动跟总想滑动
    var scrolldirecation:UICollectionViewScrollDirection = .horizontal
    var weekType:WeekType! {
        get {
            return delegate.weekType()
        }
    }
    /// 支持kvo监听
    @objc dynamic var currentPage:Date!



    override init(frame: CGRect) {
        super.init(frame: frame)
        initDisplayLink()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        timer.invalidate()
        timer = nil
    }

}


//MARK: 绘制动画
extension ZJCalendarView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if delegate == nil {
            return
        }
        drawMonth()
        drawWeek()
        UIGraphicsPopContext()
    }


    /// 绘制月份
    func drawMonth() {
        let currentcontext = UIGraphicsGetCurrentContext()
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        var attritustyle = [NSAttributedStringKey: Any]()
        attritustyle[NSAttributedStringKey.paragraphStyle] = style
        //TODO: 绘制上月
        for index in 0..<lastmonthdates.count {
            let info = "\(manager.getDayOfMonth(date: lastmonthdates[index]))"
            if manager.theSameMonthDate(manager.getselectMonthDate(date: currentPage, year: 0, month: -1), date2: lastmonthdates[index]) {
                attritustyle[NSAttributedStringKey.foregroundColor] = delegate.defaultTextColorOf(lastmonthdates[index])
            }else {
                attritustyle[NSAttributedStringKey.foregroundColor] = delegate.elsemonthTextColorOf(lastmonthdates[index])
            }
            attritustyle[NSAttributedStringKey.font] = delegate.defaultFontOf(lastmonthdates[index])
            let infosize = (info as NSString).size(withAttributes: attritustyle)
            if scrolldirecation == .horizontal {
                (info as NSString).draw(in: CGRect.init(x: SIZE.width * CGFloat(index % 7) + scrollDistance - self.frame.width, y:  delegate.weekHeight() + SIZE.height * CGFloat(index / 7) + (SIZE.height - infosize.height) * 0.5, width: SIZE.width, height: SIZE.height), withAttributes: attritustyle)
            }
        }

        //TODO: 绘制当月
        for index in 0..<monthdates.count {
            let info = "\(manager.getDayOfMonth(date: monthdates[index]))"
            if manager.theSameMonthDate(currentPage, date2: monthdates[index]) {
                attritustyle[NSAttributedStringKey.foregroundColor] = delegate.defaultTextColorOf(monthdates[index])
            }else {
                attritustyle[NSAttributedStringKey.foregroundColor] = delegate.elsemonthTextColorOf(monthdates[index])
            }
            attritustyle[NSAttributedStringKey.font] = delegate.defaultFontOf(monthdates[index])
            selectedDates.forEach {
                if $0 == monthdates[index] {
                    attritustyle[NSAttributedStringKey.foregroundColor] = delegate.selectionTextColorOf($0)
                    attritustyle[NSAttributedStringKey.font] = delegate.selectionFontOf(monthdates[index])
                    currentcontext?.setAllowsAntialiasing(true)
                    currentcontext?.setFillColor(delegate.selectionBgColorOf($0).cgColor)
                   // currentcontext?.setStrokeColor(delegate.selectionBgColorOf($0).cgColor)
                    let radius:CGFloat = 14
                    currentcontext?.addArc(center: CGPoint.init(x: SIZE.width * CGFloat(index % 7) + scrollDistance + SIZE.width * 0.5, y: delegate.weekHeight() + SIZE.height * CGFloat(index / 7) + SIZE.height * 0.5), radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
                    //currentcontext?.strokePath()
                    currentcontext?.fillPath()

                    let pathRect = UIBezierPath.init(arcCenter: CGPoint.init(x: SIZE.width * CGFloat(index % 7) + scrollDistance + SIZE.width * 0.5, y: delegate.weekHeight() + SIZE.height * CGFloat(index / 7) + SIZE.height * 0.5), radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
                    let shadowOffset = CGSize.init(width: 0, height: 0)
                    currentcontext?.saveGState()
                    currentcontext?.setShadow(offset: shadowOffset, blur: 8.0, color: delegate.selectionBgColorOf($0).cgColor)
                    pathRect.fill()
                    currentcontext?.restoreGState()
                }
            }
            let infosize = (info as NSString).size(withAttributes: attritustyle)

            if scrolldirecation == .horizontal {
                (info as NSString).draw(in: CGRect.init(x: SIZE.width * CGFloat(index % 7) + scrollDistance, y:  delegate.weekHeight() + SIZE.height * CGFloat(index / 7) + (SIZE.height - infosize.height) * 0.5, width: SIZE.width, height: SIZE.height), withAttributes: attritustyle)
            }
        }

        //TODO: 绘制下月
        for index in 0..<nextmonthdates.count {
            let info = "\(manager.getDayOfMonth(date: nextmonthdates[index]))"
            if manager.theSameMonthDate(manager.getselectMonthDate(date: currentPage, year: 0, month: 1), date2: nextmonthdates[index]) {
                attritustyle[NSAttributedStringKey.foregroundColor] = delegate.defaultTextColorOf(nextmonthdates[index])
            }else {
                attritustyle[NSAttributedStringKey.foregroundColor] = delegate.elsemonthTextColorOf(nextmonthdates[index])
            }
            attritustyle[NSAttributedStringKey.font] = delegate.defaultFontOf(nextmonthdates[index])
            let infosize = (info as NSString).size(withAttributes: attritustyle)
            if scrolldirecation == .horizontal {
                (info as NSString).draw(in: CGRect.init(x: SIZE.width * CGFloat(index % 7) + scrollDistance + self.frame.width, y:  delegate.weekHeight() + SIZE.height * CGFloat(index / 7) + (SIZE.height - infosize.height) * 0.5, width: SIZE.width, height: SIZE.height), withAttributes: attritustyle)
            }
        }
       // UIGraphicsPopContext()
    }

    /// 绘制 周末
    func drawWeek() {
        let currentcontext = UIGraphicsGetCurrentContext()

        currentcontext?.setAllowsAntialiasing(true)
        currentcontext?.setStrokeColor(delegate.weekBgColor().cgColor)
        // currentcontext?.setFillColor(delegate.weekBgColor().cgColor)
        currentcontext?.setLineWidth(delegate.weekHeight())
        currentcontext?.move(to: CGPoint.init(x: 0, y: delegate.weekHeight() * 0.5))
        currentcontext?.addLine(to: CGPoint.init(x: self.frame.width, y: delegate.weekHeight() * 0.5))
        currentcontext?.strokePath()

        var arr = manager.getWeekInfo()
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        var attritustyle = [NSAttributedStringKey: Any]()
        attritustyle[NSAttributedStringKey.paragraphStyle] = style
        attritustyle[NSAttributedStringKey.foregroundColor] = delegate.weekTextColor()
        if weekType == WeekType.FIRSTDAY_MON {
            arr.append(arr.remove(at: 0))
        }

        for index in 0..<7 {
            let info = arr[index]
            let infosize = (info as NSString).size(withAttributes: attritustyle)
            (info as NSString).draw(in: CGRect.init(x: SIZE.width * CGFloat(index % 7) , y: (delegate.weekHeight()  - infosize.height) * 0.5, width: SIZE.width, height: delegate.weekHeight()), withAttributes: attritustyle)
        }
    }


    /// 获取当前月份所有的日期集合 包括上个月 和下个月还有当前月的 一共42 个
    ///
    /// - Parameter date: 日期
    /// - Returns: 当月 及上月(仅包括当月第一周前几天的日期)下月(凑够42个)的集合 公42个
    func getCurrentDates(_ date: Date) -> [Date] {
        var showdates:[Date] = []
        // TODO: 获取当前月份所有日期集合
        let dates = manager.getCurrentMonthAllDate(month: date).sorted()
        // TODO: 获取当前月份的上个月所有日期集合
        let lastdates = manager.getLastAllMonthAllDate(month: date).sorted()
        // TODO: 获取当前月份的下个月所有日期集合
        let nextdates = manager.getNextAllMonthAllDate(month: date).sorted()
        // TODO: 获取当前月份的第一天是周几
        // let firstWeek = manager.getFirstDayWeekForMonth(currentDate)!
        // 1 日  2 一  3 二 4 三 5 四 6 五 7 六
        var firstWeek:Int! {
            get {
                if weekType == .FIRSTDAY_SUN {
                    return manager.getFirstDayWeekForMonth(date)!
                }
                return manager.getFirstDayWeekForMonth(date)! - 1
            }
        }
        for index in 0..<42 {
            if index < firstWeek - 1 {
                let date = lastdates[lastdates.count - 1 - (firstWeek - 2) + index]
                showdates.append(date)
            }else if index < manager.getCurrentMothForDays(date) + firstWeek - 1{
                let date = dates[index - firstWeek + 1]
                showdates.append(date)
            }else {
                let date = nextdates[index - (manager.getCurrentMothForDays(date) +  firstWeek - 1)]
                showdates.append(date)
            }
        }
        return showdates
    }
}


extension ZJCalendarView {


    /// 初始化屏幕渲染器
    fileprivate func initDisplayLink() {
        timer = CADisplayLink.init(target: self, selector: #selector(runAnimation))
        timer.add(to: RunLoop.current, forMode: RunLoopMode.commonModes)
        timer.isPaused = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            let point = touch.location(in: self)
            beginTouchPoint = point
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first {
            let point = touch.location(in: self)
            moveTouchPoint = point
            scrollDistance = moveTouchPoint.x - beginTouchPoint.x

            self.setNeedsDisplay()
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first {
            let point = touch.location(in: self)
            endTouchPoint = point
            if beginTouchPoint.x == endTouchPoint.x && beginTouchPoint.y == endTouchPoint.y {
                if let date = getClickDate(point: point) {
                    debugPrint(date)
                    if manager.theSameMonthDate(currentPage, date2: date) {
                        selecectDate(date)
                    }
                }
            }else {
                self.selecectDate(nil)
                handlerTouchEnd()
            }

        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        if let touch = touches.first {
            let point = touch.location(in: self)
            endTouchPoint = point
            handlerTouchEnd()
        }
    }


    /// 处理手势结束或取消的 时间
    func handlerTouchEnd() {
        let distance = endTouchPoint.x - beginTouchPoint.x
        touchesEndDistance = scrollDistance
        animationRunCount = 0
        if distance > self.frame.width * 0.25 {
           // debugPrint("向右滑动 展示上一个月数据")
            scrolldirection = .RIGHT
        }
        else if distance < -self.frame.width * 0.25 {
           // debugPrint("向左滑动 展示下一个月数据")
            scrolldirection = .LEFT
        }else {
            scrolldirection = nil
        }
        timer.isPaused = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) { [weak self] in
            self?.scrollDistance = 0
            self?.timer.isPaused = true
            if distance > self!.frame.width * 0.25 {
              //  debugPrint("向右滑动 展示上一个月数据")
                self?.currentDate = self!.manager.getselectMonthDate(date: self!.currentDate, year: 0, month: -1)
                // scrollDistance = -self.frame.width
            }
            else if distance < -self!.frame.width * 0.25 {
              //  debugPrint("向左滑动 展示下一个月数据")
                self?.currentDate = self!.manager.getselectMonthDate(date: self!.currentDate, year: 0, month: 1)
                // scrollDistance = self.frame.width
            }
            self?.setNeedsDisplay()
        }
    }

    
    /// 利用 CADisplayLink 做刷新动画
    @objc func runAnimation() {
        animationRunCount = animationRunCount + 1
        if scrolldirection == .LEFT {
             scrollDistance = touchesEndDistance - ((self.frame.width - abs(touchesEndDistance))/15 * CGFloat(animationRunCount))
        }
        else if scrolldirection == .RIGHT {
            scrollDistance = touchesEndDistance + ((self.frame.width - abs(touchesEndDistance) )/15 * CGFloat(animationRunCount))
        }else {
            if scrollDistance > 0 {
                scrollDistance = touchesEndDistance - (abs(touchesEndDistance)/15 * CGFloat(animationRunCount))
            }else if scrollDistance < 0 {
                scrollDistance = touchesEndDistance + (abs(touchesEndDistance)/15 * CGFloat(animationRunCount))
            }
        }

       // debugPrint(scrollDistance)
        self.setNeedsDisplay()
    }

    func setSelectedDate(_ date:Date,animation:Bool) {
        selecectDate(date)


    }


    //TODO: 选择该日期
    fileprivate func selecectDate(_ date:Date?) {
        if selectedDates.count == 1 {
            delegate.deSelectedDate(selectedDates[0])
        }
        selectedDates.removeAll()
        if date != nil {
            selectedDates.append(date!)
            self.setNeedsDisplay()
            delegate.didSelectedDate(date!)
        }
    }

    /// 获取选中的日期
    ///
    /// - Parameter point: 点击的点
    /// - Returns: 选择的日期
    func getClickDate(point:CGPoint) -> Date? {
        let x = Int(point.x/SIZE.width) + 1
        let y = Int((point.y - delegate.weekHeight())/SIZE.height) + 1
        let index = Int(7 * (y - 1) + x)
        if index < monthdates.count && index > 0{
            return monthdates[index - 1]
        }
        return nil
    }
}





































