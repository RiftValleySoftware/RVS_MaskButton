/**
 © Copyright 2022, The Great Rift Valley Software Company

 LICENSE:

 MIT License

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
 files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
 modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
 Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 The Great Rift Valley Software Company: https://riftvalleysoftware.com
 
 Version 1.0.1
*/

import UIKit

/* ###################################################################################################################################### */
// MARK: - Private UIImage Extension For Resizing -
/* ###################################################################################################################################### */
fileprivate extension UIImage {
    /* ################################################################## */
    /**
     This allows an image to be resized, given a maximum dimension, and a scale will be determined to meet that dimension.
     If the image is currently smaller than the maximum size, it will not be scaled.
     
     - parameter toMaximumSize: The maximum size, in either the X or Y axis, of the image, in pixels.
     
     - returns: A new image, with the given dimensions. May be nil, if there was an error.
     */
    func _resized(toMaximumSize: CGFloat) -> UIImage? {
        let scaleX: CGFloat = toMaximumSize / size.width
        let scaleY: CGFloat = toMaximumSize / size.height
        return _resized(toScaleFactor: min(1.0, min(scaleX, scaleY)))
    }

    /* ################################################################## */
    /**
     This allows an image to be resized, given a maximum dimension, and a scale will be determined to meet that dimension.
     
     - parameter toScaleFactor: The scale of the resulting image, as a multiplier of the current size.
     
     - returns: A new image, with the given scale. May be nil, if there was an error.
     */
    func _resized(toScaleFactor inScaleFactor: CGFloat) -> UIImage? { _resized(toNewWidth: size.width * inScaleFactor, toNewHeight: size.height * inScaleFactor) }
    
    /* ################################################################## */
    /**
     This allows an image to be resized, given both a width and a height, or just one of the dimensions.
     
     - parameters:
         - toNewWidth: The width (in pixels) of the desired image. If not provided, a scale will be determined from the toNewHeight parameter.
         - toNewHeight: The height (in pixels) of the desired image. If not provided, a scale will be determined from the toNewWidth parameter.
     
     - returns: A new image, with the given dimensions. May be nil, if no width or height was supplied, or if there was an error.
     */
    func _resized(toNewWidth inNewWidth: CGFloat? = nil, toNewHeight inNewHeight: CGFloat? = nil) -> UIImage? {
        guard nil == inNewWidth,
              nil == inNewHeight else {
            var scaleX: CGFloat = (inNewWidth ?? size.width) / size.width
            var scaleY: CGFloat = (inNewHeight ?? size.height) / size.height

            scaleX = nil == inNewWidth ? scaleY : scaleX
            scaleY = nil == inNewHeight ? scaleX : scaleY

            let destinationSize = CGSize(width: size.width * scaleX, height: size.height * scaleY)
            let destinationRect = CGRect(origin: .zero, size: destinationSize)

            UIGraphicsBeginImageContextWithOptions(destinationSize, false, 0)
            defer { UIGraphicsEndImageContext() }   // This makes sure that we get rid of the offscreen context.
            draw(in: destinationRect, blendMode: .normal, alpha: 1)
            return UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(renderingMode)
        }
        
        return nil
    }
}

/* ###################################################################################################################################### */
// MARK: - Private CGPoint Extension For Rotating Points -
/* ###################################################################################################################################### */
fileprivate extension CGPoint {
    /* ################################################################## */
    /**
     Rotate this point around a given point, by an angle given in degrees.
     
     - parameters:
        - around: Another point, that is the "fulcrum" of the rotation.
        - byDegrees: The rotation angle, in degrees. 0 is no change. - is counter-clockwise, + is clockwise.
     - returns: The transformed point.
     */
    func _rotated(around inCenter: CGPoint, byDegrees inDegrees: CGFloat) -> CGPoint { _rotated(around: inCenter, byRadians: (inDegrees * .pi) / 180) }
    
    /* ################################################################## */
    /**
     This was inspired by [this SO answer](https://stackoverflow.com/a/35683523/879365).
     Rotate this point around a given point, by an angle given in radians.
     
     - parameters:
        - around: Another point, that is the "fulcrum" of the rotation.
        - byDegrees: The rotation angle, in radians. 0 is no change. - is counter-clockwise, + is clockwise.
     - returns: The transformed point.
     */
    func _rotated(around inCenter: CGPoint, byRadians inRadians: CGFloat) -> CGPoint {
        let dx = x - inCenter.x
        let dy = y - inCenter.y
        let radius = sqrt(dx * dx + dy * dy)
        let azimuth = atan2(dy, dx)
        let newAzimuth = azimuth + inRadians
        let x = inCenter.x + radius * cos(newAzimuth)
        let y = inCenter.y + radius * sin(newAzimuth)
        return CGPoint(x: x, y: y)
    }
}

