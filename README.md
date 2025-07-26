<p align="center">
  <img src="Media/Icon.png" alt="Logo" width="80" height="80">
  <h2 align="center">
    Know Your Customer
  </h2>
</p>

<img src="https://github.com/matt-novoselov/matt-novoselov/blob/7bbed7f0e7e2ee616ec2ccbb07931f5b15a8e128/Files/SVGs/Badges/Platforms/ios18.svg" alt="" style="height: 30px">  <img src="https://github.com/matt-novoselov/matt-novoselov/blob/58a1be3d03d2558b81e787a0a13927faf3465be2/Files/SVGs/Badges/Frameworks/SwiftUI.svg" alt="" style="height: 30px"> 


A demo of a Know Your Customer (KYC) onboarding flow that adapts to country-specific rules defined in YAML. The goal is to
demonstrate dynamic form rendering and validation in a clean, test-driven codebase.

![Peaks-GIF-_afvkslxXR6g_](https://github.com/user-attachments/assets/070c353e-af8b-443b-a467-bdd1c49567fd)


## Features

### Country Selection

Users can choose a country (e.g., NL, US, DE) to load the corresponding KYC form configuration.

### Dynamic Form Rendering

Forms are generated at runtime based on YAML configs, supporting field types like text, number, and date.

### Field Validation

Each field supports validation rules such as required, regex, min/max length or value, with inline error messages.

### Country-Specific Logic

For the Netherlands, specific fields (first name, last name, birth date) are fetched from a mocked API and shown as read-only.

### Form Submission

After successful validation, the app outputs a summary of the collected form data.

### Testing
- Swift Testing to validate YAML decoding, Dynamic form generation and Validation rules.
- XCTest UI Tests end-to-end flow from country selection to summary.

<br>

The app incorporates accessibility features to assist our users, including support for VoiceOver.

## Requirements
- iOS 18.0+
- Xcode 16.0+

## Installation
1. Open Xcode.
2. Click on **"Clone Git Repository"**.
3. Paste the following URL: `https://github.com/matt-novoselov/Know-Your-Customer`
4. Click **"Clone"**.
5. Build and run the project in Xcode.

## Dependencies
- [Yams](https://github.com/jpsim/Yams) - Swift YAML parser framework.
- [SwiftLint](https://github.com/SimplyDanny/SwiftLintPlugins) - A tool to enforce Swift style and conventions.

<br>

## Credits
Distributed under the MIT license. See **LICENSE** for more information.

The app ships with the Dazzed font by © 2014-2025 Display Type Foundry. Al rights reserved.

Developed with ❤️ by Matt Novoselov
