class Assets {
  static String get logo => 'logo'.png;

  /// [Bottom] Navigation Icons
  static String get supplier => 'supplier'.icon;
  static String get inventory => 'inventory'.icon;
  static String get entity => 'entity'.icon;
  static String get setting => 'setting'.icon;

  /// /[SVG] Illustrations
  static String get inventoryIllustration => 'inventory'.svg;
  static String get supplierIllustration => 'supplier'.svg;
  static String get pOrderIllustration => 'porder'.svg;
  static String get receiptIllustration => 'receipt'.svg;

  /// Other [icons]
  static String get archive => 'archive'.icon;
  static String get businessOutlined => 'business_outlined'.icon;
  static String get calendar => 'calendar'.icon;
  static String get call => 'call'.icon;
  static String get cancel => 'cancel'.icon;
  static String get clock => 'clock'.icon;
  static String get delete => 'delete'.icon;
  static String get desc => 'desc'.icon;
  static String get edit => 'edit'.icon;
  static String get email => 'email'.icon;
  static String get hashtag => 'hashtag'.icon;
  static String get inventoryOutlined => 'inventory_outlined'.icon;
  static String get location => 'location'.icon;
  static String get order => 'order'.icon;
  static String get receipt => 'receipt'.icon;
  static String get scan => 'scan'.icon;
  static String get supplierOutlined => 'supplier_outlined'.icon;
  static String get tick => 'tick'.icon;
  static String get user => 'user'.icon;
  static String get filter => 'filter'.icon;
}

extension on String {
  String get png => 'assets/images/$this.png';
  String get icon => 'assets/svg/icons/$this.svg';
  String get svg => 'assets/svg/$this.svg';
}
