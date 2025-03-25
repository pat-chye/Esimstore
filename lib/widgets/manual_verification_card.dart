import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/strings.dart';

class ManualVerificationCard extends StatefulWidget {
  final bool isESIMSupported;
  final Function(bool) onVerificationChanged;

  const ManualVerificationCard({
    super.key,
    required this.isESIMSupported,
    required this.onVerificationChanged,
  });

  @override
  State<ManualVerificationCard> createState() => _ManualVerificationCardState();
}

class _ManualVerificationCardState extends State<ManualVerificationCard> {
  bool _isAndroid = false;
  bool _isIOS = false;
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    _checkPlatform();
  }

  Future<void> _checkPlatform() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.android) {
      final androidInfo = await deviceInfo.androidInfo;
      setState(() => _isAndroid = true);
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      final iosInfo = await deviceInfo.iosInfo;
      setState(() => _isIOS = true);
    }
  }

  void _updateVerification(bool value) {
    setState(() {
      _isVerified = value;
      widget.onVerificationChanged(_isVerified);
    });
  }

  Future<void> _openNetworkSettings() async {
    if (_isAndroid) {
      await _openSettingsUrl('content://settings/network_and_internet');
    } else if (_isIOS) {
      await _openSettingsUrl('app-settings:Cellular');
    }
  }

  Future<void> _openSettingsUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.verified_user,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Manual Verification',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Please verify that your device supports eSIM by checking the following:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            if (_isAndroid) ...[
              _buildAndroidInstructions(),
            ] else if (_isIOS) ...[
              _buildIOSInstructions(),
            ] else ...[
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
            const SizedBox(height: 16),
            const Text(
              'Alternative Method:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You can also check by dialing *#06# in your phone\'s dialer. If your device supports eSIM, you will see an EID (Embedded Identity Document) number, which may appear as a barcode. The presence of an EID confirms eSIM compatibility.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text(
                'I have verified that my device supports eSIM',
                style: TextStyle(fontSize: 16),
              ),
              value: _isVerified,
              onChanged: (value) => _updateVerification(value ?? false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAndroidInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'For Android devices:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Expanded(
              child: Text(
                '1. Open Settings',
                style: TextStyle(fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: _openNetworkSettings,
              child: const Text('Click here'),
            ),
          ],
        ),
        const Text(
          '2. Go to Network & Internet or Connections',
          style: TextStyle(fontSize: 16),
        ),
        const Text(
          '3. Look for "SIM" or "SIM card manager"',
          style: TextStyle(fontSize: 16),
        ),
        const Text(
          '4. Check if you see an option to "Add eSIM" or "Add mobile plan"',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildIOSInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'For iOS devices:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Expanded(
              child: Text(
                '1. Open Settings',
                style: TextStyle(fontSize: 16),
              ),
            ),
            TextButton(
              onPressed: _openNetworkSettings,
              child: const Text('Click here'),
            ),
          ],
        ),
        const Text(
          '2. Go to Cellular or Mobile Data',
          style: TextStyle(fontSize: 16),
        ),
        const Text(
          '3. Look for "Add eSIM" or "Add Data Plan"',
          style: TextStyle(fontSize: 16),
        ),
        const Text(
          '4. Check if you see an option to add a new eSIM',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
} 