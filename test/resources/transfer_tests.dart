library transfer_tests;

import 'dart:convert';

import 'package:unittest/unittest.dart';
import 'dart:async';

import '../../lib/stripe.dart';
import '../utils.dart' as utils;

var exampleTransfer = """
    {
      "id": "tr_1046Ri41dfVNZFcqQ325IJCE",
      "object": "transfer",
      "created": 1401075076,
      "date": 1401235200,
      "livemode": false,
      "amount": 4141,
      "currency": "usd",
      "status": "pending",
      "type": "bank_account",
      "balance_transaction": "txn_1044ML41dfVNZFcq7TtjDZeb",
      "summary": {
        "charge_gross": 7010,
        "charge_fees": 2190,
        "charge_fee_details": [
          {
            "amount": 2190,
            "currency": "usd",
            "type": "stripe_fee",
            "description": null,
            "application": null
          }
        ],
        "refund_gross": -700,
        "refund_fees": -21,
        "refund_fee_details": [
          {
            "amount": -21,
            "currency": "usd",
            "type": "stripe_fee",
            "description": null,
            "application": null
          }
        ],
        "adjustment_gross": 0,
        "adjustment_fees": 0,
        "adjustment_fee_details": [
    
        ],
        "validation_fees": 0,
        "validation_count": 0,
        "charge_count": 66,
        "refund_count": 14,
        "adjustment_count": 0,
        "net": 4141,
        "currency": "usd",
        "collected_fee_gross": 0,
        "collected_fee_count": 0,
        "collected_fee_refund_gross": 0,
        "collected_fee_refund_count": 0
      },
      "transactions": {
        "object": "list",
        "total_count": 80,
        "has_more": true,
        "url": "/v1/transfers/tr_1046Ri41dfVNZFcqQ325IJCE/transactions",
        "data": [
          {
            "id": "ch_1044o041dfVNZFcqIEgcg9P7",
            "type": "charge",
            "amount": 100,
            "currency": "usd",
            "net": 67,
            "created": 1400696687,
            "description": null,
            "fee": 33,
            "fee_details": [
              {
                "amount": 33,
                "currency": "usd",
                "type": "stripe_fee",
                "description": "Stripe processing fees",
                "application": null
              }
            ]
          },
          {
            "id": "ch_1044o041dfVNZFcqrnWnjxRs",
            "type": "charge",
            "amount": 100,
            "currency": "usd",
            "net": 67,
            "created": 1400696685,
            "description": null,
            "fee": 33,
            "fee_details": [
              {
                "amount": 33,
                "currency": "usd",
                "type": "stripe_fee",
                "description": "Stripe processing fees",
                "application": null
              }
            ]
          },
          {
            "id": "ch_1044o041dfVNZFcqzOvv2gr1",
            "type": "charge",
            "amount": 100,
            "currency": "usd",
            "net": 67,
            "created": 1400696685,
            "description": null,
            "fee": 33,
            "fee_details": [
              {
                "amount": 33,
                "currency": "usd",
                "type": "stripe_fee",
                "description": "Stripe processing fees",
                "application": null
              }
            ]
          },
          {
            "id": "ch_1044o041dfVNZFcqzhFXD8Pl",
            "type": "charge",
            "amount": 100,
            "currency": "usd",
            "net": 67,
            "created": 1400696684,
            "description": null,
            "fee": 33,
            "fee_details": [
              {
                "amount": 33,
                "currency": "usd",
                "type": "stripe_fee",
                "description": "Stripe processing fees",
                "application": null
              }
            ]
          },
          {
            "id": "ch_1044o041dfVNZFcqMpXTlhqm",
            "type": "charge",
            "amount": 100,
            "currency": "usd",
            "net": 67,
            "created": 1400696683,
            "description": null,
            "fee": 33,
            "fee_details": [
              {
                "amount": 33,
                "currency": "usd",
                "type": "stripe_fee",
                "description": "Stripe processing fees",
                "application": null
              }
            ]
          }
        ]
      },
      "other_transfers": [
        "tr_1046Ri41dfVNZFcqQ325IJCE"
      ],
      "description": "STRIPE TRANSFER",
      "metadata": {
      },
      "statement_description": null,
      "recipient": null
    }""";


