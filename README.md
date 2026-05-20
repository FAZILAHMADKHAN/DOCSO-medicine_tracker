# 💊 Docso – Medicine Order Tracker

A clean, scalable, and production-ready **Flutter application** for tracking medicine orders. Built as a Flutter Developer assignment for **Docso** ([docso.in](https://www.docso.in)).

---

## ✨ Features

| Feature | Description |
|---|---|
| 📋 **Order List** | Displays 20 medicine orders spanning the past year with status indicators, item previews, and pricing |
| 🔍 **Smart Search** | Search across Order ID, medicine name, or delivery status in real-time |
| 📄 **Detailed Invoice** | Tap any order to view a full breakdown — each item's MRP, discount %, selling price, and line total |
| 🧾 **Bill Summary** | Grand total computation with itemized MRP, discounts, delivery fee, and packaging charges |
| 📊 **Status Timeline** | A polished vertical timeline showing the complete lifecycle of an order (Placed → Delivered) |
| 🔄 **Pull to Refresh** | Swipe down to refresh the order list with a simulated loading state |
| 💰 **Savings Banner** | "You saved ₹XX on this order!" — highlights discount value on each order |

---

## 🏗️ Architecture & Design Decisions

### State Management
**Provider** — Chosen for its simplicity, official Flutter endorsement, and scalability for this use case.

### Architecture Pattern
**MVVM (Model-View-ViewModel)** — Clean separation:
- `models/` — Data classes with computed billing properties
- `providers/` — Business logic + mock data (ViewModel layer)
- `screens/` — Full-page views
- `widgets/` — Reusable UI components

### Data Source
**Local mock data** — 20 realistic Indian medicine orders with:
- Real Indian medicine names (Dolo 650, Azithral 500, Thyronorm, Ecosprin, etc.)
- Real pharmaceutical manufacturers (Abbott, Cipla, Sun Pharma, etc.)
- Indian pricing in ₹ with realistic MRP and discount percentages
- Multiple delivery addresses and payment methods (UPI, COD, Razorpay)

### UI/UX
- **Docso brand colors** (Blue `#1A73E8` + Green accent `#34A853`)
- **Google Fonts (Inter)** for clean, modern typography
- **Material 3** design system
- Single-user perspective ("My Orders") — not an admin dashboard
- Active orders highlighted with blue border
- Status chips with contextual icons

---

## 📂 Project Structure

```
lib/
├── main.dart                         # App entry, theme, brand colors
├── models/
│   └── order.dart                    # MedicineItem + MedicineOrder models
├── providers/
│   └── order_provider.dart           # State management + mock data
├── screens/
│   ├── home_screen.dart              # Order list + search
│   └── order_details_screen.dart     # Invoice + timeline + bill
└── widgets/
    ├── order_card.dart               # Order list item
    └── status_timeline.dart          # Vertical status progression
```

---

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK `>=3.0.0` ([Install Flutter](https://flutter.dev/docs/get-started/install))
- Chrome browser (for web) or Android device/emulator

### Steps

```bash
# 1. Clone the repository
git clone https://github.com/<your-username>/medicine_tracker.git
cd medicine_tracker

# 2. Install dependencies
flutter pub get

# 3. Run on Chrome (Web)
flutter run -d chrome

# 4. Or build an APK (Android)
flutter build apk --release
```

The APK will be generated at `build/app/outputs/flutter-apk/app-release.apk`.

---

## 📸 Screenshots

> Screen recording / screenshots will be added here after build verification.

---

## 🔧 Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x |
| Language | Dart |
| State Management | Provider |
| Typography | Google Fonts (Inter) |
| Design System | Material 3 |
| Data | Local mock JSON-like data |

---

## 📈 Scalability Notes

- **API-ready**: The `OrderProvider.fetchOrders()` method simulates a network call and can be trivially replaced with a real HTTP client (e.g., `dio` or `http`).
- **Model-driven**: All billing computations (subtotal, discounts, grand total) are encapsulated in the `MedicineOrder` model, not the UI layer.
- **Search extensibility**: The search logic supports multiple fields and can be extended to include date range filters, status filters, or sort options.

---

## 📝 License

This project was built as an assignment submission for Docso.
