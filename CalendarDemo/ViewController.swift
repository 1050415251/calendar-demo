//
//  ViewController.swift
//  CalendarDemo
//
//  Created by 国投 on 2018/4/11.
//  Copyright © 2018年 FlyKite. All rights reserved.
//

import UIKit

class ViewController: UIViewController {



    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let calendarV = ZJCalendarView(frame: CGRect.init(x: 15, y: 50, width: self.view.frame.width - 30, height: 250))
        calendarV.backgroundColor = UIColor.white
        calendarV.delegate = self
        calendarV.currentDate = Date()

        self.view.addSubview(calendarV)

        self.view.backgroundColor = UIColor.black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: ZJCalendarDelegate,ZJCalendarDataSource {
    func elsemonthTextColorOf(_ date: Date) -> UIColor {
        return UIColor.lightGray
    }

   
    func didSelectedDate(_ date: Date) {

    }

    func deSelectedDate(_ date: Date) {

    }

    func weekHeight() -> CGFloat {
        return 40
    }

    func weekType() -> WeekType {
        return .FIRSTDAY_SUN
    }

    func defaultTextColorOf(_ date: Date) -> UIColor {
        return UIColor.black

    }

    func selectionTextColorOf(_ date: Date) -> UIColor {
        return UIColor.white
    }

    func defaultBgColorOf(_ date: Date) -> UIColor {
        return UIColor.white
    }

    func selectionBgColorOf(_ date: Date) -> UIColor {
        return UIColor.red
    }

    func defaultFontOf(_ date: Date) -> UIFont {
        return UIFont.systemFont(ofSize: 12)
    }

    func selectionFontOf(_ date: Date) -> UIFont? {
        return UIFont.systemFont(ofSize: 14)
    }

    func weekTextColor() -> UIColor {
        return UIColor.black
    }

    func weekBgColor() -> UIColor {
        return UIColor.lightGray
    }



}
