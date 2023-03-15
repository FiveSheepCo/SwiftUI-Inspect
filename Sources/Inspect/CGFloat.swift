import Foundation

infix operator ≈≈ : ComparisonPrecedence
extension CGFloat {
    static func ≈≈(lhs: CGFloat, rhs: CGFloat) -> Bool {
        abs(lhs - rhs) <= 2
    }
}
