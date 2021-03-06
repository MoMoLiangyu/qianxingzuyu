//
//  ResultTableViewController.swift
//  SoolyWeather
//
//  Created by SoolyChristina on 2017/3/24.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit

private let resultCell = "resultCell"

class ResultTableViewController: UITableViewController {

    var resultArray:[String] = []
    var isFrameChange = false
    /// 点击cell回调闭包
    var callBack: ((String?) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 控制器根据所在界面的status bar，navigationbar，与tabbar的高度，不自动调整scrollview的 inset
        self.automaticallyAdjustsScrollViewInsets = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: resultCell)
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return resultArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell =  tableView.dequeueReusableCell(withIdentifier: resultCell, for: indexPath)
        cell.textLabel?.text = resultArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let city = cell?.textLabel?.text
        callBack?(city)
        print(String.init(describing: city))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let topMargin = self.view.safeAreaInsets.top + 44;
        // 设置view的frame
        if isFrameChange == false {
            view.frame = CGRect(x: 0, y: topMargin, width: ScreenWidth, height: ScreenHeight - topMargin)
            isFrameChange = true
        }
    }
}
