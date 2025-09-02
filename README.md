# RSSpinnerView

🌀 **RSSpinnerView** is a lightweight, customizable and animated circular progress view for iOS. It supports multiple styles, colors, and optional labels, making it suitable for both full-screen loading indicators and embedded UI elements.

![RSSpinnerView Demo](demo.gif)

---

## ✨ Features

- [x] Customizable spinner size: `micro`, `small`, `medium`, `large`, `full`
- [x] Built using `CAShapeLayer` and `CABasicAnimation`
- [x] Support for themes (`light`, `dark`, `transparent`)
- [x] Optional title and description labels
- [x] Modular & reusable with clean API
- [x] Can be shown/hidden dynamically from any view

---

## 🧰 Requirements

- iOS 13.0+
- Swift 5.5+
- Xcode 13+

---

## 📦 Installation

> Currently manual. Swift Package Manager support coming soon.

1. Download or clone the repository.
2. Copy the `RSSpinnerView.swift` and `CircularProgressView.swift` files into your project.

---

## 🚀 Usage

### 1. **Import the class**

```swift
import RSSpinnerView

SHOW SPINNER:

RSSpinnerView.showSpinner(
    ofSize: .large,                    // .micro, .small, .medium, .large, .full
    spinnerColor: .dark,               // .light, .dark, .transparentDark, .transparentNormal
    onView: self.view,                 // The view to overlay the spinner on
    description: "Fetching data...",   // Optional subtitle
    title: "Please Wait"               // Optional title
)


HIDE SPINNER:
RSSpinnerView.hideSpinner()


ADD SPINNER: CUSTOM:
let customSpinner = RSSpinnerView(
    spinnerType: .medium,
    spinnerColor: .light,
    onView: self.view,
    description: "Processing..."
)
customSpinner.addSpinner()

// Later...
customSpinner.removeSpinner()



---

#### 3. ✅ **Customization**

Explain available styles and options.

```markdown
## 🎨 Customization

| Option            | Description                                     |
|-------------------|-------------------------------------------------|
| `SpinnerType`     | `.micro`, `.small`, `.medium`, `.large`, `.full`|
| `SpinnerShade`    | `.light`, `.dark`, `.transparentDark`, `.transparentNormal` |
| `Title`           | Optional title shown above the spinner         |
| `Description`     | Optional description shown below the spinner   |
| `Animation Speed` | Fixed for now, can be tweaked via `animateCircle(duration:)` |



## 📄 License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.


## 🤝 Contributing

Contributions, bug reports, and feature requests are welcome! Feel free to open an issue or submit a pull request.
