import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ',style: TextStyle(fontWeight: FontWeight.w700),),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          FAQItem(
            question: 'What is this app for?',
            answer:
                'This app is designed to help users manage their medication schedules, stay on track with dietry goals, and get motivated to exercise regularly.',
          ),
          FAQItem(
            question: 'How does the medicine reminder feature work?',
            answer:
                'The medicine reminder feature allows you to set up reminders for taking your medication at specific times. You can customize the frequency and dosage of each medication, and the app will notify you when it\'s time to take them.',
          ),
          FAQItem(
            question: 'Can I track my dietry progress with this app?',
            answer:
                'Yes, you can track your dietry progress within the app. It offers features such as tracking calories fo each meal of the day, and monitoring your food calories consumed percentage over time.',
          ),
          FAQItem(
            question: 'What types of exercises does the app encourage?',
            answer:
                'The app encourages a variety of exercises, including running, cycling, flexibility exercises, and more.',
          ),
          FAQItem(
            question: 'Is my personal data secure within the app?',
            answer:
                'Yes, we take user privacy and data security seriously. All personal data is encrypted and stored securely on our servers. We adhere to strict privacy policies to ensure the confidentiality of your information.',
          ),
          FAQItem(
            question: 'Can I sync my data across multiple devices?',
            answer:
                'Yes, you can sync your data across multiple devices by logging in with the same account. This allows you to access your medication schedules, fitness progress, and other data from any device.',
          ),
          FAQItem(
            question:
                'What if I have trouble using the app or encounter technical issues?',
            answer:
                'If you encounter any difficulties or technical issues while using the app, please reach out to our support team for assistance. We\'re here to help resolve any issues and ensure you have a smooth experience with the app.',
          ),
          SizedBox(height: 230,),
          Column(
            children: [
              Text("© 2024 MyCareTaker.",style: TextStyle(fontSize: 15),),
            ],
          )
        ],
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const FAQItem({
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        question,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Text(answer),
        ),
      ],
    );
  }
}