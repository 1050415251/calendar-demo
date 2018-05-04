//
//  CalendarLab.swift
//  CalendarDemo
//
//  Created by 国投 on 2018/4/12.
//  Copyright © 2018年 FlyKite. All rights reserved.
//

import Foundation
import UIKit

class  CalendarItemBtn:UIButton {

    weak var manager:CalendarManager!
    weak var delegate:ZJCalendarDelegate!
    weak var dataSourCe:ZJCalendarDataSource!

    var date:Date!


    convenience init(manager:CalendarManager) {
        self.init()
        self.manager = manager
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

        
    func setDate(_ date:Date) {
        self.date = date
        self.setTitle("\(manager.getDayOfMonth(date: date))", for: .normal)

    }
}
