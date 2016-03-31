
import UIKit


// using the core image filter to adjust images


// adjust contrast, delta is the ratio, range suggest 0 ... 2
public func adjustContrastFilter(image : UIImage, delta : Double) -> UIImage? {
    let orientation = image.imageOrientation
    let scale = image.scale
    let ci = CIImage(image: image)?.imageByApplyingFilter("CIColorControls", withInputParameters: ["inputContrast" : delta])
    return CIImageToUIimage(ci!, scale: scale, orientation: orientation)
}

// adjust brightness, delta is delta, range suggest -0.5 ... 0.5
public func adjustBrightnessFilter(image : UIImage, delta : Double) -> UIImage? {
    let orientation = image.imageOrientation
    let scale = image.scale
    let ci = CIImage(image: image)?.imageByApplyingFilter("CIColorControls", withInputParameters: ["inputBrightness" : delta])
    return CIImageToUIimage(ci!, scale: scale, orientation: orientation)
}

// adjust saturation, delta is ratio, 0 is grey, 1 is original, >1 increases saturation, range suggest 0 ... 2
public func adjustSaturationFilter(image : UIImage, delta : Double) -> UIImage? {
    let orientation = image.imageOrientation
    let scale = image.scale
    let ci = CIImage(image: image)?.imageByApplyingFilter("CIColorControls", withInputParameters: ["inputSaturation" : delta])
    return CIImageToUIimage(ci!, scale: scale, orientation: orientation)
}

// to grey, set saturation to zero
public func toGreyFilter(image: UIImage) -> UIImage? {
    let orientation = image.imageOrientation
    let scale = image.scale
    let ci = CIImage(image: image)?.imageByApplyingFilter("CIColorControls", withInputParameters: ["inputSaturation" : 0])
    return CIImageToUIimage(ci!, scale: scale, orientation: orientation)
}


// better way to convert CIImage to UIImage, CIImage -> CGImage -> UIImage
private func CIImageToUIimage(ci : CIImage, scale : CGFloat, orientation : UIImageOrientation) -> UIImage? {
    let context = CIContext(options: nil)
    return UIImage(CGImage: context.createCGImage(ci, fromRect: ci.extent), scale: scale, orientation : orientation)
}

// gaussian blur filter, range 0 - 10, default 2
public func blurFilter(image: UIImage, delta : Double) -> UIImage? {
    let originalCI = CIImage(image: image)
    let ci = originalCI!.imageByApplyingFilter("CIGaussianBlur", withInputParameters: ["inputRadius" : delta])

    let context = CIContext(options: nil)
    return UIImage(CGImage: context.createCGImage(ci, fromRect: (originalCI?.extent)!), scale: image.scale, orientation: image.imageOrientation)
}

// invert filter
public func invertFilter(image: UIImage) -> UIImage? {
    let orientation = image.imageOrientation
    let scale = image.scale
    let ci = CIImage(image: image)?.imageByApplyingFilter("CIColorInvert", withInputParameters: nil)
    return CIImageToUIimage(ci!, scale: scale, orientation: orientation)
}

// vintage filter, give an image a vintage effect
public func vintageFilter(image: UIImage) -> UIImage? {
    let orientation = image.imageOrientation
    let scale = image.scale
    let ci = CIImage(image: image)?.imageByApplyingFilter("CIPhotoEffectChrome", withInputParameters: nil)
    return CIImageToUIimage(ci!, scale: scale, orientation: orientation)
}

// change gamma, range 0-2, default 0.75
public func gammaFilter(image: UIImage, delta : Double) -> UIImage? {
    let orientation = image.imageOrientation
    let scale = image.scale
    let ci = CIImage(image: image)?.imageByApplyingFilter("CIGammaAdjust", withInputParameters: ["inputPower" : delta])
    return CIImageToUIimage(ci!, scale: scale, orientation: orientation)
}
