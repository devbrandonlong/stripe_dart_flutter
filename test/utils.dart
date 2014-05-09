library test_utils;

import "dart:async";
import "dart:io";

import "../lib/stripe.dart";


setApiKeyFromArgs(List<String> args) {
  if (args.length < 1) {
    print("Error. Most tests can not execute without a Stripe API key.");
    print("Provide your stripe API key as the first command line argument!");
    exit(2);
  }
  StripeService.apiKey = args.first;
}

Future setUp() {
  print("Test Setup");
  return new Future.value();
}

Future tearDown() {
  print("Test Teardown");
  List<Future> processQueue = [];
  processQueue.add(deleteAllCustomers());
  processQueue.add(deleteAllPlans());
  return Future.wait(processQueue);
}

Future deleteAllCustomers() {
  return Customer.all()
    .then((CustomerCollection customers) {
      List<Future> processQueue = [];
      for (Customer customer in customers.data) {
        processQueue.add(Customer.delete(customer.id).then((_) => print("Delete customer: ${customer.id}")));
      }
      return processQueue;
    }).then((List<Future> futures) {
      return Future.wait(futures);
    });
}

Future deleteAllPlans() {
  return Plan.all()
    .then((PlanCollection plans) {
      List<Future> processQueue = [];
      for (Plan plan in plans.data) {
        processQueue.add(Plan.delete(plan.id).then((_) => print("Delete plan: ${plan.id}")));
      }
      return processQueue;
    }).then((List<Future> futures) {
      return Future.wait(futures);
    });
}