import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  bool paymentSuccess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffE8B57E),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Payment Method",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 35,
              ),
            ),
          ),
          SizedBox(
            width: 400,
            child: ListTile(
              leading: const Icon(Icons.qr_code),
              title: const Text("UPI Payment"),
              trailing: IconButton(
                onPressed: () {
                  showPaymentSnackbar("UPI Payment");
                },
                icon: const Icon(Icons.navigate_next),
              ),
            ),
          ),
          SizedBox(
            width: 400,
            child: ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text("Card Payment"),
              trailing: IconButton(
                onPressed: () {
                  showPaymentSnackbar("Card Payment");
                },
                icon: const Icon(Icons.navigate_next),
              ),
            ),
          ),
          if (paymentSuccess)
            const SizedBox(
              height: 100,
              child: Center(
                child: Text(
                  "No Ads to display!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          // Add your ad widget here, and wrap it with a condition to check if paymentSuccess is false
          if (!paymentSuccess)
            const SizedBox(
              height: 100,
              child: Center(
                child: Text(
                  "Your ad widget goes here",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void showPaymentSnackbar(String paymentMethod) {
    Get.snackbar(
      "Subscription Success",
      "$paymentMethod successful",
    );

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        paymentSuccess = true;
      });
      Get.toNamed("/animal");
    });
  }
}
