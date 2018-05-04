//
//  CalendarManager.swift
//  CalendarDemo
//
//  Created by 国投 on 2018/4/12.
//  Copyright © 2018年 FlyKite. All rights reserved.
//

import Foundation

class CalendarManager:NSObject {

    private var calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)


    override init() {
        super.init()
    }

    /// 根据日期判断某月有多少天
    func getCurrentMothForDays(_ date:Date) -> Int {
         // NSRange是一个结构体，其中location是一个以0为开始的index，length是表示对象的长度。他们都是NSUInteger类型。
        let range = (calendar as NSCalendar).range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: date)
        return range.length
    }

    func getWeekInfo() -> [String] {
//        debugPrint(calendar.weekdaySymbols)
//        debugPrint(calendar.shortWeekdaySymbols)
//        debugPrint(calendar.veryShortWeekdaySymbols)
//
//        debugPrint(calendar.monthSymbols)
//        debugPrint(calendar.shortMonthSymbols)
//        debugPrint(calendar.veryShortMonthSymbols)
//
//
//        debugPrint(calendar.shortStandaloneMonthSymbols)
//        debugPrint(calendar.shortStandaloneWeekdaySymbols)
//        debugPrint(calendar.shortStandaloneQuarterSymbols)
//        debugPrint(calendar.veryShortStandaloneMonthSymbols)
//        debugPrint(calendar.veryShortStandaloneWeekdaySymbols)
        return calendar.veryShortWeekdaySymbols

    }

    /// 根据日期判断某月1号的数据
    func getMonthfromDate(_ date:Date,index:Int = 1) -> Date? {
        if index > getCurrentMothForDays(date) {
            fatalError("index 不合法")
        }

        var compoenents = calendar.dateComponents(Set([Calendar.Component.year, Calendar.Component.month,Calendar.Component.day]), from: date)
        compoenents.day = index
        return calendar.date(from: compoenents)
    }

    ///获得每月的第一天 是周几
    func getFirstDayWeekForMonth(_ month:Date) -> Int? {
        let compoments = calendar.dateComponents(Set([Calendar.Component.weekday]), from: getMonthfromDate(month)!)

        guard let weekDays = compoments.weekday else {
            return nil
        }
        return weekDays

    }

    /// 取日期 n年 或者 n月的数据 正数为往后 负数往前
    func getselectMonthDate(date:Date,year:Int,month:Int) -> Date {
        var compoenents = calendar.dateComponents(Set([Calendar.Component.year, Calendar.Component.month,Calendar.Component.day]), from: date)
        compoenents.year = year
        compoenents.month = month
        compoenents.day = 1
        return calendar.date(byAdding: compoenents, to: date)!
    }

    /// 根据当月日期返回所有日期
    func getCurrentMonthAllDate(month:Date) -> Set<Date> {
        let currentmonthday = getCurrentMothForDays(month)
        var currentDates:[Date] = []
        for index in 0..<currentmonthday {
            if let date = getMonthfromDate(month, index: index + 1) {
                currentDates.append(date)
            }
        }
        return Set(currentDates)
    }

    /// 根据上月日期返回所有日期
    func getLastAllMonthAllDate(month:Date) -> Set<Date> {
        var lastDates:[Date] = []
        let lastDate = getMonthfromDate(getselectMonthDate(date: month, year: 0, month: -1))!
        for index in 0..<getCurrentMothForDays(getselectMonthDate(date: month, year: 0, month: -1)) {
            if let date = getMonthfromDate(lastDate, index: index + 1) {
                lastDates.append(date)
            }
        }
        return Set(lastDates)
    }

    /// 根据下月日期返回所有日期
    func getNextAllMonthAllDate(month:Date) -> Set<Date> {
        var laterDates:[Date] = []
        let laterDate = getMonthfromDate(getselectMonthDate(date: month, year: 0, month: 1))!
        for index in 0..<getCurrentMothForDays(getselectMonthDate(date: month, year: 0, month: 1))  {
            if let date = getMonthfromDate(laterDate, index: index + 1) {
                laterDates.append(date)
            }
        }
        return Set(laterDates)
    }

    /// 是否同一个月
    func theSameMonthDate(_ date:Date,date2:Date) -> Bool {
        return calendar.isDate(date, equalTo: date2, toGranularity: Calendar.Component.month)
    }

    /// 根据date判断属于该月的某一天
    func getDayOfMonth(date:Date) -> Int {
        return calendar.component(Calendar.Component.day, from: date)

    }

}


enum Week {

    case SUN
    case MON
    case TUS
    case WED
    case THU
    case FRI
    case SAT

}

enum WeekType {

    case FIRSTDAY_MON
    case FIRSTDAY_SUN

}
