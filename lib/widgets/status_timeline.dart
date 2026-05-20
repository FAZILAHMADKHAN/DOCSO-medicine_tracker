import 'package:flutter/material.dart';
import '../main.dart';
import '../models/order.dart';

/// A polished vertical timeline widget showing order status progression.
///
/// Active steps glow with the brand primary color, completed steps show
/// a check icon, and future steps are muted in grey.
class StatusTimeline extends StatelessWidget {
  final OrderStatus currentStatus;

  const StatusTimeline({super.key, required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    // Ordered lifecycle steps
    final steps = [
      OrderStatus.placed,
      OrderStatus.confirmed,
      OrderStatus.processing,
      OrderStatus.shipped,
      OrderStatus.outForDelivery,
      OrderStatus.delivered,
    ];

    // Handle cancelled orders separately
    if (currentStatus == OrderStatus.cancelled) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(Icons.cancel, color: Colors.red.shade700),
            const SizedBox(width: 10),
            Text(
              'Order was cancelled',
              style: TextStyle(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ],
        ),
      );
    }

    int currentIndex = steps.indexOf(currentStatus);
    if (currentIndex == -1) currentIndex = 0;

    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isCompleted = index <= currentIndex;
        final isCurrent = index == currentIndex;
        final isLast = index == steps.length - 1;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Timeline column (dot + line) ──
              SizedBox(
                width: 32,
                child: Column(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted ? DocsoColors.primary : Colors.white,
                        border: isCompleted
                            ? null
                            : Border.all(color: Colors.grey.shade300, width: 2),
                        boxShadow: isCurrent
                            ? [
                                BoxShadow(
                                  color: DocsoColors.primary.withOpacity(0.35),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                )
                              ]
                            : null,
                      ),
                      child: isCompleted
                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                          : null,
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          constraints: const BoxConstraints(minHeight: 28),
                          color: index < currentIndex
                              ? DocsoColors.primary
                              : Colors.grey.shade200,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 14),

              // ── Label + icon ──
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 16, top: 2),
                  child: Row(
                    children: [
                      Icon(
                        _stepIcon(step),
                        size: 16,
                        color: isCompleted ? DocsoColors.primary : Colors.grey.shade400,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _stepLabel(step),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isCompleted ? FontWeight.bold : FontWeight.w400,
                          color: isCompleted ? Colors.black87 : Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  String _stepLabel(OrderStatus s) {
    switch (s) {
      case OrderStatus.placed:
        return 'Order Placed';
      case OrderStatus.confirmed:
        return 'Order Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      default:
        return '';
    }
  }

  IconData _stepIcon(OrderStatus s) {
    switch (s) {
      case OrderStatus.placed:
        return Icons.shopping_cart_outlined;
      case OrderStatus.confirmed:
        return Icons.check_circle_outline;
      case OrderStatus.processing:
        return Icons.hourglass_bottom;
      case OrderStatus.shipped:
        return Icons.local_shipping_outlined;
      case OrderStatus.outForDelivery:
        return Icons.delivery_dining;
      case OrderStatus.delivered:
        return Icons.done_all;
      default:
        return Icons.circle;
    }
  }
}
