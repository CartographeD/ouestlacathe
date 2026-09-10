import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  int _tapCount = 0;

  // 🔗 Lien vers la page Google Play
  static final Uri _playStoreUri = Uri.parse(
    'https://play.google.com/store/apps/details?id=com.carto.ouestlacathe',
  );

  // ⭐ Noter l'application
  Future<void> _rateApp() async {
    if (await canLaunchUrl(_playStoreUri)) {
      await launchUrl(
        _playStoreUri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  // 💬 Donner son avis
  Future<void> _sendFeedback() async {
    final emailUri = Uri(
      scheme: 'mailto',
      path: 'maxime.weil.pro@gmail.com',
      queryParameters: {
        'subject': 'Avis - Où est la Cathé ?',
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

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
                // Retour
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.icon(context),
                      size: 20,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Logo
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

                // Nom
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

                // Localisation
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

                // Description
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

                // Détails
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

                const SizedBox(height: 36),

                // ⭐ Avis
                Center(
                  child: Text(
                    "Vous aimez l'application ?",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.text(context),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ActionButton(
                      icon: Icons.star_rounded,
                      label: "Noter",
                      onTap: _rateApp,
                    ),
                    const SizedBox(width: 8),
                    _ActionButton(
                      icon: Icons.chat_bubble_outline_rounded,
                      label: "Donner votre avis",
                      onTap: _sendFeedback,
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Signature
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

                // Version / Easter egg
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

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.divider(context).withOpacity(.35),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 17,
                color: AppColors.accent,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text(context),
                ),
              ),
            ],
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