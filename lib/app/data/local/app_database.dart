import 'dart:io';
import 'package:aqore_app/app_library.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Table imports
import 'tables/supplier_table.dart';
import 'tables/item_table.dart';
import 'tables/purchase_order_table.dart';
import 'tables/purchase_order_item_table.dart';
import 'tables/receipt_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Suppliers, Items, PurchaseOrders, PurchaseOrderItems, Receipts],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  // Open connection
  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, DbConstants.databaseName));
      return NativeDatabase(file);
    });
  }
}
