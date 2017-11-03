<div align=center>
<img src="https://github.com/cornerAnt/Digger/blob/master/Images/logo.png"/>
</div>

[![Version](http://img.shields.io/cocoapods/v/Digger.svg?style=flat)](https://cocoapods.org/pods/Digger)
[![Carthage compatible](https://camo.githubusercontent.com/3dc8a44a2c3f7ccd5418008d1295aae48466c141/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f43617274686167652d636f6d70617469626c652d3442433531442e7376673f7374796c653d666c6174)](https://github.com/Carthage/Carthage)
[![Version](https://camo.githubusercontent.com/fc56303af12c023343f338a762b6bfb2a5f1e4dc/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f6c6963656e73652d4d49542d677265656e2e7376673f7374796c653d666c6174)](LICENSE)


[中文说明](https://github.com/cornerAnt/Digger/blob/master/CN_README.md)

Digger is a lightweight download framework that requires only one line of code to complete the file download task.

Based on URLSession, pure Swift language implementation, support chain syntax call, real-time download progress, real-time download speed, breakpoint download.

The user forces the app to be shut down, for example by sliding off the app.
Digger can still resume downloading tasks.


<div align=center>
<img src="https://github.com/cornerAnt/Digger/blob/master/Images/demo.gif"/>
</div>


## Features:
- Large file download
- Multi thread Download
- Thread safety
- Breakpoint downloading
- Controllable concurrency

## Requirements"

- iOS 8.0+
- Xcode 9.0+
- Swift 4.0+
## Installation

### CocoaPods

Add to your Podfile:

```ruby
pod 'Digger'
```

### Carthage

Add to your Cartfile:

```
github "cornerAnt/Digger"
```

## Usage

###Basic:
Download a file in the Digger directory under the sandbox's Caches

```swift
   let url = "http://example.com/digger.mp4"
   Digger.download(url)

```
Choose different callbacks depending on your needs

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

Config yourself

```swift

/// Start the task at once,default is true

DiggerManager.shared.startDownloadImmediately = false

/// maxConcurrentTasksCount,deault is 3

DiggerManager.shared.maxConcurrentTasksCount = 4

///  request timeout,deault is 100 

DiggerManager.shared.timeout = 150

/// allowsCellularAccess,deault is true

DiggerManager.shared.allowsCellularAccess = false

/// loglevel,deault is high
/*
***************DiggerLog****************
file   : ExampleController.swift
method : viewDidLoad()
line   : [31]:
info   : digger log

*/
// If you want to close,set the level to be .none

DiggerManager.shared.logLevel = .none




// MARK:-  DiggerCache

/// In the sandbox cactes directory, custom your cache directory

DiggerCache.cachesDirectory = "Directory"

/// Delete all downloaded files

DiggerCache.cleanDownloadFiles()

/// Delete all temporary download files

DiggerCache.cleanDownloadTempFiles()

/// Get the system's available memory size

_ = DiggerCache.systemFreeSize()

/// Get the size of the downloaded file

_ = DiggerCache.downloadedFilesSize()

/// Get the path to all downloaded files
_ = DiggerCache.pathsOfDownloadedfiles
}
```
 


## Contributing

1. Fork
2. Commit changes to a branch in your fork
3. Push your code and make a pull request


## License

Digger is Copyright (c) 2017 cornerAnt and released as open source under the attached [MIT License](LICENSE).


