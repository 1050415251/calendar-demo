//
//  ZJCalendarDelegate.swift
//  CalendarDemo
//
//  Created by 国投 on 2018/4/11.
//  Copyright © 2018年 FlyKite. All rights reserved.
//

import Foundation
import UIKit

protocol ZJCalendarDelegate:NSObjectProtocol {

    // 选中某个日期
    func didSelectedDate(_ date:Date)
    // 取消选中某个日期
    func deSelectedDate(_ date:Date)

    /// 默认字体颜色
    func defaultTextColorOf(_ date:Date) -> UIColor

    func elsemonthTextColorOf(_ date:Date) -> UIColor
    /// 选中字体颜色
    func selectionTextColorOf(_ date:Date) -> UIColor
    /// 默认背景颜色
    func defaultBgColorOf(_ date:Date) -> UIColor
    /// 选中背景颜色
    func selectionBgColorOf(_ date:Date) -> UIColor
    /// 默认字体大小
    func defaultFontOf(_ date:Date) -> UIFont
    /// 选中字体大小
    func selectionFontOf(_ date: Date) -> UIFont?
    /// 周末字体颜色
    func weekTextColor() -> UIColor
    /// 周末背景颜色
    func weekBgColor() -> UIColor

    func weekHeight() -> CGFloat

    func weekType() -> WeekType

}

protocol ZJCalendarDataSource:NSObjectProtocol {

    


}























