//
//  ExampleCell.swift
//  Example
//
//  Created by ant on 2017/10/28.
//  Copyright © 2017年 github.cornerant. All rights reserved.
//

import UIKit

class DownloadButton: UIButton {
    
    override var isHighlighted: Bool {
        set{
            
        }
        get {
            return false
        }
    }
    
    override func awakeFromNib() {
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: resumeNotificationName), object: nil, queue: nil) { (noti) in
        
            self.isSelected  = false
            
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: suspendNotificationName), object: nil, queue: nil) { (noti) in
            
            self.isSelected  = true
            
        }
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
}
class ExampleCell: UITableViewCell {
    
    
    var selectedButton : DownloadButton!
    @IBOutlet weak var downloadButton: UIButton!
    
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var statusLabel: UILabel!
    var isDownloading = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        // Configure the view for the selected state
    }
    
    
    
    
}