/* ###################################################################################################################################### */
// MARK: - A Special Button Class That Can Mask A Gradient -
/* ###################################################################################################################################### */
/**
 This class can be displayed with either the text (or image) filled with a gradient, or the background filled, and the text (or image) "cut out" of it.
 All behavior is the same as any other UIButton.
 
 This allows you to specify a border, which will be included in the gradient fill.
 You should set [the `layer.borderWidth` property](https://developer.apple.com/documentation/quartzcore/calayer/1410917-borderwidth), in order to do this.
 If the `borderWidth` value is anything greater than 0, there will be a border, with corners specified by
 [`layer.cornerRadius`](https://developer.apple.com/documentation/quartzcore/calayer/1410818-cornerradius).
 The border will be filled with the gradient, as well as the text or image (or excluded, if `reversed` is true).
 
 The button can have either text or image (not both). It also only applies to .normal, .highlighted, and .disabled states.
 You may have different text or images for those three states.
 Text is given priority. If text is provided, then the images are ignored (and not displayed).
 Images must be rendererable as template.
 
 This button is quite simple, and "old-fashioned," compared to the current buttons.
 It doesn't have support for all the scheming and styling that UIButton has, and should be treated as "Default" style.
 */
#if os(iOS) // This prevents the IB errors from showing up, under SPM (From SO Answer: https://stackoverflow.com/a/66334661/879365).
@IBDesignable
open class RVS_MaskButton: UIButton {
    /* ################################################################################################################################## */
    // MARK: Private Static Constants
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     The transparency coefficient to use, if the control is highlighted.
     This is what the control "dims" to, when touched.
     */
    private static var _highlightAlpha = CGFloat(0.25)
    
    /* ################################################################################################################################## */
    // MARK: Private Property
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     This is how many blank display units to add to either side of the label, to ensure padding.
     */
    private static let _horizontalLabelPaddingInDisplayUnits = CGFloat(10)
    
    /* ################################################################## */
    /**
     This caches the original alpha value. It is set at load time.
     */
    private var _originalAlpha = CGFloat(0)
    
    /* ################################################################## */
    /**
     This caches the original background color. It is set at load time.
     */
    private var _originalBackgroundColor: UIColor?
    
    /* ################################################################## */
    /**
     This caches the original tint color. It is set at load time.
     */
    private var _originalTintColor: UIColor?

    /* ################################################################## */
    /**
     This caches the gradient layer. This is set when the gradient is redrawn.
     If this is not-nil, then it will be fetched, instead of redrawing the gradient.
     In order to force the gradient to redraw, set this to nil.
     */
    private var _gradientLayer: CAGradientLayer?

    /* ################################################################## */
    /**
     This caches the mask layer.
     If this is not-nil, then it will be fetched, instead of redrawing the mask.
     In order to force the mask to redraw, set this to nil.
     */
    private var _maskLayer: CALayer?
    
    /* ################################################################################################################################## */
    // MARK: Public IB Properties
    /* ################################################################################################################################## */
    /* ################################################################## */
    /**
     The starting color for the gradient.
     If not provide, the view backgroundColor is used.
     If that is not provided, then the view tintColor is used.
     If that is not provided, then the super (parent) view tintColor is used.
     If that is not provided, the AccentColor is used.
     If that is not provided, the class will not work.
     */
    @IBInspectable public var gradientStartColor: UIColor? {
        didSet {
            _gradientLayer = nil
            setNeedsLayout()
        }
    }

    /* ################################################################## */
    /**
     The ending color. If not provided, then the starting color is used.
     */
    @IBInspectable public var gradientEndColor: UIColor? {
        didSet {
            _gradientLayer = nil
            setNeedsLayout()
        }
    }

    /* ################################################################## */
    /**
     The angle of the gradient, in degrees. 0 (default) is top-to-bottom.
     Zero is top-to-bottom.
     Negative is counter-clockwise, and positive is clockwise.
     */
    @IBInspectable public var gradientAngleInDegrees: CGFloat = 0 {
        didSet {
            _gradientLayer = nil
            setNeedsLayout()
        }
    }

    /* ################################################################## */
    /**
     If true, then the label is reversed, so the background is "cut out" of the foreground.
     If there is a border, that will also be cut out.
     */
    @IBInspectable public var reversed: Bool = false {
        didSet {
            _maskLayer = nil
            setNeedsLayout()
        }
    }
}

/* ###################################################################################################################################### */
// MARK: Private Computed Properties
/* ###################################################################################################################################### */
private extension RVS_MaskButton {
    /* ################################################################## */
    /**
     This returns the background gradient layer, rendering it, if necessary.
     */
    var _fetchGradientLayer: CALayer? { _makeGradientLayer() }
    
