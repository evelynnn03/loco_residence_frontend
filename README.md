# Loco Home Residential App
A Flutter application designed for residential communities to manage complaints, bookings, payments, visitor check-ins, and emergency services access. This app integrates an advanced AI-driven system to analyze complaint images/words for sensitivity, relations, and similarities, helping both residents and community staff streamline interactions and improve the quality of service.

Link to the backend repository: https://github.com/evelynnn03/loco_residence_backend.git

## Table of Contents
* [Overview](#overview)
* [Key Features](#key-features)
* [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Running the App](#running-app)
* [Folder Structure](#folder-structure)

<a name="overview"></a>
## Overview
The Resident Management App provides a centralized platform for residents to submit complaints, book facilities, make payments, manage visitor check-ins, and reach out to emergency services with ease. Designed to enhance community living, the app offers a complaint system with AI-driven analysis, facility booking, a secure payment gateway, and visitor management features for security staff.

Residents can quickly access emergency or service contacts, such as guards, police, etc, by simply tapping on their phone numbers within the app, ensuring swift communication in urgent situations.

<a name="key-features"></a>
## Key Features
* Complaint System with AI Analysis: Residents can submit complaints with accompanying images. The AI system provides:

  - Image/Word Sensitivity Analysis: Detects potentially sensitive content or urgent keywords to prioritize immediate attention.
  - Relation and Similarity Detection: Compares new complaints with existing records to identify recurring issues, helping management allocate resources more efficiently.

* Facility Booking: Residents can book community facilities (e.g., meeting rooms, sports courts) based on their availability, selected dates, times, and specific rooms or sections.

* Payment System: A secure payment feature that allows residents to make payments directly within the app. Card details can be saved for future transactions, making payments convenient and quick.

* Visitor Management: Security guards can scan a QR code to check visitors in and out, with detailed visitor information available for effective tracking and monitoring.

* Emergency Contact Access: Residents can quickly reach out to emergency services, maintenance, or security guards by tapping on phone numbers displayed within the app, ensuring fast access to help during emergencies.

<a name="getting-started"></a>
## Getting Started
<a name="prerequisites"></a>
### Prerequisites
Ensure you have the following tools installed:

* [Flutter SDK](https://docs.flutter.dev/get-started/install)
* Dart SDK
* An IDE (e.g., [Android Studio](https://developer.android.com/studio) or [Visual Studio Code](https://code.visualstudio.com/))

<a name="installation"></a>
### Installation
1. Clone the repository:

```
* git clone https://github.com/evelynnn03/loco_residence_frontend.git
* cd loco_residence_frontend
```

2. Install dependencies:

```
* flutter pub get
```
<a name="running-app"></a>
### Running the App
1. Launch the app:

```
* flutter run
```

2. For iOS Users:

* Open the iOS project in Xcode to configure necessary permissions:
* [Configure iOS development](https://docs.flutter.dev/get-started/install/macos/mobile-ios#configure-ios-development) 
```
- open ios/Runner.xcworkspace
```

3. For Android Users:

* Ensure an emulator is running or a device is connected.

<a name="folder-structure"></a>
## Folder Structure
### An overview of the main folders:

* lib/guard: Main application code for guard screen
* lib/src: Main application code for resident screen
* assets/: Assets like images or fonts.

## Contributors
This project is contributed by the following people:
* https://github.com/doodledaron
* https://github.com/evelynnn03
