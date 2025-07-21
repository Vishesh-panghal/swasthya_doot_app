# Swasthya Doot 🩺📱

![Flutter](https://img.shields.io/badge/Flutter-3.0-blue?logo=flutter)
![Firebase](https://img.shields.io/badge/Backend-Firebase-orange?logo=firebase)
![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)

**Swasthya Doot** is a mobile healthcare assistant app built using **Flutter**, designed to empower ASHA/ANM workers in rural India. The app leverages voice-based chat, AI-driven health guidance, and OCR to support frontline healthcare workers in delivering better services.

---

## 🌟 Features

- 🔊 **Voice-based Chat Assistant (Ask Didi)**  
  Multilingual AI assistant (Hindi & English) to answer healthcare-related queries.

- 📷 **OCR for Medical Documents**  
  Extracts and interprets handwritten or printed text from prescriptions and pill strips.

- 👪 **Patient Record Management**  
  Create and manage family-wise health records with individual member details.

- 🔐 **OTP-based Authentication**  
  Secure login system using phone number verification.

- 🌐 **Real-time Cloud Integration (Firebase)**  
  Seamless data syncing and storage for ASHA/ANM workers using Firebase.

---

## 📦 Tech Stack

- **Frontend:** Flutter (Dart)
- **Backend:** FastAPI (Python)
- **AI:** ChatGPT API, ONNX MiniLM, Text Classification (Offline)
- **Database & Auth:** Firebase (Firestore, Authentication)
- **OCR:** Google ML Kit for Text Recognition

---

## 🚀 Setup Instructions

1. **Clone the Repo**
   ```bash
   git clone https://github.com/Vishesh-panghal/swasthya_doot_app.git
   cd swasthya_doot
   ```

2. **Install Flutter Packages**
   ```bash
   flutter pub get
   ```

3. **Run the App**
   ```bash
   flutter run
   ```

4. **Set Up Firebase**
   - Add your `google-services.json` (Android) and/or `GoogleService-Info.plist` (iOS) to the respective folders.
   - Configure Firebase in `main.dart`.

---

## 📂 Project Structure

```
lib/
├── pages/
│   ├── dashboard.dart
│   ├── detect_screen.dart
│   └── ask_didi.dart
├── widgets/
│   └── common_widget.dart
├── models/
├── main.dart
```

---

## 🔍 How It Works

1. **User Logs In** using OTP-based authentication via Firebase.
2. **Asks Health Questions** through Ask Didi, powered by ChatGPT and MiniLM-based classifier.
3. **Scans Prescriptions or Pills** via OCR (Google ML Kit) to extract medicine name, expiry, and usage.
4. **Stores Patient Records** in Firestore with family and individual member tracking.

---

## 📌 Future Roadmap

- [ ] Integration of RAG-based backend for Ask Didi
- [ ] Offline mode support
- [ ] ASHA/ANM Analytics Dashboard
- [ ] Voice input for form filling
- [ ] Regional language translations

---

## 🤝 Contributing

We welcome contributions! Feel free to fork the repo and submit pull requests. Please follow the standard Flutter/Dart formatting guidelines.

---

## 📜 License

This project is licensed under the MIT License.

---

## 🔗 Connect with Me

- [LinkedIn: Vishesh Panghal](https://www.linkedin.com/in/vishesh-panghal/)

## 🙌 Acknowledgements

- OpenAI for GPT APIs  
- Firebase for backend services  
- Google ML Kit for OCR  
- All ASHA and ANM workers who inspired this project ❤️