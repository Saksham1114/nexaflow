import 'package:flutter/material.dart';

import 'package:nexaflow/features/home/presentation/widgets/greeting_header.dart';
import 'package:nexaflow/features/home/presentation/widgets/productivity_card.dart';
import 'package:nexaflow/shared/widgets/section_title.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              GreetingHeader(),
              SizedBox(height: 32),
              SectionTitle("Today's Progress"),
              ProductivityCard(),
            ],
          ),
        ),
      ),
    );
  }
}
