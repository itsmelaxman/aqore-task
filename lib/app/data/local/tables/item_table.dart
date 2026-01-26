import 'package:drift/drift.dart';

/// [Item] Table
class Items extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().withLength(min: 1, max: 500)();
  TextColumn get sku => text().withLength(min: 1, max: 50)();
  RealColumn get price => real()();
  IntColumn get stockQuantity => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
