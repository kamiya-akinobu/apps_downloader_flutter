import 'package:apps_downloader_flutter/constants.dart';
import 'package:flutter/material.dart';

class InformationPage extends StatelessWidget {
  const InformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 10.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AppVersion: ${Constants.appVersion} (${Constants.buildNumber})',
              style: const TextStyle(fontSize: 25.0),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(Constants.caution01),
            const SizedBox(
              height: 20,
            ),
            const Text(Constants.caution02),
            const SizedBox(
              height: 20,
            ),
            const Text(Constants.caution03),
            const SizedBox(
              height: 20,
            ),
            const Text(Constants.caution04),
          ],
        ),
      ),
    );
  }
}
