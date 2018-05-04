//
//  CalendarEventDreactor.swift
//  CalendarDemo
//
//  Created by 国投 on 2018/4/16.
//  Copyright © 2018年 FlyKite. All rights reserved.
//

import Foundation
import UIKit

//该日期事件的装饰器
class CalendarEventDecorator:CalendarItemBtn {



    convenience init(eventLab:UILabel,calendarLab:CalendarItemBtn) {
        self.init()
        debugPrint("带事件的日历控件")
    }

    private func initView() {

    }

}
