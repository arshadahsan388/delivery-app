import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Common
  String get appName => _localizedValues[locale.languageCode]!['app_name']!;
  String get yes => _localizedValues[locale.languageCode]!['yes']!;
  String get no => _localizedValues[locale.languageCode]!['no']!;
  String get ok => _localizedValues[locale.languageCode]!['ok']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get save => _localizedValues[locale.languageCode]!['save']!;
  String get delete => _localizedValues[locale.languageCode]!['delete']!;
  String get edit => _localizedValues[locale.languageCode]!['edit']!;
  String get loading => _localizedValues[locale.languageCode]!['loading']!;
  String get error => _localizedValues[locale.languageCode]!['error']!;
  String get success => _localizedValues[locale.languageCode]!['success']!;

  // Auth
  String get login => _localizedValues[locale.languageCode]!['login']!;
  String get signup => _localizedValues[locale.languageCode]!['signup']!;
  String get logout => _localizedValues[locale.languageCode]!['logout']!;
  String get email => _localizedValues[locale.languageCode]!['email']!;
  String get password => _localizedValues[locale.languageCode]!['password']!;
  String get confirmPassword => _localizedValues[locale.languageCode]!['confirm_password']!;
  String get name => _localizedValues[locale.languageCode]!['name']!;
  String get phone => _localizedValues[locale.languageCode]!['phone']!;
  String get forgotPassword => _localizedValues[locale.languageCode]!['forgot_password']!;
  String get resetPassword => _localizedValues[locale.languageCode]!['reset_password']!;
  String get dontHaveAccount => _localizedValues[locale.languageCode]!['dont_have_account']!;
  String get alreadyHaveAccount => _localizedValues[locale.languageCode]!['already_have_account']!;

  // Navigation
  String get home => _localizedValues[locale.languageCode]!['home']!;
  String get orders => _localizedValues[locale.languageCode]!['orders']!;
  String get profile => _localizedValues[locale.languageCode]!['profile']!;
  String get shops => _localizedValues[locale.languageCode]!['shops']!;
  String get dashboard => _localizedValues[locale.languageCode]!['dashboard']!;

  // Order related
  String get orderNow => _localizedValues[locale.languageCode]!['order_now']!;
  String get orderHistory => _localizedValues[locale.languageCode]!['order_history']!;
  String get orderDetails => _localizedValues[locale.languageCode]!['order_details']!;
  String get specialInstructions => _localizedValues[locale.languageCode]!['special_instructions']!;
  String get orderStatus => _localizedValues[locale.languageCode]!['order_status']!;
  String get pending => _localizedValues[locale.languageCode]!['pending']!;
  String get accepted => _localizedValues[locale.languageCode]!['accepted']!;
  String get preparing => _localizedValues[locale.languageCode]!['preparing']!;
  String get pickedUp => _localizedValues[locale.languageCode]!['picked_up']!;
  String get onTheWay => _localizedValues[locale.languageCode]!['on_the_way']!;
  String get delivered => _localizedValues[locale.languageCode]!['delivered']!;
  String get cancelled => _localizedValues[locale.languageCode]!['cancelled']!;

  // Customer
  String get nearbyShops => _localizedValues[locale.languageCode]!['nearby_shops']!;
  String get recentOrders => _localizedValues[locale.languageCode]!['recent_orders']!;
  String get addPhoto => _localizedValues[locale.languageCode]!['add_photo']!;
  String get placeOrder => _localizedValues[locale.languageCode]!['place_order']!;
  String get deliveryAddress => _localizedValues[locale.languageCode]!['delivery_address']!;
  String get totalAmount => _localizedValues[locale.languageCode]!['total_amount']!;
  String get deliveryFee => _localizedValues[locale.languageCode]!['delivery_fee']!;

  // Rider
  String get newOrderRequest => _localizedValues[locale.languageCode]!['new_order_request']!;
  String get acceptOrder => _localizedValues[locale.languageCode]!['accept_order']!;
  String get rejectOrder => _localizedValues[locale.languageCode]!['reject_order']!;
  String get markPickedUp => _localizedValues[locale.languageCode]!['mark_picked_up']!;
  String get markDelivered => _localizedValues[locale.languageCode]!['mark_delivered']!;
  String get customerLocation => _localizedValues[locale.languageCode]!['customer_location']!;
  String get shopLocation => _localizedValues[locale.languageCode]!['shop_location']!;

  // Admin
  String get totalOrders => _localizedValues[locale.languageCode]!['total_orders']!;
  String get totalRiders => _localizedValues[locale.languageCode]!['total_riders']!;
  String get totalShops => _localizedValues[locale.languageCode]!['total_shops']!;
  String get activeRiders => _localizedValues[locale.languageCode]!['active_riders']!;
  String get manageShops => _localizedValues[locale.languageCode]!['manage_shops']!;
  String get manageRiders => _localizedValues[locale.languageCode]!['manage_riders']!;
  String get analytics => _localizedValues[locale.languageCode]!['analytics']!;

  // Settings
  String get settings => _localizedValues[locale.languageCode]!['settings']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get notifications => _localizedValues[locale.languageCode]!['notifications']!;
  String get about => _localizedValues[locale.languageCode]!['about']!;
  String get contactUs => _localizedValues[locale.languageCode]!['contact_us']!;

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_name': 'Local Express',
      'yes': 'Yes',
      'no': 'No',
      'ok': 'OK',
      'cancel': 'Cancel',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
      'login': 'Login',
      'signup': 'Sign Up',
      'logout': 'Logout',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'name': 'Name',
      'phone': 'Phone Number',
      'forgot_password': 'Forgot Password?',
      'reset_password': 'Reset Password',
      'dont_have_account': 'Don\'t have an account?',
      'already_have_account': 'Already have an account?',
      'home': 'Home',
      'orders': 'Orders',
      'profile': 'Profile',
      'shops': 'Shops',
      'dashboard': 'Dashboard',
      'order_now': 'Order Now',
      'order_history': 'Order History',
      'order_details': 'Order Details',
      'special_instructions': 'Special Instructions',
      'order_status': 'Order Status',
      'pending': 'Pending',
      'accepted': 'Accepted',
      'preparing': 'Preparing',
      'picked_up': 'Picked Up',
      'on_the_way': 'On the Way',
      'delivered': 'Delivered',
      'cancelled': 'Cancelled',
      'nearby_shops': 'Nearby Shops',
      'recent_orders': 'Recent Orders',
      'add_photo': 'Add Photo',
      'place_order': 'Place Order',
      'delivery_address': 'Delivery Address',
      'total_amount': 'Total Amount',
      'delivery_fee': 'Delivery Fee',
      'new_order_request': 'New Order Request',
      'accept_order': 'Accept Order',
      'reject_order': 'Reject Order',
      'mark_picked_up': 'Mark as Picked Up',
      'mark_delivered': 'Mark as Delivered',
      'customer_location': 'Customer Location',
      'shop_location': 'Shop Location',
      'total_orders': 'Total Orders',
      'total_riders': 'Total Riders',
      'total_shops': 'Total Shops',
      'active_riders': 'Active Riders',
      'manage_shops': 'Manage Shops',
      'manage_riders': 'Manage Riders',
      'analytics': 'Analytics',
      'settings': 'Settings',
      'language': 'Language',
      'notifications': 'Notifications',
      'about': 'About',
      'contact_us': 'Contact Us',
    },
    'ur': {
      'app_name': 'لوکل ایکسپریس',
      'yes': 'ہاں',
      'no': 'نہیں',
      'ok': 'ٹھیک ہے',
      'cancel': 'منسوخ',
      'save': 'محفوظ کریں',
      'delete': 'حذف کریں',
      'edit': 'تبدیل کریں',
      'loading': 'لوڈ ہو رہا ہے...',
      'error': 'خرابی',
      'success': 'کامیاب',
      'login': 'لاگ ان',
      'signup': 'اکاؤنٹ بنائیں',
      'logout': 'لاگ آؤٹ',
      'email': 'ای میل',
      'password': 'پاس ورڈ',
      'confirm_password': 'پاس ورڈ کی تصدیق',
      'name': 'نام',
      'phone': 'فون نمبر',
      'forgot_password': 'پاس ورڈ بھول گئے؟',
      'reset_password': 'پاس ورڈ ری سیٹ کریں',
      'dont_have_account': 'اکاؤنٹ نہیں ہے؟',
      'already_have_account': 'پہلے سے اکاؤنٹ ہے؟',
      'home': 'ہوم',
      'orders': 'آرڈرز',
      'profile': 'پروفائل',
      'shops': 'دکانیں',
      'dashboard': 'ڈیش بورڈ',
      'order_now': 'آرڈر کریں',
      'order_history': 'آرڈر کی تاریخ',
      'order_details': 'آرڈر کی تفصیلات',
      'special_instructions': 'خصوصی ہدایات',
      'order_status': 'آرڈر کی حالت',
      'pending': 'زیر التواء',
      'accepted': 'قبول شدہ',
      'preparing': 'تیاری میں',
      'picked_up': 'اٹھایا گیا',
      'on_the_way': 'راستے میں',
      'delivered': 'ڈیلیور شدہ',
      'cancelled': 'منسوخ شدہ',
      'nearby_shops': 'قریبی دکانیں',
      'recent_orders': 'حالیہ آرڈرز',
      'add_photo': 'تصویر شامل کریں',
      'place_order': 'آرڈر دیں',
      'delivery_address': 'ڈیلیوری ایڈریس',
      'total_amount': 'کل رقم',
      'delivery_fee': 'ڈیلیوری فیس',
      'new_order_request': 'نیا آرڈر درخواست',
      'accept_order': 'آرڈر قبول کریں',
      'reject_order': 'آرڈر مسترد کریں',
      'mark_picked_up': 'اٹھایا ہوا نشان زد کریں',
      'mark_delivered': 'ڈیلیور شدہ نشان زد کریں',
      'customer_location': 'کسٹمر کا مقام',
      'shop_location': 'دکان کا مقام',
      'total_orders': 'کل آرڈرز',
      'total_riders': 'کل رائیڈرز',
      'total_shops': 'کل دکانیں',
      'active_riders': 'فعال رائیڈرز',
      'manage_shops': 'دکانوں کا انتظام',
      'manage_riders': 'رائیڈرز کا انتظام',
      'analytics': 'تجزیات',
      'settings': 'سیٹنگز',
      'language': 'زبان',
      'notifications': 'اطلاعات',
      'about': 'بارے میں',
      'contact_us': 'رابطہ کریں',
    },
  };
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ur'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
