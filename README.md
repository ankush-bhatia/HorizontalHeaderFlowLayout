# HorizontalHeaderFlowLayout

## Description:
- HorizontalHeaderFlowLayout is a subclass of UICollectionViewLayout written in pure Swift language.
- This library uses Apple's UIKit framework.

## Features

- [x] Easy to use.
- [x] Cocoapods Integration.

## Requirements

- iOS 9.0+
- Xcode 10+

## Installation

- HorizontalHeaderFlowLayout is available on [CocoaPods](https://cocoapods.org).
- Current version compatible with Swift 4.1.

#### Cocoapods
Add the following line to your Podfile:
```
pod 'HorizontalHeaderFlowLayout', '~> 1.0'
```

#### Manually
1. Clone the repository or download it as a .zip file.
2. Drag and drop HeaderFlowLayout.swift to your project.

## Usage:

#### From Storyboard:
**1.** Change layout of CollectionView to custom and assign HeaderFlowLayout as class.

![](Image URL to storyboard)

**2.** Import Framework
```swift
import HorizontalHeaderFlowLayout
```

**3.** Conform to `HeaderFlowLayoutDelegate`
```swift
class ViewController: UIViewController, HeaderFlowLayoutDelegate {

}
```

**4.** Implement required Delegate Methods.

#### Programatically:
**1.** Import Framework
```swift
import HorizontalHeaderFlowLayout
```
**2.** Instantiate `HorizontalHeaderFlowLayout` and add to CollectionView object.

```swift
collectionView.collectionViewLayout = HeaderFlowLayout()
```

**3.** Conform to `HeaderFlowLayoutDelegate`
```swift
class ViewController: UIViewController, HeaderFlowLayoutDelegate {

}
```

**4.** Implement required Delegate Methods.

## Contribution
Any suggestions and contribution towards making it a better library is most welcome.


## Authors
[**Ankush Bhatia**](https://github.com/ankush-bhatia)

## License
This project is licensed under the MIT License -  [LICENSE](LICENSE).






