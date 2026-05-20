import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import '../models/order.dart';
import '../widgets/status_timeline.dart';

class OrderDetailsScreen extends StatelessWidget {
  final MedicineOrder order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(order.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Order Info Card ──
            _buildSectionHeader('Order Information', Icons.info_outline),
            _buildOrderInfoCard(context),
            const SizedBox(height: 20),

            // ── Status Timeline ──
            _buildSectionHeader('Tracking', Icons.timeline),
            _buildTimelineCard(context),
            const SizedBox(height: 20),

            // ── Items Breakdown ──
            _buildSectionHeader('Items (${order.items.length})', Icons.medication_outlined),
            ...order.items.map((item) => _buildItemCard(context, item)),
            const SizedBox(height: 20),

            // ── Bill Summary ──
            _buildSectionHeader('Bill Summary', Icons.receipt_long),
            _buildBillCard(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Section Header ──
  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: DocsoColors.textSecondary),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 0.3),
          ),
        ],
      ),
    );
  }

  // ── Order Info ──
  Widget _buildOrderInfoCard(BuildContext context) {
    return _cardContainer(
      child: Column(
        children: [
          _infoRow('Order Date', DateFormat('dd MMM yyyy, hh:mm a').format(order.orderDate)),
          if (order.deliveryDate != null) ...[
            const Divider(height: 20),
            _infoRow('Delivery Date', DateFormat('dd MMM yyyy').format(order.deliveryDate!)),
          ],
          const Divider(height: 20),
          _infoRow('Payment', order.paymentMethod),
          const Divider(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Deliver To', style: TextStyle(color: DocsoColors.textSecondary, fontSize: 13)),
              const SizedBox(width: 24),
              Flexible(
                child: Text(
                  order.deliveryAddress,
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Timeline ──
  Widget _buildTimelineCard(BuildContext context) {
    return _cardContainer(
      child: StatusTimeline(currentStatus: order.status),
    );
  }

  // ── Single Item Card ──
  Widget _buildItemCard(BuildContext context, MedicineItem item) {
    final hasDiscount = item.discount > 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DocsoColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + manufacturer
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: DocsoColors.primary.withOpacity(0.08),
                child: Icon(Icons.medication, size: 18, color: DocsoColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(item.dosageForm, style: TextStyle(color: DocsoColors.textSecondary, fontSize: 12)),
                    Text(item.manufacturer, style: TextStyle(color: DocsoColors.textSecondary, fontSize: 11)),
                  ],
                ),
              ),
              if (hasDiscount)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: DocsoColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${item.discount.toStringAsFixed(0)}% OFF',
                    style: TextStyle(color: DocsoColors.accent, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          // Pricing row
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: DocsoColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Qty: ${item.quantity}', style: TextStyle(fontSize: 12, color: DocsoColors.textSecondary)),
                Row(
                  children: [
                    if (hasDiscount) ...[
                      Text(
                        'MRP ₹${item.mrp.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 11,
                          color: DocsoColors.textSecondary,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      '₹${item.sellingPrice.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                    ),
                    Text(
                      '  =  ₹${item.lineTotal.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Bill Summary ──
  Widget _buildBillCard(BuildContext context) {
    return _cardContainer(
      child: Column(
        children: [
          _billRow('Item Total (MRP)', '₹${order.itemsMrpTotal.toStringAsFixed(2)}'),
          if (order.totalSaved > 0)
            _billRow('Discount', '- ₹${order.totalSaved.toStringAsFixed(2)}', isGreen: true),
          _billRow('Subtotal', '₹${order.itemsSubtotal.toStringAsFixed(2)}'),
          _billRow('Delivery Fee', order.deliveryFee > 0 ? '₹${order.deliveryFee.toStringAsFixed(2)}' : 'FREE', isGreen: order.deliveryFee == 0),
          _billRow('Packaging', '₹${order.packagingFee.toStringAsFixed(2)}'),
          const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider(height: 1)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Grand Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(
                '₹${order.grandTotal.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: DocsoColors.primary,
                ),
              ),
            ],
          ),
          if (order.totalSaved > 0) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: DocsoColors.accent.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.savings_outlined, size: 16, color: DocsoColors.accent),
                  const SizedBox(width: 6),
                  Text(
                    'You saved ₹${order.totalSaved.toStringAsFixed(2)} on this order!',
                    style: TextStyle(
                      color: DocsoColors.accent,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── Helpers ──
  Widget _cardContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: DocsoColors.divider),
      ),
      child: child,
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: DocsoColors.textSecondary, fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      ],
    );
  }

  Widget _billRow(String label, String value, {bool isGreen = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: DocsoColors.textSecondary, fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: isGreen ? DocsoColors.accent : DocsoColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
