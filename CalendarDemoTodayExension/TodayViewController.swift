//
//  TodayViewController.swift
//  calendardemo-TodayExetension
//
//  Created by 国投 on 2018/5/8.
//  Copyright © 2018年 FlyKite. All rights reserved.
//

import UIKit
import NotificationCenter


class TodayViewController: UIViewController, NCWidgetProviding {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        self.preferredContentSize = CGSize.init(width: UIScreen.main.bounds.width, height: 100)
        self.view.backgroundColor = UIColor.blue
        let lab = UILabel()
        lab.frame = self.view.bounds
        lab.textAlignment = .center
        lab.text = "打开app"
        self.view.addSubview(lab)

        //  self.extensionContext?.widgetActiveDisplayMode = NCWidgetDisplayMode.expanded

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.newData)
    }

    //MARK: 展开或者收起布局
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {

        if activeDisplayMode == NCWidgetDisplayMode.compact {
            self.preferredContentSize = CGSize.init(width: UIScreen.main.bounds.width, height: 100)
        }else {
            self.preferredContentSize = CGSize.init(width: UIScreen.main.bounds.width, height: 280)
        }

    }



}






































