//
//  ExampleController.swift
//  Example
//
//  Created by ant on 2017/10/28.
//  Copyright © 2017年 github.cornerant. All rights reserved.
//

import UIKit
import Digger

public let suspendNotificationName = "suspednNotificationName"
public let resumeNotificationName =  "resumeNotificationName"
class ExampleController: UITableViewController {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       

        setup()
    }
    
    func diggerConfig() {
        
        
        /// 是否立刻开始任务,默认为true
        
        DiggerManager.shared.startDownloadImmediately = false
        
        /// 设置并发数,默认为3
        
        DiggerManager.shared.maxConcurrentTasksCount = 4
        
        /// 设置请求超时,默认为150毫秒
        
        DiggerManager.shared.timeout = 150
        
        /// 设置是否可用蜂窝数据下载,默认为true
        
        DiggerManager.shared.allowsCellularAccess = false
        
        /// 设置日志级别,默认为high,格式如下,设置为none则关闭
        
        DiggerManager.shared.logLevel = .none
        
        /*
         ***************DiggerLog****************
         file   : ExampleController.swift
         method : viewDidLoad()
         line   : [31]:
         info   : digger log
         
         */


        // MARK:-  DiggerCache

        /// 在沙盒cactes目录,自定义缓存目录
        
        DiggerCache.cachesDirectory = "Directory"
        
        /// 删除所有下载的文件
        
        DiggerCache.cleanDownloadFiles()
        
        /// 删除所有临时下载文件
        
        DiggerCache.cleanDownloadTempFiles()
        
        /// 获取系统可用内存
        
        _ = DiggerCache.systemFreeSize()
        
        /// 获取已下载文件大小
        
        _ = DiggerCache.downloadedFilesSize()

        /// 获取所有下载完成的文件的路径
        _ = DiggerCache.pathsOfDownloadedfiles


    
    }
    func setup(){
        
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        DiggerCache.cleanDownloadFiles()
        UIApplication.shared.statusBarStyle = .lightContent
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return exmpleArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "ExampleCell", for: indexPath) as! ExampleCell
        
        let url = exmpleArray[indexPath.row]
        cell.downloadButton.tag = indexPath.row
        cell.downloadButton.addTarget(self, action: #selector(downloadButtonClick), for: .touchUpInside)
        if !cell.isDownloading {
            Digger.download(url).completion { (result) in
                switch result {
                case .success(let url):
                    _ =  url
                    
                    diggerLog(url)
                case .failure(let error):
                    
                    _ =  error
                    diggerLog(error)
                    
                }
                
                }.progress { (progress) in
                    
                    cell.progressView.progress = Float(progress.fractionCompleted)
                    
                }.speed { (speed) in
                    cell.speedLabel.text = ("\(speed / 1024)" + "KB/S")
                    
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            DiggerManager.shared.cancelTask(for: exmpleArray[indexPath.row])
            exmpleArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    
    @objc  func downloadButtonClick(downloadButton:UIButton) {
        

        let url =  exmpleArray[downloadButton.tag]
        if downloadButton.isSelected {
            DiggerManager.shared.startTask(for: url)
            
        }else{
            DiggerManager.shared.stopTask(for: url)
        }
        downloadButton.isSelected =  !downloadButton.isSelected

       
    }
    
    @IBAction func resumeAll(_ sender: UIBarButtonItem) {
    
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: resumeNotificationName), object: ExampleCell.self)
        DiggerManager.shared.startAllTasks()
        
    }
    @IBAction func suspendAll(_ sender: UIBarButtonItem) {
    
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: suspendNotificationName), object: ExampleCell.self)
        DiggerManager.shared.stopAllTasks()
        
    }
    
    
    @IBAction func addDownloadTask(_ sender: UIBarButtonItem) {
        
        if sorceArray.isEmpty { return }
         exmpleArray.append(sorceArray.last!)
         sorceArray.removeLast()
         tableView.reloadData()

    }
    
    @IBAction func removeDownloadTask(_ sender: UIBarButtonItem) {
        
        if exmpleArray.isEmpty { return }
         exmpleArray.removeFirst()
         tableView.reloadData()
    }
    
    var exmpleArray = ["http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"]
    
    var sorceArray = [
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4",
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4",
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
        "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4"
    ]
    
    
}

