# Employee Directory App

A clean and simple employee management app built with Flutter, using GetX for state management and Hive for local data persistence.

---

## 📱 Overview

This app allows users to:

- 🧑‍💼 View a list of employees (fetched from a dummy API)
- 🔍 Search employees by name
- ➕ Add a new employee using a form
- 💾 Store data locally (offline) using Hive
- 🌐 Upload profile pictures using Cloudinary when online

---

## 🧠 Why I Built It This Way

When I read the assignment, I immediately thought: *“How would I structure this if it were going to production?”*  
So I decided to:

- Use **Clean Architecture** for separation of concerns
- Pick **GetX** because of its simplicity and reactivity
- Add **Hive** to allow offline use and faster local access
- Integrate **Cloudinary** for image uploads (with fallback if offline)

I’ve written and structured every line of code myself. No code generators, no templates — just pure Dart and Flutter.

---

## 🧱 Architecture

├── core/ → Base services, configs, API, local DB
├── features/
│ └── employee/ → Employee module (data, domain, UI, controllers)
├── bindings/ → App-wide GetX bindings
├── main.dart

yaml
Copy
Edit

- `GetX` is used for controller injection, state updates, and navigation
- `Hive` is used via a `ILocalDatabaseService<T>` abstraction layer
- `Cloudinary` used via custom uploader logic (if internet is available)

---

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/Ali1qqq/employee_directory_app.git
cd employee_directory_app
2. Install dependencies
bash
Copy
Edit
flutter pub get
3. Generate Hive adapters
bash
Copy
Edit
flutter pub run build_runner build
4. Run the app
bash
Copy
Edit
flutter run
