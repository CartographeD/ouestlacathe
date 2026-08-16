import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {

  int _tapCount = 0;

  void _versionTapped() {
    _tapCount++;

    if (_tapCount < 5) return;

    _tapCount = 0;

    HapticFeedback.lightImpact();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Center(
            child: Text(
              "❤️",
              style: TextStyle(fontSize: 34),
            ),
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Tu as trouvé un petit secret.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Merci d'utiliser\nOù est la Cathé ?",
                textAlign: TextAlign.center,
                  style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Fermer"),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 22,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.icon(context),
                      size: 20,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Center(
                  child: Hero(
                    tag: "cathedral_logo",
                    child: Image.asset(
                      "assets/logo.png",
                      height: 115,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Center(
                  child: Text(
                    "Cathédrale\nNotre-Dame",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      height: .95,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Center(
                  child: Text(
                    "Strasbourg, France",
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.secondary(context),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                Center(
                  child: Text(
                    "Pendant plus de deux siècles,\n"
                    "elle fut le plus haut monument\n"
                    "du monde.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      height: 1.5,
                      color: AppColors.secondary(context),
                      fontSize: 17,
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  "Quelques détails",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accent,
                  ),
                ),

                const SizedBox(height: 22),
                const _InfoRow(
                  "Hauteur",
                  "142 m",
                ),

                Divider(
                  color: AppColors.divider(context),
                ),

                const _InfoRow(
                  "Construction",
                  "1015 – 1439",
                ),

                Divider(
                  color: AppColors.divider(context),
                ),

                const _InfoRow(
                  "Surnom",
                  "« Môman »",
                ),

                Divider(
                  color: AppColors.divider(context),
                ),

                const _InfoRow(
                  "Patrimoine UNESCO",
                  "1988",
                ),

                const SizedBox(height: 32),

                Center(
                  child: Text(
                    "Développée avec ❤️ à Strasbourg",
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Center(
                  child: GestureDetector(
                    onTap: _versionTapped,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "v1.0.0",
                        style: TextStyle(
                          color: AppColors.text(context),
                          fontSize: 13,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const _InfoRow(
    this.title,
    this.value,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
            ),
          ),

          const Spacer(),

          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}