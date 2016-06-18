/**
Usage:

let originalImage = UIImage(named: "cat")
let tintedImage = originalImage.tintWithColor(UIColor(red: 0.9, green: 0.7, blue: 0.4, alpha: 1.0))

*/

import UIKit
extension UIImage {
  
  func tintWithColor(color:UIColor)->UIImage {
    
    UIGraphicsBeginImageContext(self.size)
    let context = UIGraphicsGetCurrentContext()
  
    // flip the image
    CGContextScaleCTM(context, 1.0, -1.0)
    CGContextTranslateCTM(context, 0.0, -self.size.height)
    
    // multiply blend mode
    CGContextSetBlendMode(context, .Multiply)
    let rect = CGRectMake(0, 0, self.size.width, self.size.height)
    CGContextClipToMask(context, rect, self.CGImage)
    color.setFill()
    CGContextFillRect(context, rect)
    
    // create uiimage
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
    
  }
  
}

