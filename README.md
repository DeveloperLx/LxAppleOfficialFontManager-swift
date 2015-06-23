# LxAppleOfficialFontManager-swift
######	Fetch graceful font from apple official handily!
---
###	Installation
	You only need drag LxAppleOfficialFontManager.swift to your project.
###	Support	
	Minimum support iOS version: iOS 7.0
###	Usage
	let downloadableAvailableFontDescriptors = LxAppleOfficialFontManager.availableAppleFontDescriptors()!
    let randomFontDescriptor = downloadableAvailableFontDescriptors[Int(arc4random()) % downloadableAvailableFontDescriptors.count]
    let randomFontName = randomFontDescriptor.fontAttributes()[UIFontDescriptorNameAttribute] as! String
        
    LxAppleOfficialFontManager.downloadFontNamed(name: randomFontName,
        progressCallBack: { (progress) -> () in
            println("progress = \(progress)")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                _label.text = "\(progress) downloaded"
            })
        },
        finishedCallBack: { (font) -> () in
            
            println("font = \(font)")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                _label.text = "This is apple offical font \(font!.fontName)!"
                _label.font = font
            })
        },
        failedCallBack: { (error) -> () in
            println("error = (error)")
        })
    }
---
###	License
LxAppleOfficialFontManager is available under the Apache License 2.0. See the LICENSE file for more info.