# 📱 Offline-First Notes App (Flutter)

## 🚀 Overview
This project demonstrates an offline-first architecture in Flutter using local caching, a persistent sync queue, retry logic, and idempotent operations with Firebase as backend.

The app allows users to:
- Add, edit, and like notes offline
- Store actions locally
- Sync reliably when internet is available

---

## 🧠 Approach

- Used **Hive** for local storage (fast, lightweight)
- Implemented a **persistent queue** for offline actions
- Sync handled using a **SyncService**
- Used **Firebase Firestore** as backend
- Ensured **idempotency** using document IDs
- Implemented **retry with backoff**
- Added **logs and counters** for observability

---

## 🏗️ Architecture

- `NoteController` → handles UI state + local operations  
- `SyncService` → processes queue and syncs with server  
- `Hive` → local database (notes + queue)  
- `Firebase Firestore` → backend storage  

---

## ✅ Features

- Local-first UX (instant data from cache)
- Offline add, edit, like
- Queue-based sync system
- Retry with backoff (1 retry)
- Idempotent writes (no duplicates)
- Auto sync when internet reconnects
- Sync status indicator (Pending / Synced)
- Observability logs + counters

---

## ⚖️ Tradeoffs

- Used **Last-Write-Wins (LWW)** for conflict resolution
- Basic retry instead of exponential backoff
- No background service for sync

---

## ⚠️ Limitations

- No authentication
- No advanced conflict merge strategy
- No background sync (only app-triggered)
- No TTL cache

---

## 🔥 Conflict Strategy

Implemented **Last-Write-Wins** using updated timestamps.

Latest update overwrites previous data for simplicity and consistency.

---

## 🧪 How to Run

1. Extract ZIP
2. Open project in VS Code / Android Studio
3. Run:
   flutter pub get
4. Connect device/emulator
5. Run:
   flutter run

---

## 🔥 Firebase Setup

- Firebase already configured
- `google-services.json` included in:
  android/app/
- No additional setup required

---

## 🧪 Verification

### ✅ Scenario 1: Offline Add Note
- Turn OFF internet
- Add note → shows "Pending"
- Turn ON internet
- Tap sync → becomes "Synced"

---

### ✅ Scenario 2: Offline Edit / Like
- Turn OFF internet
- Edit or like note
- Turn ON internet
- Sync → updates successfully

---

### ✅ Scenario 3: Retry Logic
- Turn OFF internet
- Trigger sync → FAIL
- Turn ON internet
- Sync again → SUCCESS

---

### ✅ Logs (Evidence)
