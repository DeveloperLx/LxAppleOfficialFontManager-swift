//
//  LxAppleOfficialFontManager.swift
//  LxAppleOfficialFontManagerDemo
//

import UIKit

let DEFAULT_FONT_SIZE: CGFloat = 20

class LxAppleOfficialFontManager {

    class func existsFontNamed(name fontName:String) -> Bool {
    
        assert(fontName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0, "LxAppleOfficialFontManager: Parameter fontName cannot be empty!")
        
        if let font = UIFont(name: fontName, size: DEFAULT_FONT_SIZE) {
        
            return font.fontName.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0 || font.familyName == fontName
        }
        else {
            return false
        }
    }
    
    class func availableAppleFontDescriptors() -> [UIFontDescriptor]? {
    
        let fontDownloadableAttribute = [kCTFontDownloadableAttribute as NSObject: true]
        let fontDescriptor = UIFontDescriptor(fontAttributes: fontDownloadableAttribute)
        let fontDescriptors = CTFontDescriptorCreateMatchingFontDescriptors(fontDescriptor as CTFontDescriptorRef, nil)
        return fontDescriptors as? [UIFontDescriptor]
    }
    
    class func downloadFontNamed(name fontName: String,
        progressCallBack: (progress: CGFloat) -> (),
        finishedCallBack: (font: UIFont?) -> (),
        failedCallBack: (error: NSError) -> ()) {
    
        assert(fontName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 0, "LxAppleOfficialFontManager: Parameter fontName cannot be empty!")
            
        let fontDescriptor = UIFontDescriptor(name: fontName, size: DEFAULT_FONT_SIZE)
        let fontDescriptors = [fontDescriptor]
            
        CTFontDescriptorMatchFontDescriptorsWithProgressHandler(fontDescriptors as CFArrayRef, nil) {
            (state, progressParameter) -> Bool in
        
            switch state {
            case .DidBegin:
                println("LxAppleOfficialFontManager: Font \(fontName) matching begin!")
            case .DidFinish:
                println("LxAppleOfficialFontManager: Font \(fontName) matching finished!")
                
                let progressParameterDict = progressParameter as NSDictionary
                let fontDescriptorMatchingResultArray = progressParameterDict.valueForKey(kCTFontDescriptorMatchingResult as String)! as! [UIFontDescriptor]
                let fontDescriptor = fontDescriptorMatchingResultArray.first
                let downloadedFontName = fontDescriptor!.fontAttributes()[UIFontDescriptorNameAttribute] as! String
                finishedCallBack(font: UIFont(name: downloadedFontName, size: DEFAULT_FONT_SIZE))
                
            case .WillBeginQuerying:
                println("LxAppleOfficialFontManager: Font \(fontName) querying begin!")
            case .Stalled:
                println("LxAppleOfficialFontManager: Font \(fontName) matching stalled!")
            case .WillBeginDownloading:
                println("LxAppleOfficialFontManager: Font \(fontName) will begin to be downloaded!")
            case .Downloading:
                let progressParameterDict = progressParameter as NSDictionary
                let matchingPercentageNumber = progressParameterDict[kCTFontDescriptorMatchingPercentage as! String] as! NSNumber
                let matchingPercentage = matchingPercentageNumber.doubleValue
                println("LxAppleOfficialFontManager: Font \(fontName) matching is being download with progress \(matchingPercentage)!")
                progressCallBack(progress: CGFloat(matchingPercentage))
                
            case .DidFinishDownloading:
                println("LxAppleOfficialFontManager: Font \(fontName) did downloaded!")
            case .DidMatch:
                println("LxAppleOfficialFontManager: Font \(fontName) matched!")
            case .DidFailWithError:
                println("LxAppleOfficialFontManager: Font \(fontName) download failed because of %@!")
                
                let progressParameterDict = progressParameter as NSDictionary
                let matchingError = progressParameterDict[kCTFontDescriptorMatchingError as! String] as! NSError
                failedCallBack(error: matchingError)
            }
            
            return true
        }
    }
}