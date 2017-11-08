


//
//  DiggerManager.swift
//  Digger
//
//  Created by ant on 2017/10/25.
//  Copyright © 2017年 github.cornerant. All rights reserved.
//

import Foundation


public protocol DiggerManagerProtocol{
 
    /// logLevel hing,low,none
    var logLevel : LogLevel { set get }
    
    /// Apple limit is per session,The default value is 6 in macOS, or 4 in iOS.
    var maxConcurrentTasksCount : Int {set get}
    
    var allowsCellularAccess : Bool { set get }
    
    var timeout: TimeInterval { set get }
    
    /// Start the task at once,default is true
    
    var startDownloadImmediately  : Bool { set get }
    
    func startTask(for diggerURL: DiggerURL)
    
    func stopTask(for diggerURL: DiggerURL)
    
    /// If the task is cancelled, the temporary file will be deleted
    func cancelTask(for diggerURL: DiggerURL)
    
    func startAllTasks()
    
    func stopAllTasks()
    
    func cancelAllTasks()
    
}

open class DiggerManager:DiggerManagerProtocol {

   
    
    // MARK:-  property
    
    public static var shared = DiggerManager(name: digger)
    public var logLevel: LogLevel = .high
    open var startDownloadImmediately = true
    open var timeout: TimeInterval = 100
    fileprivate var diggerSeeds = [URL: DiggerSeed]()
    fileprivate var session: URLSession
    fileprivate var diggerDelegate: DiggerDelegate?
    fileprivate let barrierQueue = DispatchQueue.barrier
    fileprivate let delegateQueue = OperationQueue.downloadDelegateOperationQueue
    
    public var maxConcurrentTasksCount: Int = 3 {
        didSet{
            
            let count = maxConcurrentTasksCount == 0 ?  1 : maxConcurrentTasksCount
            session.invalidateAndCancel()
            session = setupSession(allowsCellularAccess, count)
        }
    }
    
    public var allowsCellularAccess: Bool = true {
        didSet{
            session.invalidateAndCancel()
            session = setupSession(allowsCellularAccess, maxConcurrentTasksCount)
        }
    }
    
    
    // MARK:-  lifeCycle
    
    private init(name: String) {
        
        DiggerCache.cachesDirectory = digger
        if name.isEmpty {
            fatalError("DiggerManager must hava a name")
        }
        
        
        diggerDelegate = DiggerDelegate()
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.allowsCellularAccess = allowsCellularAccess
        sessionConfiguration.httpMaximumConnectionsPerHost = maxConcurrentTasksCount
        session = URLSession(configuration: sessionConfiguration, delegate: diggerDelegate, delegateQueue: delegateQueue)
    }
    
    deinit {
        session.invalidateAndCancel()
    }
    
    
    
    
    private func setupSession(_ allowsCellularAccess:Bool ,_ maxDownloadTasksCount:Int ) -> URLSession{
        diggerDelegate = DiggerDelegate()
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.allowsCellularAccess = allowsCellularAccess
        sessionConfiguration.httpMaximumConnectionsPerHost = maxDownloadTasksCount
        let session = URLSession(configuration: sessionConfiguration, delegate: diggerDelegate, delegateQueue: delegateQueue)
        
        return session
    }
    
    
    
    ///  download file
    ///  DiggerSeed contains information about the file
    /// - Parameter diggerURL: url
    /// - Returns: the diggerSeed of file
    @discardableResult
    public func download(with diggerURL: DiggerURL) -> DiggerSeed{
        
        switch isDiggerURLCorrect(diggerURL) {
        case .success(let url):
            
            return createDiggerSeed(with: url)
            
        case .failure(_):
            
            fatalError("Please make sure the url or urlString is correct")
        }
        
        
    }
    
    
    
    
}
// MARK:-  diggerSeed control

extension DiggerManager{
    