    /* ################################################################## */
    /**
     This returns the mask layer, rendering it, if necessary.
     */
    var _fetchMaskLayer: CALayer? { _makeMaskLayer() }
}

/* ###################################################################################################################################### */
// MARK: Public Computed Properties
/* ###################################################################################################################################### */
public extension RVS_MaskButton {
    /* ################################################################## */
    /**
     This allows you to set the font of the button. This is not inspectable, and must be set programmatically.
     */
    var buttonFont: UIFont? {
        get { titleLabel?.font }
        set {
            titleLabel?.font = newValue
            _maskLayer = nil
            setNeedsLayout()
        }
    }
}

/* ###################################################################################################################################### */
// MARK: Private Instance Methods
/* ###################################################################################################################################### */
private extension RVS_MaskButton {
    /* ################################################################## */
    /**
     This creates the gradient layer, using our specified start and stop colors.
     If the gradient cache is available, we immediately return that, instead.
     */
    func _makeGradientLayer() -> CALayer? {
        guard nil == _gradientLayer else { return _gradientLayer }
        
        // We try to get whatever the user explicitly set. If not that, then a background color, then the tint color (both ours and super), and, finally, the accent color. If not that, we give up.
        if let startColor = gradientStartColor ?? _originalBackgroundColor ?? _originalTintColor ?? superview?.tintColor ?? UIColor(named: "AccentColor") {
            let endColor = gradientEndColor ?? startColor
            _gradientLayer = CAGradientLayer()
            _gradientLayer?.frame = bounds
            _gradientLayer?.colors = [startColor.cgColor, endColor.cgColor]
            _gradientLayer?.startPoint = CGPoint(x: 0.5, y: 0)._rotated(around: CGPoint(x: 0.5, y: 0.5), byDegrees: gradientAngleInDegrees)
            _gradientLayer?.endPoint = CGPoint(x: 0.5, y: 1.0)._rotated(around: CGPoint(x: 0.5, y: 0.5), byDegrees: gradientAngleInDegrees)
        } else {
            assertionFailure("No Starting Color Provided for the RVS_MaskButton class!")
        }
        
        return _gradientLayer
    }
    
    /* ################################################################## */
    /**
     This uses our text or image to generate a mask layer.
     If the mask cache is available, we immediately return that, instead.
     */
    func _makeMaskLayer() -> CALayer? {
        guard nil == _maskLayer else { return _maskLayer }
        
        // These colors map to a transparency mask. White is opaque. Black is transparent.
        let foreColor = reversed ? UIColor.black.cgColor : UIColor.white.cgColor
        let backColor = reversed ? UIColor.white.cgColor : UIColor.black.cgColor
        
        // we first see if we have text.
        // If so, we then determine the appropriate font size.
        if let text = title(for: state) ?? title(for: .normal),
           var dynFont = titleLabel?.font {
            let minimumFontSizeInPoints = (dynFont.pointSize * 0.25)
            let scalingStep = 0.0125
            while dynFont.pointSize >= minimumFontSizeInPoints {
                let calcString = NSAttributedString(string: text, attributes: [.font: dynFont])
                let cropRect = calcString.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
                // We add the padding for our calculations. We take the border into account.
                if bounds.size.width >= (cropRect.size.width + ((Self._horizontalLabelPaddingInDisplayUnits + layer.borderWidth) * 2)) {
                    break
                }
                guard let tempDynFont = UIFont(name: dynFont.fontName, size: dynFont.pointSize - (dynFont.pointSize * scalingStep)) else { break }
                dynFont = tempDynFont
            }
            
            titleLabel?.font = dynFont
            
            // If we have text, we do not have images.
            super.setImage(nil, for: .normal)
            super.setImage(nil, for: .highlighted)
            super.setImage(nil, for: .disabled)
        }
        
        var subLayer: CALayer?
        
        if let text = title(for: state) ?? title(for: .normal),
           let titleLabel = titleLabel,
           let font = buttonFont {
            let textLayer = CATextLayer()
            textLayer.frame = titleLabel.frame
            textLayer.rasterizationScale = UIScreen.main.scale
            textLayer.contentsScale = UIScreen.main.scale
            textLayer.alignmentMode = .left
            textLayer.fontSize = font.pointSize
            textLayer.font = font
            textLayer.isWrapped = true
            textLayer.truncationMode = .none
            textLayer.string = text
            textLayer.foregroundColor = foreColor
            subLayer = textLayer
        // Images are always template.
        } else if let image = (image(for: state) ?? image(for: .normal))?.withRenderingMode(.alwaysTemplate)
            .withTintColor(UIColor(cgColor: foreColor))
            ._resized(toMaximumSize: max(bounds.size.width, bounds.size.height)) {
            subLayer = CALayer()
            subLayer?.frame = CGRect(origin: CGPoint(x: (bounds.size.width - image.size.width) / 2, y: (bounds.size.height - image.size.height) / 2), size: image.size)
            subLayer?.contents = image.cgImage
        }

        if let subLayer = subLayer {
            let outlineLayer = CAShapeLayer()
            outlineLayer.frame = bounds
            outlineLayer.strokeColor = foreColor
            outlineLayer.fillColor = backColor

            outlineLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
            outlineLayer.lineWidth = layer.borderWidth
            
            if let compositingFilter = CIFilter(name: "CIAdditionCompositing") {
                subLayer.compositingFilter = compositingFilter
                outlineLayer.addSublayer(subLayer)
                
                self._maskLayer = outlineLayer
            }
        }
        
        return _maskLayer
    }
}

