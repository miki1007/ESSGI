import 'package:flutter/material.dart';
import 'package:pro/component/catagory_selection.dart';
import 'package:pro/component/ticket_list.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Image.asset(
                'assets/img/intro_img_1.webp',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 380,
              ),
            ),

            const SizedBox(height: 35),

            // Category selection section
            Container(
              padding: const EdgeInsets.all(20),
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.tertiary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select a Category', // Replace this with the text you want
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context)
                          .colorScheme
                          .inversePrimary, // Adjust color if needed
                    ),
                  ),
                  const SizedBox(
                      height: 10), // Space between text and CategoriesSection
                  Expanded(
                    child: CategoriesSection(
                      onCategoryTap: (category) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TicketList(
                              status: category,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
