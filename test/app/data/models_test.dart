import 'package:flutter_test/flutter_test.dart';
import 'package:aqore_app/app/data/local/app_database.dart';

void main() {
  group('Item Model Tests', () {
    test('should create Item with all properties', () {
      final now = DateTime.now();
      final item = Item(
        id: 1,
        name: 'Test Item',
        description: 'Test Description',
        sku: 'SKU-001',
        price: 99.99,
        stockQuantity: 50,
        createdAt: now,
        updatedAt: now,
      );

      expect(item.id, equals(1));
      expect(item.name, equals('Test Item'));
      expect(item.description, equals('Test Description'));
      expect(item.sku, equals('SKU-001'));
      expect(item.price, equals(99.99));
      expect(item.stockQuantity, equals(50));
    });

    test('should handle price calculations', () {
      final now = DateTime.now();
      final item = Item(
        id: 1,
        name: 'Item',
        description: 'Desc',
        sku: 'SKU',
        price: 10.50,
        stockQuantity: 5,
        createdAt: now,
        updatedAt: now,
      );

      final totalValue = item.price * item.stockQuantity;
      expect(totalValue, equals(52.50));
    });
  });

  group('Supplier Model Tests', () {
    test('should create Supplier with all properties', () {
      final now = DateTime.now();
      final supplier = Supplier(
        id: 1,
        name: 'Acme Corp',
        contactPerson: 'John Smith',
        email: 'john@acme.com',
        phone: '555-1234',
        address: '123 Main St',
        createdAt: now,
        updatedAt: now,
      );

      expect(supplier.id, equals(1));
      expect(supplier.name, equals('Acme Corp'));
      expect(supplier.contactPerson, equals('John Smith'));
      expect(supplier.email, equals('john@acme.com'));
      expect(supplier.phone, equals('555-1234'));
      expect(supplier.address, equals('123 Main St'));
    });

    test('should validate email format when provided', () {
      final now = DateTime.now();
      final supplier = Supplier(
        id: 1,
        name: 'Test',
        contactPerson: 'Test',
        email: 'valid@email.com',
        phone: '123',
        address: 'Address',
        createdAt: now,
        updatedAt: now,
      );

      expect(supplier.email, isNotNull);
      expect(supplier.email!.contains('@'), isTrue);
      expect(supplier.email!.contains('.'), isTrue);
    });

    test('should create Supplier without email', () {
      final now = DateTime.now();
      final supplier = Supplier(
        id: 1,
        name: 'Test Corp',
        contactPerson: 'Jane Doe',
        email: null,
        phone: '555-9999',
        address: '456 Test St',
        createdAt: now,
        updatedAt: now,
      );

      expect(supplier.email, isNull);
      expect(supplier.name, equals('Test Corp'));
      expect(supplier.contactPerson, equals('Jane Doe'));
    });
  });

  group('PurchaseOrder Model Tests', () {
    test('should create PurchaseOrder with all properties', () {
      final now = DateTime.now();
      final order = PurchaseOrder(
        id: 1,
        orderNumber: 'PO-001',
        supplierId: 1,
        orderDate: now,
        totalAmount: 500.00,
        status: 'pending',
        createdAt: now,
        updatedAt: now,
      );

      expect(order.id, equals(1));
      expect(order.orderNumber, equals('PO-001'));
      expect(order.supplierId, equals(1));
      expect(order.totalAmount, equals(500.00));
      expect(order.status, equals('pending'));
    });

    test('should handle different statuses', () {
      final now = DateTime.now();
      final pending = PurchaseOrder(
        id: 1,
        orderNumber: 'PO-001',
        supplierId: 1,
        orderDate: now,
        totalAmount: 100.00,
        status: 'pending',
        createdAt: now,
        updatedAt: now,
      );

      final completed = PurchaseOrder(
        id: 2,
        orderNumber: 'PO-002',
        supplierId: 1,
        orderDate: now,
        totalAmount: 200.00,
        status: 'completed',
        createdAt: now,
        updatedAt: now,
      );

      expect(pending.status, equals('pending'));
      expect(completed.status, equals('completed'));
      expect(pending.status != completed.status, isTrue);
    });
  });

  group('Receipt Model Tests', () {
    test('should create Receipt with all properties', () {
      final now = DateTime.now();
      final receipt = Receipt(
        id: 1,
        receiptNumber: 'RCP-001',
        supplierId: 1,
        totalAmount: 750.00,
        receiptDate: now,
        createdAt: now,
        purchaseOrderIds: '1,2,3',
      );

      expect(receipt.id, equals(1));
      expect(receipt.receiptNumber, equals('RCP-001'));
      expect(receipt.supplierId, equals(1));
      expect(receipt.totalAmount, equals(750.00));
    });
  });
}
