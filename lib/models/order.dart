/// Represents the lifecycle status of a medicine order.
enum OrderStatus {
  placed,
  confirmed,
  processing,
  shipped,
  outForDelivery,
  delivered,
  cancelled,
}

/// A single medicine item inside an order, with pricing details.
class MedicineItem {
  final String name;
  final String dosageForm; // e.g. "Strip of 15 Tablets"
  final String manufacturer;
  final int quantity;
  final double mrp; // Maximum Retail Price per unit
  final double discount; // Discount percentage (0-100)

  MedicineItem({
    required this.name,
    required this.dosageForm,
    required this.manufacturer,
    required this.quantity,
    required this.mrp,
    required this.discount,
  });

  /// The discounted price per unit.
  double get sellingPrice => mrp * (1 - discount / 100);

  /// Total for this line item (quantity * sellingPrice).
  double get lineTotal => sellingPrice * quantity;

  /// Total discount saved on this line item.
  double get savedAmount => (mrp - sellingPrice) * quantity;
}

/// A complete medicine order with billing breakdown.
class MedicineOrder {
  final String id;
  final DateTime orderDate;
  final DateTime? deliveryDate;
  final List<MedicineItem> items;
  final OrderStatus status;
  final String deliveryAddress;
  final String paymentMethod;
  final double deliveryFee;
  final double packagingFee;

  MedicineOrder({
    required this.id,
    required this.orderDate,
    this.deliveryDate,
    required this.items,
    required this.status,
    required this.deliveryAddress,
    required this.paymentMethod,
    this.deliveryFee = 0.0,
    this.packagingFee = 10.0,
  });

  /// Sum of all item MRPs (before discounts).
  double get itemsMrpTotal =>
      items.fold(0.0, (sum, item) => sum + (item.mrp * item.quantity));

  /// Sum of all selling-price line totals.
  double get itemsSubtotal =>
      items.fold(0.0, (sum, item) => sum + item.lineTotal);

  /// Total discount saved across all items.
  double get totalSaved => itemsMrpTotal - itemsSubtotal;

  /// Grand total = items subtotal + delivery + packaging.
  double get grandTotal => itemsSubtotal + deliveryFee + packagingFee;

  /// Number of individual items in the order.
  int get totalItemCount =>
      items.fold(0, (sum, item) => sum + item.quantity);
}
