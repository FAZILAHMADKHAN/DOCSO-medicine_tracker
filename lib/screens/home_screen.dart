import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../providers/order_provider.dart';
import '../widgets/order_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: DocsoColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.local_pharmacy, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              'docso',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
                fontSize: 24,
                color: DocsoColors.primary,
              ),
            ),
          ],
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search orders, medicines, status...',
                hintStyle: TextStyle(color: DocsoColors.textSecondary, fontSize: 14),
                prefixIcon: Icon(Icons.search, color: DocsoColors.textSecondary),
                filled: true,
                fillColor: DocsoColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: DocsoColors.divider),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: DocsoColors.divider),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: DocsoColors.primary, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                context.read<OrderProvider>().searchOrders(value);
              },
            ),
          ),
        ),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: DocsoColors.primary),
                  const SizedBox(height: 16),
                  Text('Loading your orders...', style: TextStyle(color: DocsoColors.textSecondary)),
                ],
              ),
            );
          }

          if (provider.orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: DocsoColors.primary.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.medical_information_outlined,
                        size: 56, color: DocsoColors.primary),
                  ),
                  const SizedBox(height: 24),
                  const Text('No orders found',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    provider.searchQuery.isNotEmpty
                        ? 'Try a different search term'
                        : 'Your medicine orders will appear here',
                    style: TextStyle(color: DocsoColors.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  TextButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Refresh'),
                    style: TextButton.styleFrom(foregroundColor: DocsoColors.primary),
                    onPressed: () => provider.fetchOrders(),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: DocsoColors.primary,
            onRefresh: () => provider.fetchOrders(),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Icon(Icons.receipt_long, size: 18, color: DocsoColors.textSecondary),
                        const SizedBox(width: 6),
                        Text(
                          'My Orders (${provider.orders.length})',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: DocsoColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return OrderCard(order: provider.orders[index]);
                      },
                      childCount: provider.orders.length,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
