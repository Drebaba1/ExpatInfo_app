# expat_info

This is a Flutter app that allows users to input and submit personal information through a form. The app supports authentication using either Google or Facebook, and the submitted data is stored in a database.

## Features

- **Authentication:**

  - Users can sign in using their Google or Facebook accounts.

- **Form:**

  - A simple well-designed form with fields for personal information, including Name, Email, Phone Number, Date of Birth, Address, Phone Number, Gender, language .
  - Form validation to ensure required fields are filled and data entered is in the correct format.

- **Database Integration:**

  - Connected to Firebase Database to store and retrieve submitted personal information.

- **Data Display:**

  - A dedicated screen for users to view the information they have submitted.

- **Additional Features (Optional):**
  - User can Edit or update user information.
  - Fetching user details(email, name and profile picture)from provider used
  - Saving data to Shared Preferences
  - Delete user data.

## Getting Started

These instructions will help you set up and run the project on your local machine.

### Prerequisites

To run this app, you will need the following:

• Flutter development environment
• Firebase account
• Google Sign-In provider
• Facebook Login app

## Setup Authentication

1. Google Sign-In
     • Follow the Firebase documentation to [Add Google Sign-In to Your Android App](https://firebase.google.com/docs/auth/android/google-signin) and [Add Google Sign-In to Your iOS App](https://firebase.google.com/docs/auth/ios/google-signin).

     • Update your Firebase project configuration.

2. Facebook Sign-In
To enable Facebook Sign-In:

• Follow the Firebase documentation to [Add Facebook Sign-In to Your Android App](https://firebase.google.com/docs/auth/android/facebook-login) and [Add Facebook Sign-In to Your iOS App](https://firebase.google.com/docs/auth/ios/facebook-login).

• Update your Firebase project configuration.

3.  Database
    Firestore
    To connect to Firestore:

• Ensure that Firestore is enabled for your Firebase project.
• Use the [cloud_firestore](https://pub.dev/packages/cloud_firestore) package to interact with Firestore in your Flutter app.

    ```
    dependencies:
       cloud_firestore: ^3.3.0
    ```

## Installation

• To run this code, clone the repository and import into local machine

```
git clone https://github.com/Drebaba1/ExpatInfo_app.git
```
• To get the neccesary dependencies,
```
run flutter pub get
```
• To build the app for testing,
```
flutter run
```

## APK file

You can download the APK file for this project [here]()

## Demo

• View the Project Demo here [Demo](https://appetize.io/app/ourzls2klgnf3bstrvzi2qljt4?device=pixel7&osVersion=13.0)
