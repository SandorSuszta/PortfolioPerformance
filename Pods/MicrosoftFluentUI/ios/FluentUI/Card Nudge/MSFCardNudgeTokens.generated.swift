// swiftlint:disable all
/// Autogenerated file
import UIKit

/// Entry point for the app stylesheet
extension FluentUIStyle {

	// MARK: - MSFBorderedCardNudgeTokens
	open var MSFBorderedCardNudgeTokens: MSFBorderedCardNudgeTokensAppearanceProxy {
		return MSFBorderedCardNudgeTokensAppearanceProxy(proxy: { return self })
	}
	open class MSFBorderedCardNudgeTokensAppearanceProxy: MSFCardNudgeTokensAppearanceProxy {

		// MARK: - backgroundColor 
		open override var backgroundColor: UIColor {
			return mainProxy().Colors.Background.surfacePrimary
		}

		// MARK: - outlineColor 
		open override var outlineColor: UIColor {
			return mainProxy().Colors.Stroke.neutral1
		}

		// MARK: - textColor 
		open override var textColor: UIColor {
			return mainProxy().Colors.Brand.shade20
		}
	}
	// MARK: - MSFCardNudgeTokens
	open var MSFCardNudgeTokens: MSFCardNudgeTokensAppearanceProxy {
		return MSFCardNudgeTokensAppearanceProxy(proxy: { return self })
	}
	open class MSFCardNudgeTokensAppearanceProxy {
		public let mainProxy: () -> FluentUIStyle
		public init(proxy: @escaping () -> FluentUIStyle) {
			self.mainProxy = proxy
		}

		// MARK: - accentColor 
		open var accentColor: UIColor {
			return mainProxy().Colors.Brand.shade20
		}

		// MARK: - accentIconSize 
		open var accentIconSize: CGFloat {
			return mainProxy().Icon.size.xxSmall
		}

		// MARK: - accentPadding 
		open var accentPadding: CGFloat {
			return mainProxy().Spacing.xxSmall
		}

		// MARK: - backgroundColor 
		open var backgroundColor: UIColor {
			return mainProxy().Colors.Background.neutral2
		}

		// MARK: - buttonBackgroundColor 
		open var buttonBackgroundColor: UIColor {
			return mainProxy().Colors.Brand.tint30
		}

		// MARK: - buttonInnerPaddingHorizontal 
		open var buttonInnerPaddingHorizontal: CGFloat {
			return mainProxy().Spacing.small
		}

		// MARK: - circleSize 
		open var circleSize: CGFloat {
			return mainProxy().Icon.size.xxLarge
		}

		// MARK: - cornerRadius 
		open var cornerRadius: CGFloat {
			return mainProxy().Border.radius.xLarge
		}

		// MARK: - horizontalPadding 
		open var horizontalPadding: CGFloat {
			return mainProxy().Spacing.medium
		}

		// MARK: - iconSize 
		open var iconSize: CGFloat {
			return mainProxy().Icon.size.xSmall
		}

		// MARK: - interTextVerticalPadding 
		open var interTextVerticalPadding: CGFloat {
			return mainProxy().Spacing.xxxSmall
		}

		// MARK: - mainContentVerticalPadding 
		open var mainContentVerticalPadding: CGFloat {
			return mainProxy().Spacing.small
		}

		// MARK: - minimumHeight 
		open var minimumHeight: CGFloat {
			return CGFloat(56.0)
		}

		// MARK: - outlineColor 
		open var outlineColor: UIColor {
			return UIColor(named: "FluentColors/clear", in: FluentUIFramework.colorsBundle, compatibleWith: nil)!
		}

		// MARK: - outlineWidth 
		open var outlineWidth: CGFloat {
			return mainProxy().Border.size.thin
		}

		// MARK: - subtitleTextColor 
		open var subtitleTextColor: UIColor {
			return mainProxy().Colors.Foreground.neutral3
		}

		// MARK: - textColor 
		open var textColor: UIColor {
			return mainProxy().Colors.Foreground.neutral1
		}

		// MARK: - verticalPadding 
		open var verticalPadding: CGFloat {
			return mainProxy().Spacing.xSmall
		}
	}

}
fileprivate var __AppearanceProxyHandle: UInt8 = 0
fileprivate var __ThemeAwareHandle: UInt8 = 0
fileprivate var __ObservingDidChangeThemeHandle: UInt8 = 0

extension MSFCardNudgeTokens: AppearaceProxyComponent {

	public typealias AppearanceProxyType = FluentUIStyle.MSFCardNudgeTokensAppearanceProxy
	public var appearanceProxy: AppearanceProxyType {
		get {
			if let proxy = objc_getAssociatedObject(self, &__AppearanceProxyHandle) as? AppearanceProxyType {
				if !themeAware { return proxy }

				if let proxyString = Optional(String(reflecting: type(of: proxy))), proxyString.hasPrefix("FluentUI") == false {
					return proxy
				}

				if proxy is FluentUIStyle.MSFBorderedCardNudgeTokensAppearanceProxy {
					return FluentUIThemeManager.stylesheet(FluentUIStyle.shared()).MSFBorderedCardNudgeTokens
				}
				return proxy
			}

			return FluentUIThemeManager.stylesheet(FluentUIStyle.shared()).MSFCardNudgeTokens
		}
		set {
			objc_setAssociatedObject(self, &__AppearanceProxyHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			didChangeAppearanceProxy()
		}
	}

	public var themeAware: Bool {
		get {
			guard let proxy = objc_getAssociatedObject(self, &__ThemeAwareHandle) as? Bool else { return true }
			return proxy
		}
		set {
			objc_setAssociatedObject(self, &__ThemeAwareHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			isObservingDidChangeTheme = newValue
		}
	}

	fileprivate var isObservingDidChangeTheme: Bool {
		get {
			guard let observing = objc_getAssociatedObject(self, &__ObservingDidChangeThemeHandle) as? Bool else { return false }
			return observing
		}
		set {
			if newValue == isObservingDidChangeTheme { return }
			if newValue {
				NotificationCenter.default.addObserver(self, selector: #selector(didChangeAppearanceProxy), name: Notification.Name.didChangeTheme, object: nil)
			} else {
				NotificationCenter.default.removeObserver(self, name: Notification.Name.didChangeTheme, object: nil)
			}
			objc_setAssociatedObject(self, &__ObservingDidChangeThemeHandle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
}