/* ###################################################################################################################################### */
// MARK: Public Instance Methods
/* ###################################################################################################################################### */
public extension RVS_MaskButton {
    /* ################################################################## */
    /**
     This is used to flush the caches, and redraw the button.
     */
    func forceRedraw() {
        _gradientLayer = nil
        _maskLayer = nil
        setNeedsLayout()
    }
}

/* ###################################################################################################################################### */
// MARK: Public Base Class Overrides
/* ###################################################################################################################################### */
public extension RVS_MaskButton {
    /* ################################################################## */
    /**
     We call this, when it's time to lay out the control.
     We subvert the standard rendering, and replace it with our own rendering.
     Some of this comes from [this SO answer](https://stackoverflow.com/questions/42238603/reverse-a-calayer-mask/42238699#42238699)
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // First time through, we keep these values.
        if 0 == _originalAlpha,
           0 < alpha {
            _originalAlpha = alpha
        }
        
        if nil == _originalBackgroundColor {
            _originalBackgroundColor = backgroundColor
            backgroundColor = nil
        }
        
        if nil == _originalTintColor {
            _originalTintColor = tintColor
            tintColor = nil
        }

        // This sets up the baseline.
        layer.borderColor = UIColor.clear.cgColor
        titleLabel?.isHidden = true
        _gradientLayer?.removeFromSuperlayer()
        layer.mask = nil
        
        // Create a mask, and apply that to our background gradient.
        if let _fetchGradientLayer = _fetchGradientLayer,
           let initialMaskLayer = _fetchMaskLayer,
           let filter = CIFilter(name: "CIMaskToAlpha") {
            layer.addSublayer(_fetchGradientLayer)
            let renderedCoreImage = CIImage(image: UIGraphicsImageRenderer(size: bounds.size).image { initialMaskLayer.render(in: $0.cgContext) })
            filter.setValue(renderedCoreImage, forKey: "inputImage")
            if let outputImage = filter.outputImage {
                let coreGraphicsImage = CIContext().createCGImage(outputImage, from: outputImage.extent)
                let maskLayer = CALayer()
                maskLayer.frame = bounds
                maskLayer.contents = coreGraphicsImage
                layer.mask = maskLayer
            }
            
            alpha = isHighlighted ? _originalAlpha * Self._highlightAlpha : _originalAlpha
        }
    }
    
    /* ################################################################## */
    /**
     Called while tracking user touch. We use this to play with the alpha, while tracking.
     
     - parameter inTouch: The touch being tracked.
     - parameter with: The event that spawned the touch.
     - returns: True, if the touch is to continue.
     */
    override func continueTracking(_ inTouch: UITouch, with inEvent: UIEvent?) -> Bool {
        alpha = isHighlighted ? _originalAlpha * Self._highlightAlpha : _originalAlpha
        return super.continueTracking(inTouch, with: inEvent)
    }
    
    /* ################################################################## */
    /**
     Called when ending user touch. We use this to restore the alpha.
     
     - parameter inTouch: The touch being tracked.
     - parameter with: The event that spawned the touch.
     */
    override func endTracking(_ inTouch: UITouch?, with inEvent: UIEvent?) {
        alpha = _originalAlpha
        super.endTracking(inTouch, with: inEvent)
    }
    
    /* ################################################################## */
    /**
     Called when setting text. We use this, to ensure we redraw the mask.
     
     - parameter inTitle: The new text.
     - parameter for: The state, to which the text applies.
     */
    override func setTitle(_ inTitle: String?, for inState: UIControl.State) {
        _maskLayer = nil
        super.setTitle(inTitle, for: inState)
        setNeedsLayout()
    }
    
    /* ################################################################## */
    /**
     Called when setting images. We use this, to ensure we redraw the mask.
     
     - parameter inImage: The new image. It should be a template image.
     - parameter for: The state, to which the text applies.
     */
    override func setImage(_ inImage: UIImage?, for inState: UIControl.State) {
        _maskLayer = nil
        super.setImage(inImage, for: inState)
        setNeedsLayout()
    }
}
#endif
