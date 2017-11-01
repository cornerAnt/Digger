<div align=center>
<img src="https://github.com/cornerAnt/Digger/blob/master/images/logo.png"/>
</div>

[![Version](https://img.shields.io/cocoapods/v/PieCharts.svg?style=flat)]( https://cocoapods.org/pods/Digger)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![LICENSE](https://camo.githubusercontent.com/fc56303af12c023343f338a762b6bfb2a5f1e4dc/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f6c6963656e73652d4d49542d677265656e2e7376673f7374796c653d666c6174)](LICENSE)

[English Introduction](https://github.com/cornerAnt/Digger/blob/master/README.md)

Digger是一个轻量的下载框架,一行代码即可实现文件下载任务.

基于URLSession,纯Swift语言实现,支持链式语法调用,实时下载进度,实时下载速度,断点下载.

<div align=center>
<img src="https://github.com/cornerAnt/Digger/blob/master/images/demo.gif"/>
</div>

## 功能
- 链式语法调用
- 大文件下载
- 可控并发数
- 线程安全
- 断点下载

## 要求

- iOS 8.0+  
- Xcode 9.0+   
- Swift 4.0+

## 安装

### CocoaPods

Add to your Podfile:

```ruby
use_frameworks!
pod 'Digger'
```

### Carthage

Add to your Cartfile:

```
github "cornerAnt/Digger"
```

## 使用

###基本用法:
在沙盒的Caches下的Digger目录,下载一个文件

```swift
   let url = "http://example.com/digger.mp4"
   Digger.download(url)

```

###链式语法调用:
可以根据自己的需求,选择下载进度,下载速度,下载结果回调

```swift
        
  Digger.download(url)
        .progress(nil)
        .speed(nil)
        .completion(nil)
```


```swift
   let url = "http://example.com/digger.mp4"

        Digger.download(url)
            .progress({ (progresss) in
                print(progresss.fractionCompleted)

            })
            .speed({ (speed) in
                print(speed)
            })
            .completion { (result) in
                
                switch result {
                case .success(let url):
                    print(url)
                    
                case .failure(let error):
                    print(error)
                    
                }
                
        }
}

```
自定义配置:

```swift

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
```


## 参与:

欢迎 Fork , Star , Issues


## 作者:

cornerAnt

## 开源协议

Digger is Copyright (c) 2017 cornerAnt and released as open source under the attached [MITLICENSE](LICENSE).


