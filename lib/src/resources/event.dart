part of stripe;


/**
 * [Event](https://stripe.com/docs/api/curl#events)
 */
class Event extends ApiResource {

  String get id => _dataMap['id'];

  final String objectName = 'event';

  static String _path = 'events';

  bool get livemode => _dataMap['livemode'];

  DateTime get created => _getDateTimeFromMap('created');

  EventData get data  {
    var value = _dataMap['data'];
    if (value == null) return null;
    else return new EventData.fromMap(value);
  }

  int get pendingWebhooks => _dataMap['pending_webhooks'];

  String get type => _dataMap['type'];

  String get request => _dataMap['request'];

  Event.fromMap(Map dataMap) : super.fromMap(dataMap);

  /**
   * [Retrieve an event](https://stripe.com/docs/api/curl#retrieve_event)
   */
  static Future<Event> retrieve(String eventId) {
    return StripeService.retrieve([Event._path, eventId])
        .then((Map json) => new Event.fromMap(json));
  }

  /**
   * [List all events](https://stripe.com/docs/api/curl#list_events)
   */
  // TODO: implement missing arguments
  static Future<EventCollection> list({int limit, String startingAfter, String endingBefore, String type}) {
    Map data = {};
    if (limit != null) data['limit'] = limit;
    if (startingAfter != null) data['starting_after'] = startingAfter;
    if (endingBefore != null) data['ending_before'] = endingBefore;
    if (type != null) data['type'] = type;
    if (data == {}) data = null;
    return StripeService.list([Event._path], data: data)
        .then((Map json) => new EventCollection.fromMap(json));
  }

}


class EventCollection extends ResourceCollection {

  Event _getInstanceFromMap(map) => new Event.fromMap(map);

  EventCollection.fromMap(Map map) : super.fromMap(map);

}


class EventData {

  Map _dataMap;

  Map get object => _dataMap['object'];

  Map get previousAttribute => _dataMap['previous_attribute'];

  EventData.fromMap(this._dataMap);

}