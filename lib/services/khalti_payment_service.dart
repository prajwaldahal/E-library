import 'package:flutter/material.dart';
import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';
import 'package:elibrary/common/constants/payment_gateway_constant.dart';
import '../../common/constants/api_constant.dart';
import 'api_services.dart';
import 'secure_storage_helper.dart';


class KhaltiPaymentService {
  final ApiService _apiService = ApiService();

  Future<String?> initiatePayment({
    required int amount,
    required String bookName,
    required String bookId,
    required String returnUrl,
    required String websiteUrl,
  }) async {
    final headers = {
      'Authorization': 'Key ${PaymentGatewayConstant.secretKey}',
      'Content-Type': 'application/json',
    };
    final body = {
      'return_url': returnUrl,
      'website_url': websiteUrl,
      'amount': amount,
      'purchase_order_id': 'order_$bookId',
      'purchase_order_name': bookName,
    };

    try {
      final response = await _apiService.post(Constants.khaltiPaymentInitiator, body,headers: headers);
      if (response != null && response['pidx'] != null) {
        final pidx = response['pidx'];
        debugPrint('Payment initiation successful. Pidx: $pidx');
        return pidx;
      } else {
        debugPrint('Payment initiation failed: $response');
        return null;
      }
    } catch (e) {
      debugPrint('Error initiating payment: $e');
      return null;
    }
  }

  Future<void> insertRentalTransaction({
    required BuildContext context,
    required String isbn,
    required double amountPaid,
    required DateTime expiryDate,
  }) async {
    try {
      String? uid = await SecureStorageHelper.read("uid");
      if (uid == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found in the database.')),
        );
        return;
      }

      final body = {
        'userId': uid,
        'isbn': isbn,
        'rental_date': DateTime.now().toLocal().toString().split(' ')[0],
        'expiry_date': expiryDate.toLocal().toString().split(' ')[0],
        'amount_paid': amountPaid,
      };

      final response = await _apiService.post(Constants.rentalEndPoint, body);
      if (response != null) {
        debugPrint('Rental transaction inserted successfully.');
        debugPrint(response.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rental transaction inserted successfully.')),
        );
      } else {
        debugPrint('Failed to insert rental transaction.');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to insert rental transaction.')),
        );
      }
    } catch (e) {
      debugPrint('Error making API request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error making API request: $e')),
      );
    }
  }

  void payWithKhalti({
    required BuildContext context,
    required int amount,
    required String bookName,
    required String bookId,
    required DateTime expiryDate,
  }) async {
    final pidx = await initiatePayment(
      amount: amount,
      bookName: bookName,
      bookId: bookId,
      returnUrl: 'https://example.com/payment/',
      websiteUrl: 'https://example.com/',
    );

    if (pidx != null) {
      debugPrint('Starting payment process with Pidx: $pidx');

      final config = KhaltiPayConfig(
        publicKey: PaymentGatewayConstant.publicKey,
        pidx: pidx,
        environment: Environment.test,
      );

      final khalti = Khalti.init(
        enableDebugging: true,
        payConfig: config,
        onPaymentResult: (paymentResult, khaltiInstance) async {
          debugPrint('Payment Result: ${paymentResult.payload}');
          if (paymentResult.payload?.status == 'Completed') {
            debugPrint('Payment completed successfully.');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Payment successful! Transaction ID: ${paymentResult.payload?.transactionId}',
                ),
              ),
            );

            await insertRentalTransaction(
              context: context,
              isbn: bookId,
              amountPaid: amount / 100,
              expiryDate: expiryDate,
            );
          } else {
            debugPrint('Payment failed with status: ${paymentResult.payload?.status}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Payment failed: ${paymentResult.payload?.status}')),
            );
          }
          khaltiInstance.close(context);
        },
        onMessage: (
            khaltiInstance, {
              description,
              statusCode,
              event,
              needsPaymentConfirmation,
            }) async {
          debugPrint('Message: $description, Status Code: $statusCode, Event: $event');
          if (needsPaymentConfirmation == true) {
            debugPrint('Payment requires confirmation. Calling verify API...');
            try {
              await khaltiInstance.verify();
              debugPrint('Payment verified successfully.');
            } catch (e) {
              debugPrint('Error verifying payment: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error verifying payment: $e')),
              );
            }
          } else {
            debugPrint('No confirmation needed.');
          }

          khaltiInstance.close(context);
        },
        onReturn: () => debugPrint('Redirected to return URL.'),
      );

      khalti.then((Khalti khalti) {
        khalti.open(context);
      });
    } else {
      debugPrint('Failed to initiate payment.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to initiate payment.')),
      );
    }
  }
}
