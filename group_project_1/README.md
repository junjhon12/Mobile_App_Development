# group_project_1

Running the App
To launch the app on an emulator or physical device:

Connect a Device or Launch an Emulator:

Connect an Android or iOS device via USB.
Start an Android or iOS emulator.
Run the App:

bash
Copy code
flutter run
Using the App
Home Screen
The home screen displays your total income in a highlighted area at the top. Below it are four widgets that provide quick navigation to other sections of the app.

Features
Income Page
Add Income: Enter an income amount and tap the Add button to update your total income.
Remove Income: Use the Remove button to subtract income if needed.
Income History: A list below shows each added or removed income entry.
Savings Page
Set Savings Goal: Tap the edit icon in the app bar to set a custom savings goal.
Add/Remove Savings: Enter a savings amount and use the Add or Remove buttons to update your savings.
Goal Progress: View progress towards your goal via a progress bar.
Savings History: A list below shows each added or removed savings entry.
Expenses Page
Add Expense: Enter an expense amount and tap the Add button to update your total expenses.
Remove Expense: Tap Remove to subtract an expense if needed.
Expense History: A list below shows each added or removed expense entry.
Investment Page
Add Investment: Enter an investment amount and tap the Add button to update your total investments.
Remove Investment: Tap Remove to subtract an investment amount if needed.
Investment History: A list below shows each added or removed investment entry.
Notes
Data Persistence: The app uses Shared Preferences to save data locally on your device.
Goal Setting: Goal setting is available in the Savings Page, allowing you to track your progress.
Troubleshooting
App not running? Make sure your device or emulator is connected and recognized by running flutter devices.
Dependencies not installing? Run flutter pub get again to ensure all dependencies are installed.
For further information on Flutter development, visit the Flutter documentation.

sql
Copy code

To add this file:
1. Open your project directory.
2. Create a new file named `README.md`.
3. Paste the instructions above into the file and save it.

This `README.md` file provides clear setup, usage, and troubleshoo