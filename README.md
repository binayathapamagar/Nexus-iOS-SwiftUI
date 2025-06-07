## 📱 Nexus iOS App

**Nexus** is a modern iOS social media application developed in **Swift** using **SwiftUI**, inspired by platforms like **Twitter** and **Threads**. It empowers users to post updates (text + images), follow others, like and comment on posts, and receive real-time notifications. The app uses **Firebase** for backend infrastructure, enabling real-time sync and secure user authentication.

---

## 📜 Table of Contents

- [📷 Screenshots](#-screenshots)  
- [🚀 Features](#-features)  
- [🧰 Tech Stack](#-tech-stack)  
- [📥 Installation](#-installation)  
- [💻 Usage](#-usage)  
- [👨‍💻 Credits](#-credits)  
- [📄 License](#-license)  
- [📬 Contact](#-contact)

---

## 📷 Screenshots

<img src="Screenshots/main.png" width="300">  
<img src="Screenshots/secondary.png" width="300">

---

## 🚀 Features

- 📝 Create posts with text and images  
- 👥 Follow/unfollow users and view their updates in your feed  
- ❤️ Like and 💬 comment on posts to engage with the community  
- 🔔 Real-time push notifications via Firebase Cloud Messaging (FCM)  
- 👤 Manage your profile (username, bio, profile picture)  
- 🌓 Light & Dark mode support  
- 🔒 Secure sign-up/sign-in using Firebase Authentication  
- 🗨️ **Coming Soon**:
  - Direct messaging between users  
  - 🎥 Video upload support for posts  

---

## 🧰 Tech Stack

### 📱 iOS Development

- **Swift** & **SwiftUI** – Declarative and responsive UI development  

### ☁️ Firebase (Google Cloud Platform)

- 🔐 **Firebase Authentication** – Email/password and anonymous sign-in  
- 🔄 **Cloud Firestore** – Real-time NoSQL database  
- ☁️ **Firebase Storage** – Upload and manage media files  
- 📡 **Firebase Cloud Messaging** – Push notification delivery  

---

## 📥 Installation

1. **Clone the repository**:
    ```bash
    git clone https://github.com/your-username/nexus-ios.git
    ```

2. **Navigate to the project folder**:
    ```bash
    cd nexus-ios
    ```

3. **Open the project in Xcode**:
    ```bash
    open Nexus.xcworkspace
    ```

4. **Install dependencies** (if using CocoaPods):
    ```bash
    pod install
    ```

5. **Configure Firebase**:
    - Create a Firebase project  
    - Register your iOS app  
    - Download `GoogleService-Info.plist` and add it to the project  
    - Enable **Firestore**, **Authentication**, **Storage**, and **Messaging**

6. **Build and run the app**:
    ```bash
    ⌘ + R
    ```

---

## 💻 Usage

- Sign up or log in using Firebase Authentication  
- Post updates (text + image)  
- Interact with posts via likes and comments  
- Follow/unfollow users  
- Receive real-time push notifications  
- Edit your profile and upload a profile picture  

---

## 👨‍💻 Credits

Developed by **Binaya Thapa Magar**  
- GitHub: [@binayathapamagar](https://github.com/binayathapamagar)

---

## 📄 License

This project is licensed under the **MIT License** – see the [LICENSE](LICENSE) file for details.

---

## 📬 Contact

For inquiries or feedback, feel free to reach out via GitHub or your preferred contact method.
