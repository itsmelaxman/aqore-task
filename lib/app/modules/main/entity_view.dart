import '../../../app_library.dart';
import 'package:flutter/material.dart';

class EntityView extends StatelessWidget {
  const EntityView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text('Entity'),
          centerTitle: false,
          elevation: 0,
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(
                icon: SvgHelper.fromSource(
                  path: Assets.order,
                  height: 20,
                  width: 20,
                ),
                text: 'Orders',
              ),
              Tab(
                icon: SvgHelper.fromSource(
                  path: Assets.receipt,
                  height: 20,
                  width: 20,
                ),
                text: 'Receipts',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [const PurchaseOrderView(), const ReceiptView()],
        ),
      ),
    );
  }
}
