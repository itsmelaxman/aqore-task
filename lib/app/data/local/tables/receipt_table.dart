import 'package:drift/drift.dart';
import 'supplier_table.dart';

/// [Receipt] Table
class Receipts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get supplierId => integer().references(Suppliers, #id)();
  TextColumn get receiptNumber => text().withLength(min: 1, max: 50)();
  DateTimeColumn get receiptDate => dateTime()();
  RealColumn get totalAmount => real()();
  TextColumn get purchaseOrderIds => text()(); // Comma-separated PO IDs
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
