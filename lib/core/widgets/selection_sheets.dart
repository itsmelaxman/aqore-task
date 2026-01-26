import 'package:flutter/material.dart';
import '../../app/data/local/app_database.dart';
import '../widgets/app_bottom_sheets.dart';
import 'custom_toast.dart';

class ItemSelectionSheet {
  static Future<Item?> show(BuildContext context, List<Item> items) async {
    if (items.isEmpty) {
      CustomToast.info(
        'Please add items first before creating a purchase order',
      );
      return null;
    }

    return await AppBottomSheets.showSelection<Item>(
      title: 'Select Item',
      items: items
          .map(
            (item) => SelectionItem<Item>(
              label: item.name,
              value: item,
              subtitle: 'SKU: ${item.sku} • Stock: ${item.stockQuantity}',
              icon: Icons.inventory_2_outlined,
            ),
          )
          .toList(),
    );
  }
}