main(List<String> args) {

  utils.setApiKeyFromArgs(args);

  group('Transfer offline', () {

    test('fromMap() properly popullates all values', () {
      var map = JSON.decode(exampleTransfer);

      var transfer = new Transfer.fromMap(map);

      expect(transfer.id, equals(map['id']));
      expect(transfer.created, equals(new DateTime.fromMillisecondsSinceEpoch(map['created'] * 1000)));
      expect(transfer.date, equals(new DateTime.fromMillisecondsSinceEpoch(map['date'] * 1000)));
      expect(transfer.livemode, equals(map['livemode']));
      expect(transfer.amount, equals(map['amount']));
      expect(transfer.currency, equals(map['currency']));
      expect(transfer.status, equals(map['status']));
      expect(transfer.type, equals(map['type']));
      expect(transfer.balanceTransaction, equals(map['balance_transaction']));
      expect(transfer.description, equals(map['description']));
      expect(transfer.metadata, equals(map['metadata']));
      expect(transfer.statementDescription, equals(map['statement_description']));
      expect(transfer.recipient, equals(map['recipient']));

    });

  });

  group('Token online', () {

    setUp(() {
      return utils.setUp();
    });

    tearDown(() {
      return utils.tearDown();
    });

    test('TransferCreation minimal', () {
      // Transfer fields
      int testTransferAmount = 100;
      String testTransferCurrency = 'usd';
      String testTransferRecipient = 'self';

      (new TransferCreation()
          ..amount = testTransferAmount
          ..currency = testTransferCurrency
          ..recipient = testTransferRecipient
      ).create()
      .then((Transfer transfer) {
        expect(transfer.amount, equals(testTransferAmount));
        expect(transfer.currency, equals(testTransferCurrency));
        expect(transfer.recipient, isNull);
      })
      .then(expectAsync((_) => true));
    });

    test('TransferCreation full', () {
      // Recipient fields
      Recipient testRecipient;
      String testRecipientName = 'test name';
      String testRecipientType = 'corporation';

      String testBankAccountCountry = 'US';
      String testBankAccountRoutingNumber = '110000000';
      String testBankAccountAccountNumber = '000123456789';

      BankAccountRequest testRecipientBankAccount = (new BankAccountRequest()
          ..country = testBankAccountCountry
          ..routingNumber = testBankAccountRoutingNumber
          ..accountNumber = testBankAccountAccountNumber
      );

      RecipientCreation testRecipientCreation = new RecipientCreation()
          ..name = testRecipientName
          ..type = testRecipientType
          ..bankAccount = testRecipientBankAccount;

      // Transfer fields
      int testTransferAmount = 100;
      String testTransferCurrency = 'usd';
      String testTransferDescription1 = 'test description1';
      String testTransferStatementDescription = 'description';
      Map testTransferMetadata1 = {'foo': 'bar1'};

      String testTransferDescription2 = 'test description2';
      Map testTransferMetadata2 = {'foo': 'bar2'};

      testRecipientCreation.create()
          .then((Recipient recipient) {
            testRecipient = recipient;
            return (new TransferCreation()
                ..amount = testTransferAmount
                ..currency = testTransferCurrency
                ..recipient = recipient.id
                ..description = testTransferDescription1
                ..statementDescription = testTransferStatementDescription
                ..metadata = testTransferMetadata1
            ).create();
          })
          .then((Transfer transfer) {
            expect(transfer.amount, equals(testTransferAmount));
            expect(transfer.currency, equals(testTransferCurrency));
            expect(transfer.recipient, testRecipient.id);
            expect(transfer.description, testTransferDescription1);
            expect(transfer.statementDescription, testTransferStatementDescription);
            expect(transfer.metadata, testTransferMetadata1);
            return Transfer.retrieve(transfer.id, data: {'expand': ['balance_transaction']});
          })
          // testing the expand functionality of retrieve
          .then((Transfer transfer) {
            expect(transfer.balanceTransaction, equals(transfer.balanceTransactionExpand.id));
            expect(transfer.balanceTransactionExpand.amount, equals(testTransferAmount * -1));
            // testing the TransferUpdate
            return (new TransferUpdate()
                ..description = testTransferDescription2
                ..metadata = testTransferMetadata2
            ).update(transfer.id);
          })
          .then((Transfer transfer) {
            expect(transfer.amount, equals(testTransferAmount));
            expect(transfer.currency, equals(testTransferCurrency));
            expect(transfer.recipient, testRecipient.id);
            expect(transfer.description, testTransferDescription2);
            expect(transfer.statementDescription, testTransferStatementDescription);
            expect(transfer.metadata, testTransferMetadata2);
            // testing transfer cancel
            return Transfer.cancel(transfer.id);
          })
          .catchError((e) {
            // transfer has already been submitted
            expect(e, new isInstanceOf<InvalidRequestErrorException>());
            expect(e.errorMessage, equals('Transfer cannot be canceled, because it has already been submitted. You can currently only cancel pending transfers.'));
          })
          .then(expectAsync((_) => true));
    });

    test('List parameters Transfer', () {

      // Transfer fields
      int testTransferAmount = 100;
      String testTransferCurrency = 'usd';
      String testTransferRecipient = 'self';

      List<Future> queue = [];
      for (var i = 0; i < 20; i++) {
        queue.add((new TransferCreation()
            ..amount = testTransferAmount
            ..currency = testTransferCurrency
            ..recipient = testTransferRecipient
        ).create());
      }

      Future.wait(queue)
      .then((_) => Transfer.list(limit: 10))
      .then((TransferCollection transfers) {
        expect(transfers.data.length, equals(10));
        expect(transfers.hasMore, equals(true));
        return Transfer.list(limit: 10, startingAfter: transfers.data.last.id);
      })
      .then((TransferCollection transfers) {
        expect(transfers.data.length, equals(10));
        // will also include transfers from past tests
        expect(transfers.hasMore, equals(true));
        return Transfer.list(limit: 10, endingBefore: transfers.data.first.id);
      })
      .then((TransferCollection transfers) {
        expect(transfers.data.length, equals(10));
        expect(transfers.hasMore, equals(false));
      })
      .then(expectAsync((_) => true));

    });

  });

}