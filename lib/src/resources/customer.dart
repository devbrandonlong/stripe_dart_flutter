part of stripe;

/**
 * Customer objects allow you to perform recurring charges and track multiple
 * charges that are associated with the same customer. The API allows you to
 * create, delete, and update your customers. You can retrieve individual
 * customers as well as a list of all your customers.
 */
class Customer extends ApiResource {

  final String objectName = "customer";

  static String _path = "customers";


  Customer.fromMap(Map dataMap) : super.fromMap(dataMap);

  String get id => _dataMap["id"];

  DateTime get created => _getDateTimeFromMap("created");

  bool get livemode => _dataMap["livemode"];

  bool get deleted => _dataMap["deleted"];

  String get description => _dataMap["description"];

  /**
   * If you want the actual card Object, you need to load it manually like this:
   *
   *     Card.retrieve(customer.defaultCard)
   */
  String get defaultCard => _dataMap["default_card"];

  String get email => _dataMap["email"];

  int get trialEnd => _dataMap["trial_end"];

  Discount get discount => _dataMap["discount"];

  NextRecurringCharge get nextRecurringCharge {
    var value;
    if ((value = _dataMap["next_recurring_charge"]) == null) return null;
    else return new NextRecurringCharge.fromMap(value);
  }

  Subscription get subscription {
    var value;
    if ((value = _dataMap["subscription"]) == null) return null;
    else return new Subscription.fromMap(value);
  }

  bool get delinquent => _dataMap["delinquent"];

  int get accountBalance => _dataMap["account_balance"];

  String get currency => _dataMap["currency"];

  CustomerCardCollection get cards {
    var value;
    if ((value = _dataMap["cards"]) == null) return null;
    else return new CustomerCardCollection.fromMap(value);
  }

  Map<String, String> get metadata => _dataMap["metadata"];


  static Future<Customer> create(Map params) {
    return StripeService.post(Customer._path, params)
      .then((Map json) => new Customer.fromMap(json));
  }

  static Future delete(String id) => StripeService.delete(Customer._path, id);

}