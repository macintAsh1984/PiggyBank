# PiggyBank

Created by Ashley Valdez \
Student ID: 919741751

## About PiggyBank
PiggyBank is mobile wallet app that allows you to safely store you debit and credit cards at your best interest and keep your piggybank happy and full (pun intended) 🐷💰!

## App Design
PiggyBank follows a playful design that represents the happiness and joy of having a physical piggybank. Physical piggybanks are pink, cute, fun, and sturdy! When opening the app, users are welcomed with a launch screen containing PiggyBank's adorable app logo drawn by Ashley. PiggyBank uses a pink color scheme to resemble the colors of a physical piggybank. The color scheme can be accessed in the **Assets** folder of PiggyBank's Xcode project. PiggyBank also uses the CandyBeans font to achieve its fun, cute look! The CandyBeans Font is located in the **Fonts** folder or can be downloaded [here](https://www.dafont.com/candy-beans.font?back=theme).

## App Features
PiggyBank contains a login page with the following features
- Country Code Selection
- Number Keypad Dismissal
- Phone Number Formatting
- Invalid Phone Number Alert

### Country Code Selection
PiggyBank's login screen displays a dropdown menu listing country codes that users can select from.

<img src="https://github.com/macintAsh1984/PiggyBank/assets/84110959/305d9093-1a3f-4ac5-86c7-e4879c2275ef" width="322.5" height="699" />

### Number Keypad Dismissal
When the textfield to enter a phone number is selected, a numberkey pad appears for users to enter a phone number to login. Users can tap out of the textfield or click the **Get Verification Code** button to dismiss the number keypad.

<img src="https://github.com/macintAsh1984/PiggyBank/assets/84110959/8785fc69-d10f-4100-a455-f880821809e3" width="322.5" height="699" />

### Phone Number Formatting
PiggyBank's login page also formats user's phone numbers as they type it into the textfield.

<img src="https://github.com/macintAsh1984/PiggyBank/assets/84110959/0036a853-90f2-45b0-8503-4b3b3260115c" width="322.5" height="699" />

### Invalid Phone Number Alert
When users mistype their phone, whether they enter accidentally hit **Get Verification Code** button by mistake or enter too many or too little digits, they are presented with an alert that have entered an invalid phone number.

<img src="https://github.com/macintAsh1984/PiggyBank/assets/84110959/d12d706c-89bb-4097-a1ae-dc54f9a8698d" width="322.5" height="699" />

## Feature Implementations

PiggyBank's splashscreen was created as a separate SwiftUI view called `SplashScreenView`. To prevent the splashscreen from staying onscreen for a long period of time, a toggle called `splashScreenIsActive` and a `DispatchQueue` were used to display the splashscreen for 2 seconds. After 2 seconds, the login page is displayed. A code snippet of the splash screen transition is down below:

```swift
            .onAppear {
                //The splashscreen will stay onscreen for 2 seconds.
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.splashScreenIsActive = true
                    }
                }
            }
```

The dropdown menu for country code selection was created by using SwiftUI's [Picker](https://developer.apple.com/documentation/swiftui/picker) that selects from an array called 'countryCodes' that contains the US country code seen as the default option.

The number keypad dismissal operates on a `@FocusState` toggle `numberIsFocused` that is set to true when the user taps on the textfield to enter their phonenumber to display the number keypad. Dismissing the number keypad when pressing the **Get Verification Code** button or tapping anywhere on the app required the use of the `.onTapGesture` modifer to the app's overall view that sets `numberIsFocused` to false.

PiggyBank's "As You Type" phone number formatting was implemented through the use of the `.onChange` modifier and the **PhoneNumberKit** Swift framework. PhoneNumberKit's PartialFormatter can automatically format phone numbers. The following code snippet reassigns the `phoneNumber` variable the formatted phone number as the user types it in:

```swift 
     //Formats the phone number a user types in as (###)-###-####.
            .onChange(of: phoneNumber) {
                phoneNumber = PartialFormatter().formatPartial(phoneNumber)
            }
```
