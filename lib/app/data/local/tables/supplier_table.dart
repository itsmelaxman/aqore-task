import 'package:drift/drift.dart';

/// [Supplier] Table
class Suppliers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 200)();
  TextColumn get contactPerson => text().withLength(min: 1, max: 100)();
  TextColumn get email => text().withLength(max: 100).nullable()();
  TextColumn get phone => text().withLength(min: 1, max: 20)();
  TextColumn get address => text().withLength(min: 1, max: 500)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