    func createDiggerSeed(with url: URL) -> DiggerSeed{
        
        
        if let DiggerSeed = findDiggerSeed(with: url) {
            
            
            return  DiggerSeed
        }else{
            barrierQueue.sync(flags: .barrier){
                let timeout = self.timeout == 0.0 ? 100 : self.timeout
                let diggerSeed  = DiggerSeed(session: session, url: url, timeout: timeout)
                diggerSeeds[url] = diggerSeed
            }
            
            
            let diggerSeed = findDiggerSeed(with: url)!
            diggerDelegate?.manager = self
            
            if self.startDownloadImmediately{
                diggerSeed.downloadTask.resume()
            }
            return  diggerSeed
            
            
        }
        
    }
    
    
    public func removeDigeerSeed(for url : URL){
        barrierQueue.sync(flags: .barrier) {
            diggerSeeds.removeValue(forKey: url)
            if diggerSeeds.isEmpty{
                diggerDelegate = nil
            }
        }
    }
    
    func isDiggerURLCorrect(_ diggerURL: DiggerURL) -> Result<URL> {
        var correctURL: URL
        do {
            
            correctURL = try diggerURL.asURL()
            
            return Result.success(correctURL)
        } catch {
            diggerLog(error)
            return Result.failure(error)
        }
    }
    
    func findDiggerSeed(with diggerURL: DiggerURL) -> DiggerSeed? {
        
        var diggerSeed: DiggerSeed?
        
        switch isDiggerURLCorrect(diggerURL) {
        case .success(let url):
            
            barrierQueue.sync(flags: .barrier) {
                diggerSeed = diggerSeeds[url]
            }
            return diggerSeed
            
        case .failure(_):
            
            return diggerSeed
        }
        
    }
    
}
// MARK:-  downloadTask control

extension DiggerManager{
    
    
    
    
    public func cancelTask(for diggerURL: DiggerURL) {
  
        switch isDiggerURLCorrect(diggerURL) {
            
        case .failure(_):
            return
            
        case .success(let url):
            
            barrierQueue.sync(flags: .barrier){
                
                guard let diggerSeed = diggerSeeds[url] else {
                    return
                }
                diggerSeed.downloadTask.cancel()
                
            }
        }
        
    }
    
    public func stopTask(for diggerURL: DiggerURL) {

        
        switch isDiggerURLCorrect(diggerURL) {
            
        case .failure(_):
            return
            
        case .success(let url):
            
            barrierQueue.sync(flags: .barrier){
                
                guard let diggerSeed = diggerSeeds[url] else {
                    return
                }
                if diggerSeed.downloadTask.state == .running{
                    diggerSeed.downloadTask.suspend()
                    diggerDelegate?.notifySpeedZeroCallback(diggerSeed)
                }
            }
        }
        
        
        
    }
    public func startTask(for diggerURL: DiggerURL) {
 
        switch isDiggerURLCorrect(diggerURL) {
            
        case .failure(_):
            return
            
        case .success(let url):
            
            barrierQueue.sync(flags: .barrier){
                guard let diggerSeed = diggerSeeds[url] else {
                    return
                }
                
                if diggerSeed.downloadTask.state != .running{
                    diggerSeed.downloadTask.resume()
                    
                    self.diggerDelegate?.notifySpeedCallback(diggerSeed)
                }
                
            }
            
        }
        
        
        
    }
    
    
    public  func startAllTasks() {
        
        _ = diggerSeeds.keys.map{  (url) in
            startTask(for: url)
        }
        
        
    }
    
    public  func stopAllTasks()  {
        
        _ = diggerSeeds.keys.map{ (url) in
            stopTask(for : url)
        }
        
    }
    
    public func cancelAllTasks()  {
        
        _ = diggerSeeds.keys.map{ (url) in
            
            cancelTask(for: url)
        }
        
    }
    
}
// MARK:-  URLSessionExtension

extension URLSession {
    
    public func dataTask(with url : URL,timeout:TimeInterval) -> URLSessionDataTask{
        
        let range  = DiggerCache.fileSize(filePath: DiggerCache.tempPath(url: url))
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeout)
        let headRange = "bytes=" + String(range) + "-"
        request.setValue(headRange, forHTTPHeaderField: "Range")
        
        
        let task = dataTask(with: request)
        task.priority =  URLSessionTask.defaultPriority
        
        return task
    }
    
    
}





