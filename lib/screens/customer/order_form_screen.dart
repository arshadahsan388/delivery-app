import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/app_theme.dart';
import '../../utils/localization.dart';

class OrderFormScreen extends ConsumerWidget {
  final String shopId;
  
  const OrderFormScreen({
    super.key,
    required this.shopId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.orderNow ?? 'Order Now'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Text('Order Form for Shop: $shopId - Coming Soon'),
      ),
    );
  }
}
