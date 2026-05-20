import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import '../models/order.dart';
import '../screens/order_details_screen.dart';

class OrderCard extends StatelessWidget {
  final MedicineOrder order;

  const OrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final itemNames = order.items.map((i) => i.name).join(', ');
    final isActive = order.status != OrderStatus.delivered &&
        order.status != OrderStatus.cancelled;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isActive ? DocsoColors.primary.withOpacity(0.3) : DocsoColors.divider,
          width: isActive ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderDetailsScreen(order: order),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header: Order ID + Status ──
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: DocsoColors.primary.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.receipt_long, size: 18, color: DocsoColors.primary),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.id,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            DateFormat('dd MMM yyyy, hh:mm a').format(order.orderDate),
                            style: TextStyle(color: DocsoColors.textSecondary, fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                  _buildStatusChip(order.status),
                ],
              ),

              // ── Medicine summary ──
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  itemNames,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: DocsoColors.textSecondary, fontSize: 12),
                ),
              ),

              // ── Footer: Items count + Total ──
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: DocsoColors.background,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.medication_outlined, size: 16, color: DocsoColors.textSecondary),
                        const SizedBox(width: 6),
                        Text(
                          '${order.items.length} item${order.items.length > 1 ? "s" : ""}',
                          style: TextStyle(fontSize: 12, color: DocsoColors.textSecondary, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        if (order.totalSaved > 0) ...[
                          Text(
                            '₹${order.itemsMrpTotal.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 11,
                              color: DocsoColors.textSecondary,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          '₹${order.grandTotal.toStringAsFixed(0)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(OrderStatus status) {
    Color bg;
    Color fg;
    String label;
    IconData icon;

    switch (status) {
      case OrderStatus.placed:
        bg = Colors.blue.shade50;
        fg = Colors.blue.shade700;
        label = 'Placed';
        icon = Icons.pending_outlined;
        break;
      case OrderStatus.confirmed:
        bg = Colors.indigo.shade50;
        fg = Colors.indigo.shade700;
        label = 'Confirmed';
        icon = Icons.check_circle_outline;
        break;
      case OrderStatus.processing:
        bg = Colors.orange.shade50;
        fg = Colors.orange.shade800;
        label = 'Processing';
        icon = Icons.hourglass_bottom;
        break;
      case OrderStatus.shipped:
        bg = Colors.purple.shade50;
        fg = Colors.purple.shade700;
        label = 'Shipped';
        icon = Icons.local_shipping_outlined;
        break;
      case OrderStatus.outForDelivery:
        bg = Colors.teal.shade50;
        fg = Colors.teal.shade700;
        label = 'Out for Delivery';
        icon = Icons.delivery_dining;
        break;
      case OrderStatus.delivered:
        bg = Colors.green.shade50;
        fg = Colors.green.shade700;
        label = 'Delivered';
        icon = Icons.done_all;
        break;
      case OrderStatus.cancelled:
        bg = Colors.red.shade50;
        fg = Colors.red.shade700;
        label = 'Cancelled';
        icon = Icons.cancel_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: fg, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
