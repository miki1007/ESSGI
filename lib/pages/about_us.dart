import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Changed to white
        elevation: 1,
        title: const Text(
          'About Us',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Black text for contrast
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black), // Black icons
      ),
      body: Container(
        color: Colors.white, // White background for the whole page
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo/Image at the top
                Center(
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/img/about.jpg',
                        fit: BoxFit.cover,
                        width: 150,
                        height: 150,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // App Purpose Introduction Text
                const Text(
                  'Welcome to the Ethiopian Space Science Maintenance App! This app is designed to streamline and enhance the maintenance process at the Ethiopian Space Science and Geospatial Institute, helping to ensure the smooth operation of essential infrastructure and technology.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),

                // Title Section
                _buildSectionTitle(
                    'Ethiopian Space Science and Geospatial Institute'),

                // Description Section
                _buildDescriptionText(
                    'The Ethiopian Space Science and Geospatial Institute (ESSGI) is dedicated to advancing space science and technology, and enhancing the understanding of Earth observation systems. The institute aims to foster research and development in space science, contribute to the global space agenda, and promote the application of geospatial technologies for national development.'),

                const SizedBox(height: 20),

                // Vision Section
                _buildSectionCard(
                    title: 'Our Vision',
                    content:
                        'To be a leading institute in space science and geospatial technology in Africa, contributing to sustainable development and innovation.'),

                // Mission Section
                _buildSectionCard(
                    title: 'Our Mission',
                    content:
                        'To develop and promote space science and technology applications in various sectors, provide training and capacity building, and engage in national and international collaborations.'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildDescriptionText(String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
      child: Text(
        content,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[100], // Light background for contrast
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
