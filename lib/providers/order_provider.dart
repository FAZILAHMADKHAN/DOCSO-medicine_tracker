import 'package:flutter/material.dart';
import '../models/order.dart';

/// Provider that manages medicine orders for the current logged-in user.
///
/// Uses mock data to simulate a real API response. Supports search
/// across order ID, medicine names, and status. Implements pull-to-refresh
/// via [fetchOrders].
class OrderProvider with ChangeNotifier {
  List<MedicineOrder> _orders = [];
  List<MedicineOrder> _filteredOrders = [];
  bool _isLoading = false;
  String _searchQuery = '';

  List<MedicineOrder> get orders =>
      _searchQuery.isEmpty ? _orders : _filteredOrders;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;

  // ──────────────────────────────────────────────
  //  Fetch / Refresh
  // ──────────────────────────────────────────────

  Future<void> fetchOrders() async {
    _isLoading = true;
    notifyListeners();

    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 800));

    _orders = _generateMockOrders();
    _applySearch();
    _isLoading = false;
    notifyListeners();
  }

  // ──────────────────────────────────────────────
  //  Search
  // ──────────────────────────────────────────────

  void searchOrders(String query) {
    _searchQuery = query;
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredOrders = _orders;
      return;
    }
    final q = _searchQuery.toLowerCase();
    _filteredOrders = _orders.where((order) {
      // Search by order ID
      if (order.id.toLowerCase().contains(q)) return true;
      // Search by medicine name
      if (order.items.any((i) => i.name.toLowerCase().contains(q))) return true;
      // Search by status
      if (_statusLabel(order.status).toLowerCase().contains(q)) return true;
      return false;
    }).toList();
  }

  String _statusLabel(OrderStatus s) {
    switch (s) {
      case OrderStatus.placed:
        return 'Placed';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  // ──────────────────────────────────────────────
  //  Mock Data (20 orders spanning ~1 year)
  // ──────────────────────────────────────────────

  List<MedicineOrder> _generateMockOrders() {
    final now = DateTime.now();
    return [
      // ── Recent orders ─────────────────────────
      MedicineOrder(
        id: 'DOC-20251',
        orderDate: now.subtract(const Duration(hours: 2)),
        status: OrderStatus.confirmed,
        deliveryAddress: '12, MG Road, Lashkar, Gwalior - 474001',
        paymentMethod: 'UPI - Google Pay',
        deliveryFee: 0,
        items: [
          MedicineItem(name: 'Dolo 650mg', dosageForm: 'Strip of 15 Tablets', manufacturer: 'Micro Labs Ltd', quantity: 2, mrp: 30.0, discount: 10),
          MedicineItem(name: 'Pan-D Capsule', dosageForm: 'Strip of 10 Capsules', manufacturer: 'Alkem Laboratories', quantity: 1, mrp: 142.0, discount: 15),
        ],
      ),
      MedicineOrder(
        id: 'DOC-20250',
        orderDate: now.subtract(const Duration(days: 1)),
        status: OrderStatus.processing,
        deliveryAddress: '12, MG Road, Lashkar, Gwalior - 474001',
        paymentMethod: 'Razorpay - Debit Card',
        deliveryFee: 25,
        items: [
          MedicineItem(name: 'Azithral 500mg', dosageForm: 'Strip of 5 Tablets', manufacturer: 'Alembic Pharma', quantity: 1, mrp: 105.0, discount: 12),
          MedicineItem(name: 'Allegra 120mg', dosageForm: 'Strip of 10 Tablets', manufacturer: 'Sanofi India', quantity: 1, mrp: 189.0, discount: 20),
          MedicineItem(name: 'Betadine Gargle', dosageForm: 'Bottle of 100ml', manufacturer: 'Win-Medicare', quantity: 1, mrp: 110.0, discount: 5),
        ],
      ),
      MedicineOrder(
        id: 'DOC-20249',
        orderDate: now.subtract(const Duration(days: 3)),
        deliveryDate: now.subtract(const Duration(days: 1)),
        status: OrderStatus.outForDelivery,
        deliveryAddress: '45, Civil Lines, Jhansi - 284001',
        paymentMethod: 'Cash on Delivery',
        deliveryFee: 0,
        items: [
          MedicineItem(name: 'Thyronorm 50mcg', dosageForm: 'Bottle of 120 Tablets', manufacturer: 'Abbott India', quantity: 1, mrp: 136.0, discount: 18),
        ],
      ),
      MedicineOrder(
        id: 'DOC-20248',
        orderDate: now.subtract(const Duration(days: 5)),
        deliveryDate: now.subtract(const Duration(days: 3)),
        status: OrderStatus.delivered,
        deliveryAddress: '12, MG Road, Lashkar, Gwalior - 474001',
        paymentMethod: 'UPI - PhonePe',
        deliveryFee: 0,
        items: [
          MedicineItem(name: 'Ecosprin 75mg', dosageForm: 'Strip of 14 Tablets', manufacturer: 'USV Pvt Ltd', quantity: 2, mrp: 18.0, discount: 5),
          MedicineItem(name: 'Atorva 10mg', dosageForm: 'Strip of 15 Tablets', manufacturer: 'Zydus Healthcare', quantity: 1, mrp: 104.0, discount: 22),
        ],
      ),
      MedicineOrder(
        id: 'DOC-20247',
        orderDate: now.subtract(const Duration(days: 8)),
        deliveryDate: now.subtract(const Duration(days: 6)),
        status: OrderStatus.delivered,
        deliveryAddress: '12, MG Road, Lashkar, Gwalior - 474001',
        paymentMethod: 'Razorpay - Credit Card',
        deliveryFee: 0,
        items: [
          MedicineItem(name: 'Shelcal 500mg', dosageForm: 'Strip of 15 Tablets', manufacturer: 'Torrent Pharma', quantity: 2, mrp: 132.0, discount: 15),
          MedicineItem(name: 'Limcee Vitamin C', dosageForm: 'Strip of 15 Tablets', manufacturer: 'Abbott India', quantity: 1, mrp: 22.0, discount: 0),
        ],
      ),

      // ── 1-2 weeks ago ─────────────────────────
      MedicineOrder(
        id: 'DOC-20246',
        orderDate: now.subtract(const Duration(days: 12)),
        deliveryDate: now.subtract(const Duration(days: 10)),
        status: OrderStatus.delivered,
        deliveryAddress: '45, Civil Lines, Jhansi - 284001',
        paymentMethod: 'UPI - Google Pay',
        deliveryFee: 0,
        items: [
          MedicineItem(name: 'Combiflam Tablet', dosageForm: 'Strip of 20 Tablets', manufacturer: 'Sanofi India', quantity: 1, mrp: 42.0, discount: 10),
          MedicineItem(name: 'Crocin Advance', dosageForm: 'Strip of 15 Tablets', manufacturer: 'GSK Pharma', quantity: 2, mrp: 28.0, discount: 5),
        ],
      ),
      MedicineOrder(
        id: 'DOC-20245',
        orderDate: now.subtract(const Duration(days: 18)),
        status: OrderStatus.cancelled,
        deliveryAddress: '12, MG Road, Lashkar, Gwalior - 474001',
        paymentMethod: 'UPI - Paytm',
        deliveryFee: 0,
        items: [
          MedicineItem(name: 'Volini Spray', dosageForm: 'Bottle of 60g', manufacturer: 'Sun Pharma', quantity: 1, mrp: 220.0, discount: 18),
        ],
      ),

      // ── 1 month ago ───────────────────────────
      MedicineOrder(
        id: 'DOC-20244',
        orderDate: now.subtract(const Duration(days: 30)),
        deliveryDate: now.subtract(const Duration(days: 28)),
        status: OrderStatus.delivered,
        deliveryAddress: '12, MG Road, Lashkar, Gwalior - 474001',
        paymentMethod: 'Razorpay - Debit Card',
        deliveryFee: 25,
        items: [
          MedicineItem(name: 'Metformin 500mg (Glycomet)', dosageForm: 'Strip of 20 Tablets', manufacturer: 'USV Pvt Ltd', quantity: 3, mrp: 30.0, discount: 12),
          MedicineItem(name: 'Telma 40mg', dosageForm: 'Strip of 15 Tablets', manufacturer: 'Glenmark Pharma', quantity: 1, mrp: 185.0, discount: 25),
          MedicineItem(name: 'Rosuvas 10mg', dosageForm: 'Strip of 15 Tablets', manufacturer: 'Sun Pharma', quantity: 1, mrp: 195.0, discount: 20),
        ],
      ),
      MedicineOrder(
        id: 'DOC-20243',
        orderDate: now.subtract(const Duration(days: 45)),
        deliveryDate: now.subtract(const Duration(days: 43)),
        status: OrderStatus.delivered,
        deliveryAddress: '45, Civil Lines, Jhansi - 284001',
        paymentMethod: 'Cash on Delivery',
        deliveryFee: 0,
        items: [
          MedicineItem(name: 'Digene Antacid Gel', dosageForm: 'Bottle of 200ml', manufacturer: 'Abbott India', quantity: 1, mrp: 116.0, discount: 10),
          MedicineItem(name: 'Gelusil MPS', dosageForm: 'Bottle of 200ml', manufacturer: 'Pfizer India', quantity: 1, mrp: 98.0, discount: 8),
        ],
      ),

      // ── 2-3 months ago ────────────────────────
      MedicineOrder(
        id: 'DOC-20242',
        orderDate: now.subtract(const Duration(days: 60)),
        deliveryDate: now.subtract(const Duration(days: 58)),
        status: OrderStatus.delivered,
        deliveryAddress: '12, MG Road, Lashkar, Gwalior - 474001',
        paymentMethod: 'UPI - PhonePe',
        deliveryFee: 0,
        items: [
          MedicineItem(name: 'Cetrizine (Cetiriz)', dosageForm: 'Strip of 10 Tablets', manufacturer: 'Dr Reddys', quantity: 2, mrp: 32.0, discount: 10),
          MedicineItem(name: 'Montair LC', dosageForm: 'Strip of 10 Tablets', manufacturer: 'Cipla Ltd', quantity: 1, mrp: 185.0, discount: 22),
        ],
      ),
      MedicineOrder(
        id: 'DOC-20241',
        orderDate: now.subtract(const Duration(days: 75)),
        deliveryDate: now.subtract(const Duration(days: 73)),
        status: OrderStatus.delivered,
        deliveryAddress: '12, MG Road, Lashkar, Gwalior - 474001',
        paymentMethod: 'Razorpay - Credit Card',
        deliveryFee: 0,
        items: [
          MedicineItem(name: 'Augmentin 625 Duo', dosageForm: 'Strip of 10 Tablets', manufacturer: 'GSK Pharma', quantity: 1, mrp: 252.0, discount: 15),
          MedicineItem(name: 'Zifi 200mg', dosageForm: 'Strip of 10 Tablets', manufacturer: 'FDC Ltd', quantity: 1, mrp: 190.0, discount: 18),
        ],
      ),
      MedicineOrder(
        id: 'DOC-20240',
        orderDate: now.subtract(const Duration(days: 90)),
        deliveryDate: now.subtract(const Duration(days: 88)),
        status: OrderStatus.delivered,
        deliveryAddress: '45, Civil Lines, Jhansi - 284001',
        paymentMethod: 'UPI - Google Pay',
        deliveryFee: 0,
        items: [
          MedicineItem(name: 'ORS Electral Powder', dosageForm: 'Pack of 20 Sachets', manufacturer: 'FDC Ltd', quantity: 2, mrp: 105.0, discount: 5),
          MedicineItem(name: 'Imodium 2mg', dosageForm: 'Strip of 4 Capsules', manufacturer: 'Johnson & Johnson', quantity: 1, mrp: 22.0, discount: 0),
          MedicineItem(name: 'Ondem 4mg', dosageForm: 'Strip of 10 Tablets', manufacturer: 'Alkem Labs', quantity: 1, mrp: 62.0, discount: 12),
        ],
      ),

      // ── 4-6 months ago ────────────────────────
      MedicineOrder(
        id: 'DOC-20239',
        orderDate: now.subtract(const Duration(days: 120)),
        deliveryDate: now.subtract(const Duration(days: 118)),
        status: OrderStatus.delivered,
        deliveryAddress: '12, MG Road, Lashkar, Gwalior - 474001',
        paymentMethod: 'Cash on Delivery',
        deliveryFee: 0,
        items: [
          MedicineItem(name: 'Ascoril LS Syrup', dosageForm: 'Bottle of 100ml', manufacturer: 'Glenmark Pharma', quantity: 1, mrp: 125.0, discount: 12),
          MedicineItem(name: 'Alex Cough Syrup', dosageForm: 'Bottle of 100ml', manufacturer: 'Glenmark Pharma', quantity: 1, mrp: 82.0, discount: 8),
        ],
      ),
      MedicineOrder(
        id: 'DOC-20238',
        orderDate: now.subtract(const Duration(days: 150)),
        deliveryDate: now.subtract(const Duration(days: 148)),
        status: OrderStatus.delivered,
        deliveryAddress: '12, MG Road, Lashkar, Gwalior - 474001',
        paymentMethod: 'UPI - PhonePe',
        deliveryFee: 25,
        items: [
          MedicineItem(name: 'Becosules Capsule', dosageForm: 'Strip of 20 Capsules', manufacturer: 'Pfizer India', quantity: 2, mrp: 33.0, discount: 10),
          MedicineItem(name: 'Supradyn Tablet', dosageForm: 'Strip of 15 Tablets', manufacturer: 'Abbott India', quantity: 1, mrp: 45.0, discount: 5),
        ],
      ),
      MedicineOrder(
        id: 'DOC-20237',
        orderDate: now.subtract(const Duration(days: 180)),
        deliveryDate: now.subtract(const Duration(days: 178)),
        status: OrderStatus.delivered,
        deliveryAddress: '45, Civil Lines, Jhansi - 284001',
        paymentMethod: 'Razorpay - Debit Card',
        deliveryFee: 0,
        items: [
          MedicineItem(name: 'Insulin Lantus Solostar Pen', dosageForm: '1 Pen of 3ml', manufacturer: 'Sanofi India', quantity: 2, mrp: 915.0, discount: 15),
        ],
      ),

      // ── 7-9 months ago ────────────────────────
      MedicineOrder(
        id: 'DOC-20236',
        orderDate: now.subtract(const Duration(days: 210)),
        deliveryDate: now.subtract(const Duration(days: 208)),
        status: OrderStatus.delivered,
        deliveryAddress: '12, MG Road, Lashkar, Gwalior - 474001',
        paymentMethod: 'UPI - Google Pay',
        deliveryFee: 0,
        items: [
          MedicineItem(name: 'Moov Pain Relief Spray', dosageForm: 'Can of 80g', manufacturer: 'Reckitt India', quantity: 1, mrp: 249.0, discount: 10),
          MedicineItem(name: 'Omnigel Spray', dosageForm: 'Can of 75g', manufacturer: 'Cipla Ltd', quantity: 1, mrp: 165.0, discount: 15),
        ],
      ),
      MedicineOrder(
        id: 'DOC-20235',
        orderDate: now.subtract(const Duration(days: 250)),
        deliveryDate: now.subtract(const Duration(days: 248)),
        status: OrderStatus.delivered,
        deliveryAddress: '12, MG Road, Lashkar, Gwalior - 474001',
        paymentMethod: 'Cash on Delivery',
        deliveryFee: 0,
        items: [
          MedicineItem(name: 'Pantocid 40mg', dosageForm: 'Strip of 15 Tablets', manufacturer: 'Sun Pharma', quantity: 1, mrp: 116.0, discount: 20),
          MedicineItem(name: 'Ranitidine 150mg', dosageForm: 'Strip of 10 Tablets', manufacturer: 'JB Chemicals', quantity: 2, mrp: 12.0, discount: 0),
        ],
      ),

      // ── 10-12 months ago ──────────────────────
      MedicineOrder(
        id: 'DOC-20234',
        orderDate: now.subtract(const Duration(days: 300)),
        deliveryDate: now.subtract(const Duration(days: 298)),
        status: OrderStatus.delivered,
        deliveryAddress: '45, Civil Lines, Jhansi - 284001',
        paymentMethod: 'UPI - Paytm',
        deliveryFee: 25,
        items: [
          MedicineItem(name: 'Brufen 400mg', dosageForm: 'Strip of 15 Tablets', manufacturer: 'Abbott India', quantity: 1, mrp: 32.0, discount: 10),
          MedicineItem(name: 'Flexon MR Tablet', dosageForm: 'Strip of 10 Tablets', manufacturer: 'Aristo Pharma', quantity: 1, mrp: 90.0, discount: 15),
          MedicineItem(name: 'Neurobion Forte', dosageForm: 'Strip of 30 Tablets', manufacturer: 'Procter & Gamble', quantity: 1, mrp: 46.0, discount: 8),
        ],
      ),
      MedicineOrder(
        id: 'DOC-20233',
        orderDate: now.subtract(const Duration(days: 340)),
        deliveryDate: now.subtract(const Duration(days: 338)),
        status: OrderStatus.delivered,
        deliveryAddress: '12, MG Road, Lashkar, Gwalior - 474001',
        paymentMethod: 'Razorpay - Credit Card',
        deliveryFee: 0,
        items: [
          MedicineItem(name: 'Otrivin Nasal Spray', dosageForm: 'Bottle of 10ml', manufacturer: 'GSK Pharma', quantity: 1, mrp: 86.0, discount: 5),
          MedicineItem(name: 'Sinarest Tablet', dosageForm: 'Strip of 10 Tablets', manufacturer: 'Centaur Pharma', quantity: 2, mrp: 26.0, discount: 10),
        ],
      ),
      MedicineOrder(
        id: 'DOC-20232',
        orderDate: now.subtract(const Duration(days: 365)),
        deliveryDate: now.subtract(const Duration(days: 363)),
        status: OrderStatus.delivered,
        deliveryAddress: '12, MG Road, Lashkar, Gwalior - 474001',
        paymentMethod: 'UPI - Google Pay',
        deliveryFee: 0,
        items: [
          MedicineItem(name: 'Amoxyclav 625mg', dosageForm: 'Strip of 10 Tablets', manufacturer: 'Alkem Labs', quantity: 1, mrp: 210.0, discount: 20),
          MedicineItem(name: 'Meftal Spas', dosageForm: 'Strip of 10 Tablets', manufacturer: 'Blue Cross Labs', quantity: 1, mrp: 75.0, discount: 10),
          MedicineItem(name: 'Vicks VapoRub', dosageForm: 'Jar of 50ml', manufacturer: 'Procter & Gamble', quantity: 1, mrp: 145.0, discount: 5),
        ],
      ),
    ];
  }
}
