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
- Phone Verification via OTP
- Invalid OTP Verification Code Alert

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

### Phone Verification via OTP
When users enter a valid phone number, they are taken to a verification screen that prompts them to enter a six-digit One Time Passcode (OTP) in an OTP-style textfield. If the code is entered in correctly, they are taken to PiggyBank's home screen.

### Resending The Verification Code
If the user forgets the code that was sent to them or would like a new verification code, hitting the **Resend Verification Code** button on the verification screen will send them a new OTP.

### Invalid OTP Verification Code Alert
When users mistype their code, they are presented with an alert that have entered an invalid code, erases the invalid code, and allows them to re-enter the code.

## Feature Implementations

PiggyBank's splash screen was created as a separate SwiftUI view called `SplashScreenView`. To prevent the splash screen from staying onscreen for a long period of time, a toggle called `splashScreenIsActive` and a `DispatchQueue` were used to display the splashscreen for 2 seconds. After 2 seconds, the login page is displayed. A code snippet of the splash screen transition is down below:

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

The number keypad dismissal operates on a `@FocusState` toggle `numberIsFocused` that is set to true when the user taps on the textfield to enter their phonenumber to display the number keypad. Dismissing the number keypad when pressing the **Get Verification Code** button or tapping anywhere on the app required the use of the `.onTapGesture` modifier to the app's overall view that sets `numberIsFocused` to false.

PiggyBank's "As You Type" phone number formatting was implemented through the use of the `.onChange` modifier and the **PhoneNumberKit** Swift framework. PhoneNumberKit's PartialFormatter can automatically format phone numbers. The following code snippet reassigns the `phoneNumber` variable the formatted phone number as the user types it in:

```swift 
     //Formats the phone number a user types in as (###)-###-####.
            .onChange(of: phoneNumber) {
                phoneNumber = PartialFormatter().formatPartial(phoneNumber)
            }
```
The Invalid Phone Number alert was created using an `.alert` modifier and a toggle called `invalidNumberAlert`. To display the alert, PhoneNumberKit's parser attempts to parse the phone number the user entered (as shown in the code snippet below). If the parsing fails, that triggers the `invalidNumberAlert` to be true and display the alert.

```swift
            do {
                let parsedNumber = try phoneNumberKit.parse(phoneNumber)
            } catch {
                invalidNumberAlert = true
            }
```

Sending the verification code to the entered phone number is done by an API that contains a built-in method for verification called `sendVerificationToken()`. When the user clicks the **Get Verification Code** button, a `Task` is invoked that uses async/await to determine if `sendVerificationToken()` was successful at verifying the phone number (as shown in the code snippet below). 

**Note**: The phone number must be stored in an E164 format for `sendVerificationToken()` to operate.

```swift
            Task {
                do {
                    let parsedNumber = try phoneNumberKit.parse(phoneNumber)
                    e164PhoneNumber = phoneNumberKit.format(parsedNumber, toType: .e164)
                    let _ = try await Api.shared.sendVerificationToken(e164PhoneNumber: e164PhoneNumber)
                    showVerificationView = true
                } catch  {
                    invalidNumberAlert = true
                }
            }
        }
```

The navigation for PiggyBank's different screens is done using SwiftUI's `NavigationStack` and `.navigationDestination` modifier that navigates to the appropriate screen based on a toggle of whether to display the new screen. This also allows user to navigate back to the Login screen from the Verifications creen if they entered a wrong phone number. The code snippet below shows an example of how PiggyBank navigates from the Login screen to the Verification screen.

```swift 
            .navigationDestination(isPresented: $showVerificationView) {
                VerificationView()
            }
```

The implementation for the OTP-style textfields uses six textfields each given their own tag. An optional `@FocusState` called `isFocusedOnField` is used to keep track of which textfield the cursor is on. To account for mistyping the verification code, in the `.onchange` modifier, there are checks to account for moving the cursor forward and backward (as shown in the code sample below). 

The cases are as follows:
- **Case 1**: If a textfield has the backspace character along with the digit the user types and the index is less than five, the cursor will move forward
- **Case 2**: If the textfield is empty and the index is not in the first position of the array storing the entered digits, before deletion, the backspace character is added and the cursor moves to the previous textfield.
- **Case 3**: When the user is done typing the code and the last textfield has a count of two to account for the backspace character and the digit, `verifyOTPCode()` is called to check if the OTP code entered is valid.

```swift
        .onChange(of: enteredDigits[index]) {
            /* When a textfield has the backspace character + the entered digit
            and the index is less than five, move to the next textfield.*/
            if enteredDigits[index].count == 2 && index < numOfOTPFields - 1 {
                isFocusedOnField = (isFocusedOnField ?? 0) + 1
              
            /* Otherwise if the textfield if empty and the index is not the first index of the array,
                before deletion, add the backspace character, delete the digit, and move back one textfield.*/
            } else if enteredDigits[index].isEmpty && index > 0 {
                enteredDigits[index] = backSpace
                isFocusedOnField = (isFocusedOnField ?? 0) - 1
            }
            
            /* When the cursor is on the last textfield and the count for the textfield is 2
            (which contains the backspace character + the entered digit), verify the code the user entered.*/
            if index == numOfOTPFields - 1 && enteredDigits[index].count == 2 {
                verifyOTPcode()
            }
    }
```

Verifying the entered code uses a similar `Task` structure as validating a user's phone number using the given API method `checkVerificationToken()`. A string containing the full verification code the user entered in is passed into this method along with their phone number, toggling a boolean for navigating to the Home screen if the code was valid. A loading icon tiggered by the boolean `isLoading` appears as `checkVerificationToken()` processes the code and disappears upon the method's successful completion.

```swift
            Task {
                do {
                    let _ = try await Api.shared.checkVerificationToken(e164PhoneNumber: e164PhoneNumber, code: code)
                    showHomeView = true
                    isLoading = false
                } catch  {
                    invalidCodeAlert = true
                    isLoading = false
                    enteredDigits = [String](repeating: backspace, count: numOfOTPFields)
                }
            }
```
In terms of invalid verification code checking, `invalidCodeAlert` (as shown in the above code snippet) and displays a dissmable alert and erases the OTP textfield to allow the user to re-enter the code.

Resending the verification code follows the same `Task` logic as the sending the verification code. Using the async/await structure, if `sendVerificationToken()` was successful, it will send a new verification code to the entered phone number.
