import 'package:get/get.dart';
import '../../app_library.dart';

class AppPages {
  static final routes = [
    /// [Business Setup] Module
    GetPage(
      name: Routes.businessSetup,
      page: () => const BusinessSetupView(),
      binding: BusinessSetupBinding(),
    ),

    /// [Main] Module
    GetPage(
      name: Routes.main,
      page: () => const MainView(),
      binding: MainBinding(),
    ),

    /// [Supplier] Module
    GetPage(
      name: Routes.suppliers,
      page: () => const SupplierView(),
      binding: SupplierBinding(),
    ),
    GetPage(
      name: Routes.supplierForm,
      page: () => const SupplierFormView(),
      binding: SupplierBinding(),
    ),
    GetPage(
      name: Routes.supplierDetail,
      page: () => SupplierDetailView(),
      binding: SupplierBinding(),
    ),

    /// [Item] Module
    GetPage(
      name: Routes.items,
      page: () => const ItemView(),
      binding: ItemBinding(),
    ),
    GetPage(
      name: Routes.itemForm,
      page: () => const ItemFormView(),
      binding: ItemBinding(),
    ),
    GetPage(
      name: Routes.itemDetail,
      page: () => ItemDetailView(),
      binding: ItemBinding(),
    ),

    /// [Purchase Order] Module
    GetPage(
      name: Routes.purchaseOrders,
      page: () => const PurchaseOrderView(),
      binding: PurchaseOrderBinding(),
    ),
    GetPage(
      name: Routes.purchaseOrderForm,
      page: () => const PurchaseOrderFormView(),
      binding: PurchaseOrderBinding(),
    ),
    GetPage(
      name: Routes.purchaseOrderDetail,
      page: () => const PurchaseOrderDetailView(),
      binding: PurchaseOrderBinding(),
    ),

    /// [Receipt] Module
    GetPage(
      name: Routes.receipts,
      page: () => const ReceiptView(),
      binding: ReceiptBinding(),
    ),
    GetPage(
      name: Routes.receiptGenerate,
      page: () => const ReceiptGenerateView(),
      binding: ReceiptBinding(),
    ),

    GetPage(name: Routes.receiptDetail, page: () => const ReceiptDetailView()),

    /// [Setting] / [Misc] Pages
    GetPage(
      name: Routes.databaseViewer,
      page: () => const DatabaseViewerView(),
      binding: DatabaseViewerBinding(),
    ),
    GetPage(
      name: Routes.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
  ];
}
