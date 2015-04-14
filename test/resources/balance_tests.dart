library balance_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;


var exampleBalance = """
    {
      "pending": [
        {
          "amount": 295889,
          "currency": "usd"
        }
      ],
      "available": [
        {
          "amount": 0,
          "currency": "usd"
        }
      ],
      "livemode": false,
      "object": "balance"
    }""";


var exampleBalanceTransaction = """
    {
      "id": "txn_10427j41dfVNZFcqQpEyIITM",
      "object": "balance_transaction",
      "amount": 100,
      "currency": "usd",
      "net": 67,
      "type": "charge",
      "created": 1400078159,
      "available_on": 1400630400,
      "status": "pending",
      "fee": 33,
      "fee_details": [
        {
          "amount": 33,
          "currency": "usd",
          "type": "stripe_fee",
          "description": "Stripe processing fees",
          "application": null
        }
      ],
      "source": "ch_10427j41dfVNZFcqhfaTmJUU",
      "description": null
    }""";


main(List<String> args) {

  utils.setApiKeyFromArgs(args);

  group('Balance offline', () {

    test('fromMap() properly popullates all values', () {

      var map = JSON.decode(exampleBalance);
      var balance = new Balance.fromMap(map);
      expect(balance.pending.first.amount, equals(map['pending'][0]['amount']));
      expect(balance.pending.first.currency, equals(map['pending'][0]['currency']));
      expect(balance.available.first.amount, equals(map['available'][0]['amount']));
      expect(balance.available.first.currency, equals(map['available'][0]['currency']));

    });

  });

  group('Balance online', () {

    setUp(() {
      return utils.setUp();
    });

    tearDown(() {
      return utils.tearDown();
    });

    test('Retrieve Balance', () async {

      Balance balance = await Balance.retrieve();
      expect(balance.livemode, equals(false));
      // other tests will depend on your stripe account

    });

  });

  group('BalanceTransaction offline', () {

    test('fromMap() properly popullates all values', () {

      var map = JSON.decode(exampleBalanceTransaction);
      var balanceTransaction = new BalanceTransaction.fromMap(map);
      expect(balanceTransaction.id, equals(map['id']));
      expect(balanceTransaction.amount, equals(map['amount']));
      expect(balanceTransaction.currency, equals(map['currency']));
      expect(balanceTransaction.net, equals(map['net']));
      expect(balanceTransaction.type, equals(map['type']));
      expect(balanceTransaction.created, equals(new DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000)));
      expect(balanceTransaction.availableOn, equals(new DateTime.fromMillisecondsSinceEpoch(map['available_on'] * 1000)));
      expect(balanceTransaction.status, equals(map['status']));
      expect(balanceTransaction.fee, equals(map['fee']));
      expect(balanceTransaction.feeDetails.first.amount, equals(map['fee_details'].first['amount']));
      expect(balanceTransaction.feeDetails.first.currency, equals(map['fee_details'].first['currency']));
      expect(balanceTransaction.feeDetails.first.type, equals(map['fee_details'].first['type']));
      expect(balanceTransaction.feeDetails.first.description, equals(map['fee_details'].first['description']));
      expect(balanceTransaction.feeDetails.first.application, equals(map['fee_details'].first['application']));
      expect(balanceTransaction.source, equals(map['source']));
      expect(balanceTransaction.description, equals(map['description']));

    });

  });

}