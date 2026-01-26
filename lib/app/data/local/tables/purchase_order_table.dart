import 'package:drift/drift.dart';
import 'supplier_table.dart';

/// Purchase [Order] Table
class PurchaseOrders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get supplierId => integer().references(Suppliers, #id)();
  TextColumn get orderNumber => text().withLength(min: 1, max: 50)();
  DateTimeColumn get orderDate => dateTime()();
  TextColumn get status =>
      text().withLength(min: 1, max: 20)(); // 'pending' or 'processed'
  RealColumn get totalAmount => real()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
