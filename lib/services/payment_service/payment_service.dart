 import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ems/utils/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
Map<String, dynamic>? paymentIntentData;

  Future<void> makePayment(
    BuildContext context, {
    String? amount,
    String? eventId
  }) async {
    try {
      paymentIntentData = await createPaymentIntent(amount!, 'USD');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret:
                      paymentIntentData!['client_secret'],
                  applePay: true,
                  googlePay: true,
                  testEnv: true,
                  style: ThemeMode.dark,
                  merchantCountryCode: 'US',
                  merchantDisplayName: 'EMS'))
          .then((value) {})
          .catchError((e) {
        print("Error is $e");
      });

      ///now finally display payment sheeet
      displayPaymentSheet(context,eventId!);
    } catch (e, s) {
      print('exception:');
       print("\n");
      print("$e");
      print("\n");

      print("$s");
    }
  }

  displayPaymentSheet(BuildContext context,String eventId) async {
    try {
      await Stripe.instance
          .presentPaymentSheet(
              parameters: PresentPaymentSheetParameters(
        clientSecret: paymentIntentData!['client_secret'],
        confirmPayment: true,
      ))
          .then((newValue) {
        FirebaseFirestore.instance
            .collection('events')
            .doc(eventId)
            .set({
          'joined':
              FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
          'max_entries': FieldValue.increment(-1),
        }, SetOptions(merge: true)).then((value) {
          FirebaseFirestore.instance
              .collection('booking')
              .doc(eventId)
              .set({
            'booking': FieldValue.arrayUnion([
              {
                'uid': FirebaseAuth.instance.currentUser!.uid,
                'tickets': 1
              }
            ])
          });

          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Paid Successfully")));

          Timer(Duration(seconds: 3), () {
            Get.back();
          });
        });

        paymentIntentData = null;
      }).onError((error, stackTrace) {
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      print(body);
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer $secretKey',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }