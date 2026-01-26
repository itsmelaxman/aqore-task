abstract class Routes {
  /// [Main] Module
  static const main = '/';

  /// Business [Setup] Module
  static const businessSetup = '/business-setup';

  /// [Home] Module
  static const home = '/home';

  /// [Supplier] Module
  static const suppliers = '/suppliers';
  static const supplierForm = '/suppliers/form';
  static const supplierDetail = '/suppliers/detail';

  /// [Item] Module
  static const items = '/items';
  static const itemForm = '/items/form';
  static const itemDetail = '/items/detail';

  /// Purchase [Order] Module
  static const purchaseOrders = '/purchase-orders';
  static const purchaseOrderForm = '/purchase-orders/form';
  static const purchaseOrderDetail = '/purchase-orders/detail';

  /// [Receipt] Module
  static const receipts = '/receipts';
  static const receiptGenerate = '/receipts/generate';
  static const receiptDetail = '/receipts/detail';

  /// [Tools] / Misc
  static const databaseViewer = '/database-viewer';
  static const settings = '/settings';
}
