import AppKit

/// View controller subclasses can conform to this protocol to get the ability to be instantiated from the storyboard using a single method call.
public protocol StoryboardLoadable: class {
  /// Create an instance of the ViewController from its associated Storyboard and the Scene with identifier `sceneIdentifier`
  ///
  /// - returns: instance of the conforming view controller.
  static func loadFromStoryboard() -> Self

  /// The NSStoryboard name to use when we want to instantiate this view controller. Defaults to the class name of this view controller.
  static var storyboardName: String { get }

  /// The scene identifier to use when we want to instantiate this view controller from its associated storyboard. Defaults to the class name of this view controller.
  static var sceneIdentifier: NSStoryboard.SceneIdentifier { get }
}

// MARK: - Extension

public extension StoryboardLoadable where Self: NSViewController {
  static func loadFromStoryboard() -> Self {
    let storyboard = NSStoryboard(name: NSStoryboard.Name(storyboardName),
                                  bundle: Bundle(for: Self.self))
    return storyboard.instantiateController(withIdentifier: sceneIdentifier) as! Self
  }

  static var sceneIdentifier: NSStoryboard.SceneIdentifier {
    return NSStoryboard.SceneIdentifier(String(describing: self))
  }

  static var storyboardName: String {
    return "Main"
  }
}

public extension StoryboardLoadable where Self: NSWindowController {
  static func loadFromStoryboard() -> Self {
    let storyboard = NSStoryboard(name: NSStoryboard.Name(storyboardName),
                                  bundle: Bundle(for: Self.self))
    return storyboard.instantiateController(withIdentifier: sceneIdentifier) as! Self
  }

  static var sceneIdentifier: NSStoryboard.SceneIdentifier {
    return NSStoryboard.SceneIdentifier(String(describing: self))
  }

  static var storyboardName: String {
    return "Main"
  }
}
