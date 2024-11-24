import 'package:flutter/material.dart';
import 'package:payment_by_paymob/paymob_manager/paymob_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paymob Integration"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async => await _pay(),
          child: const Text("Pay 10 EGP"),
        ),
      ),
    );
  }

 Future<void> _pay() async {
  try {
    String paymentKey = await PaymobManager().getPaymentKey(10, "EGP");

    final Uri url = Uri.parse(
        'https://accept.paymob.com/api/acceptance/iframes/872610?payment_token=$paymentKey');

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      print('Could not launch $url');
    }
  } catch (e) {
    print('Error occurred in payment process: $e');
  }
}
}
