//
//  ViewController.swift
//  LxAppleOfficialFontManagerDemo
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        label.text = "Preparing..."
        label.textAlignment = .Center
        label.textColor = UIColor.blueColor()
        label.numberOfLines = 0
        label.center = view.center
        view.addSubview(label)
        
        let downloadableAvailableFontDescriptors = LxAppleOfficialFontManager.availableAppleFontDescriptors()!
        let randomFontDescriptor = downloadableAvailableFontDescriptors[Int(arc4random()) % downloadableAvailableFontDescriptors.count]
        let randomFontName = randomFontDescriptor.fontAttributes()[UIFontDescriptorNameAttribute] as! String
        
        LxAppleOfficialFontManager.downloadFontNamed(name: randomFontName,
            progressCallBack: { (progress) -> () in
                println("progress = \(progress)")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    label.text = "\(progress) downloaded"
                })
            },
            finishedCallBack: { (font) -> () in
                
                println("font = \(font)")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    label.text = "This is apple offical font \(font!.fontName)!"
                    label.font = font
                })
            },
            failedCallBack: { (error) -> () in
                println("error = \(error)")
            })
    }
}

