import Foundation
/**
 * Move the logic into CGRectModifier and CGRectParser and CGRectAsserter
 * For rect.isWithin(point) use: rect.contains(point)
 * RESEARCH: lots of Convenient CGRect methods here: https://github.com/nschum/SwiftCGRectExtensions/blob/master/CGRectExtensions/CGRectExtensions.swift
 */
extension CGRect {
    /**
     * Clones CGRect
     * ## Examples:  CGRect(0,0,100,100).clone()
     */
    public func clone() -> CGRect {//remove this, use copy instead
        return CGRect(self.origin.x, self.origin.y, self.width, self.height)
    }
    /**
     * Same as clone (Consistency)
     */
    public func copy() -> CGRect {
        return CGRect(self.origin.x, self.origin.y, self.width, self.height)
    }
    /**
     * Create a path using the coordinates of the rect passed in
     * ## Examples:  CGRect(0,0,100,100).path
     */
    public var path: CGMutablePath { return CGRectParser.path(self) }
    /*Initialization*/
    public init(_ pos: CGPoint, _ size: CGSize){ self.init(origin: pos, size: size)}
    public init(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat){ self.init(origin: CGPoint(x,y),size: CGSize( width, height))}//- Fixme: ⚠️️add initializer to CGSize
    public init(_ x: Double, _ y: Double, _ width: Double, _ height: Double){ self.init(origin: CGPoint(x,y),size: CGSize( width, height))}//- Fixme: ⚠️️add initializer to CGSize
    public init(_ x: CGFloat, _ y: CGFloat, _ width: Double, _ height: Double){ self.init(origin: CGPoint(x,y),size: CGSize( width, height))}
    public init(_ x: Int, _ y: Int, _ width: Double, _ height:Double){ self.init(origin: CGPoint(x,y),size: CGSize( width, height))}
    /*Position*/
    public var x: CGFloat { set { origin.x = newValue} get { return origin.x } }
    public var y: CGFloat { set { origin.y = newValue} get { return origin.y } }
    /*Size*/
    /*var width: CGFloat {set {size.width = newValue} get {return size.width} }
     var height: CGFloat {set {size.height = newValue} get {return size.height} }*/
    /*⚠️️ - Note:  Siwft3 seems to have problems with width get and height get as extensions so use w and h instead. set worked for some reason but still*/
    public var w: CGFloat { set { size.width = newValue} get { return size.width } }
    public var h: CGFloat { set { size.height = newValue} get { return size.height } }
    /*Corners*/
    public var topLeft: CGPoint { get { return self.origin } }
    public var point: CGPoint { get { return self.origin } }
    public var bottomLeft: CGPoint { get { return CGPoint(self.minX, self.maxY) } }
    public var bottomRight: CGPoint { get { return CGPoint(self.maxX, self.maxY) } }
    public var topRight: CGPoint { get { return CGPoint(self.maxX, self.minY) } }
    public var center: CGPoint { get { return CGPoint(self.midX, self.midY) } }
    public var top: CGPoint { get { return CGPoint(self.midX, self.minY) } }
    public var bottom: CGPoint { get { return CGPoint(self.midX, self.maxY) } }
    public var left: CGPoint { get { return CGPoint(self.maxX, self.midY) } }
    public var right: CGPoint { get { return CGPoint(self.minX, self.midY) } }
    public var corners: Array<CGPoint> { return CGRectParser.corners(self) }
    public var sides: Array<CGPoint> { return CGRectParser.sides(self) }
//    var nsRect: NSRect { return NSRectFromCGRect(self) }
    /**
     * - Fixme: ⚠️️ Maybe for x,y,width,height aswell?
     * - Fixme: ⚠️️ Make it enum! it's faster
     */
//    subscript(key: Alignment) -> CGPoint {/*Easy Access to corners*/
//        get {
//            switch key{
//            case .topLeft: return topLeft
//            case .topRight: return topRight
//            case .bottomRight: return bottomRight
//            case .bottomLeft: return bottomLeft
//            case .topCenter: return top
//            case .bottomCenter: return bottom
//            case .centerLeft: return left
//            case .centerRight: return right
//            case .centerCenter: return center
//            }
//        }
//        set {
//            fatalError("UNSUPORTED CORNER TYPE: " + key.rawValue + " WITH VALUE: " + String(describing: newValue))
//        }
//    }
    /**
     * negative inset equals outset
     */
    public func outset(_ dx: CGFloat, _ dy: CGFloat)->CGRect{
        return insetBy(dx: -dx, dy: -dy)
    }
    /**
     * - Note:  Same as insetBy, but this method is simpler to call, similar to Outset (Convenience)
     */
    public func inset(_ dx: CGFloat, _ dy: CGFloat) -> CGRect{
        return insetBy(dx: dx, dy: dy)
    }
    public func offset(_ dx: CGFloat, _ dy: CGFloat) -> CGRect{/*Convenience*/
        return self.offsetBy(dx: dx, dy: dy)
    }
    public func offset(_ point: CGPoint) -> CGRect{/*Convenience*/
        return self.offsetBy(dx: point.x,dy: point.y)
    }
    /**
     * - Note:  Alters the original CGRect instance
     * Swift 3 update, as of swift 3 CGRect no longer has the offsetInPlace method. This method replaces that functionality.
     * - Fixme: ⚠️️ ⚠️️ could probably be simplified by just copying the origin.x and origin y onto self
     */
    public mutating func offsetInPlace(_ point: CGPoint) -> CGRect{//Convenience
        let offsetRect: CGRect = self.offset(point)
        self.origin = offsetRect.origin
        return self
    }
    /**
     * Expands the size of the rect from its pivot
     */
    public func expand(_ dx: CGFloat, _ dy: CGFloat) -> CGRect{
        return CGRect(self.x, self.y, self.width + dx, self.height + dy)
    }
}
public func +(a: CGRect, b: CGPoint) -> CGRect { return CGRect(a.x + b.x, a.y + b.y, a.width, a.height) }//Adds the coordinates of point p to the coordinates of this point to create a new point
public func +=(a: inout CGRect, b: CGPoint) { a.x += b.x;a.y += b.y; }//modifies a by adding b, could also have used: offsetBy()
public func -=(a: inout CGRect, b: CGPoint) { a.x -= b.x;a.y -= b.y; }//modifies a by adding b, could also have used: offsetBy()

public func +(a: CGRect, b: CGRect) -> CGRect { return CGRect(a.origin + b.origin,a.size + b.size) }
public func -(a: CGRect, b: CGRect) -> CGRect { return CGRect(a.origin - b.origin,a.size - b.size) }
public func *(a: CGRect, b: CGRect) -> CGRect { return CGRect(a.origin * b.origin,a.size * b.size) }
//public func -(a: CGSize, b: CGSize) -> CGSize { return CGSize(a.width - b.width,a.height - b.height)}
//public func * (a: CGSize, b: CGSize) -> CGSize {return CGSize(a.w*b.w, a.h*b.h)}
