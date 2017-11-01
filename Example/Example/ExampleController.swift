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
    
    var exmpleArray = ["http://video.feidieshuo.com/mp4/%E9%A3%9E%E7%A2%9F%E4%B8%80%E5%88%86%E9%92%9F/672.%E5%A5%B3%E7%A5%A8%E5%A6%82%E7%8B%BC%E4%BC%BC%E8%99%8E%EF%BC%8C%E5%BB%B6%E6%97%B6%E5%96%B7%E9%9B%BE%E9%9D%A0%E4%B8%8D%E9%9D%A0%E8%B0%B1%EF%BC%9F%EF%BC%88%E4%B8%BB%E7%AB%99%EF%BC%89.mp4"]
    
    var sorceArray = [
             "http://video.feidieshuo.com/mp4/%E9%A3%9E%E7%A2%9F%E4%B8%80%E5%88%86%E9%92%9F/672.%E5%A5%B3%E7%A5%A8%E5%A6%82%E7%8B%BC%E4%BC%BC%E8%99%8E%EF%BC%8C%E5%BB%B6%E6%97%B6%E5%96%B7%E9%9B%BE%E9%9D%A0%E4%B8%8D%E9%9D%A0%E8%B0%B1%EF%BC%9F%EF%BC%88%E4%B8%BB%E7%AB%99%EF%BC%89.mp4",
              "http://video.feidieshuo.com/mp4/%E9%A3%9E%E7%A2%9F%E4%B8%80%E5%88%86%E9%92%9F/673.%E5%A4%B1%E6%81%8B%E8%80%8C%E5%B7%B2%EF%BC%8C%E6%80%8E%E4%B9%88%E5%B0%B1%E7%96%BC%E5%BE%97%E5%83%8F%E4%B8%96%E7%95%8C%E6%9C%AB%E6%97%A5%EF%BC%88%E5%86%85%E6%B6%B5%EF%BC%89.mp4",
              "http://video.feidieshuo.com/mp4/%E9%A3%9E%E7%A2%9F%E4%B8%80%E5%88%86%E9%92%9F/674.%E5%BC%BA%E5%8D%96%E4%BA%BA%E8%AE%BE%EF%BC%9F%E7%BA%A2%E8%B5%B7%E6%9D%A5%E5%BF%AB%EF%BC%8C%E5%B4%A9%E8%B5%B7%E6%9D%A5%E6%9B%B4%E5%BF%AB%EF%BC%88%E4%B8%BB%E7%AB%99%EF%BC%89.mp4",
              "http://video.feidieshuo.com/mp4/%E9%A3%9E%E7%A2%9F%E4%B8%80%E5%88%86%E9%92%9F/675.%E6%88%91%E4%BB%AC%E4%B8%8D%E9%AA%97%EF%BC%81%E4%B8%8D%E6%8A%A2%EF%BC%81%E4%B8%8D%E5%81%B7%E4%BA%95%E7%9B%96%EF%BC%81%E8%B0%A2%E8%B0%A2%EF%BC%81%EF%BC%88%E4%B8%BB%E7%AB%99%EF%BC%89.mp4",
              "http://video.feidieshuo.com/mp4/%E9%A3%9E%E7%A2%9F%E4%B8%80%E5%88%86%E9%92%9F/676-%E5%85%AC%E5%85%B3%E6%96%87%E6%8E%90%E6%9E%B6%EF%BC%8C%E6%88%91%E5%8F%AA%E6%9C%8D%E9%80%81%E9%94%A4%E6%A1%90%E5%AD%90%EF%BC%88%E4%B8%BB%E7%AB%99%EF%BC%89.mp4",
              "http://video.feidieshuo.com/mp4/%E9%A3%9E%E7%A2%9F%E4%B8%80%E5%88%86%E9%92%9F/677-%E4%B8%8D%E8%88%92%E6%9C%8D%E7%9A%84%E5%8F%A3%E7%BD%A9%E6%A0%B9%E6%9C%AC%E9%85%8D%E4%B8%8D%E4%B8%8A%E4%BC%98%E7%A7%80%E7%9A%84%E6%88%91%EF%BC%88%20%E5%86%85%E6%B6%B5%EF%BC%89.mp4",
              "http://video.feidieshuo.com/mp4/%E9%A3%9E%E7%A2%9F%E4%B8%80%E5%88%86%E9%92%9F/678.%E6%B0%B4%E6%9E%9C%E9%85%B5%E7%B4%A0%E8%83%BD%E6%8E%92%E6%AF%92%EF%BC%9F%E5%BF%BD%E6%82%A0%EF%BC%8C%E4%BD%A0%E6%8E%A5%E7%9D%80%E5%BF%BD%E6%82%A0%EF%BC%88%E5%86%85%E6%B6%B5%EF%BC%89.mp4",
                      ]
    
    
}

