import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/strings.dart';
import '../services/device_service.dart';
import '../widgets/device_info_card.dart';
import '../widgets/welcome_card.dart';

class ESIMCheckScreen extends StatefulWidget {
  const ESIMCheckScreen({super.key});

  @override
  State<ESIMCheckScreen> createState() => _ESIMCheckScreenState();
}

class _ESIMCheckScreenState extends State<ESIMCheckScreen> {
  final DeviceService _deviceService = DeviceService();
  bool _isLoading = true;
  late DeviceInformation _deviceInfo;
  List<String> _debugLogs = [];

  @override
  void initState() {
    super.initState();
    _addDebugLog('App started - initState called');
    _checkDeviceInfo();
  }

  void _addDebugLog(String message) {
    if (mounted) {
      setState(() {
        _debugLogs.add('${DateTime.now().toString().split('.')[0]} - $message');
        if (_debugLogs.length > 20) {
          _debugLogs.removeAt(0);
        }
      });
    }
  }

  Future<void> _checkDeviceInfo() async {
    try {
      _addDebugLog('Starting device info check');
      setState(() => _isLoading = true);
      _deviceInfo = await _deviceService.getDeviceInformation();
      _addDebugLog('Device info received: ${_deviceInfo.model} - ${_deviceInfo.osVersion}');
      _addDebugLog('eSIM Support: ${_deviceInfo.isESIMSupported}');
      setState(() => _isLoading = false);
    } catch (e) {
      _addDebugLog('Error checking device info: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _deviceInfo = DeviceInformation(
            model: 'Unknown Device',
            osVersion: 'Unknown OS',
            isESIMSupported: false,
          );
        });
        _showError('Error checking device information');
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    _addDebugLog('Error shown: $message');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _openESIMStore() async {
    try {
      _addDebugLog('Attempting to open eSIM store');
      final Uri url = Uri.parse(AppStrings.websiteUrl);
      if (await canLaunchUrl(url)) {
        _addDebugLog('Launching URL: ${url.toString()}');
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        _addDebugLog('Cannot launch URL: ${url.toString()}');
        _showError('Could not open the store website');
      }
    } catch (e) {
      _addDebugLog('Error opening store: $e');
      _showError('Could not open the store website');
    }
  }

  void _openPage(String title, String content) {
    _addDebugLog('Opening page: $title');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(title),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDebugOverlay() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: 200,
        color: Colors.black.withOpacity(0.8),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Debug Log',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: _checkDeviceInfo,
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _debugLogs.length,
                reverse: true,
                itemBuilder: (context, index) {
                  return Text(
                    _debugLogs[_debugLogs.length - 1 - index],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/ESIMICONLOGO-512.png',
              height: 32,
              errorBuilder: (context, error, stackTrace) {
                _addDebugLog('Error loading app bar logo: $error');
                return const Icon(Icons.sim_card);
              },
            ),
            const SizedBox(width: 8),
            const Text(AppStrings.appName),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/ESIMICONLOGO-512.png',
                    height: 64,
                    color: Colors.white,
                    errorBuilder: (context, error, stackTrace) {
                      _addDebugLog('Error loading drawer logo: $error');
                      return const Icon(
                        Icons.sim_card,
                        size: 64,
                        color: Colors.white,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    AppStrings.appName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text(AppStrings.aboutUs),
              onTap: () => _openPage(AppStrings.aboutUs, AppStrings.aboutUsContent),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text(AppStrings.termsOfService),
              onTap: () => _openPage(AppStrings.termsOfService, AppStrings.termsContent),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text(AppStrings.privacyPolicy),
              onTap: () => _openPage(AppStrings.privacyPolicy, AppStrings.privacyPolicyContent),
            ),
            ListTile(
              leading: const Icon(Icons.contact_support),
              title: const Text(AppStrings.contactUs),
              onTap: () => _openPage(AppStrings.contactUs, AppStrings.businessHours),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: _checkDeviceInfo,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const WelcomeCard(),
                        const SizedBox(height: 16),
                        DeviceInfoCard(
                          model: _deviceInfo.model,
                          osVersion: _deviceInfo.osVersion,
                          isESIMSupported: _deviceInfo.isESIMSupported,
                          onNextSteps: _openESIMStore,
                        ),
                        const SizedBox(height: 200), // Space for debug overlay
                      ],
                    ),
                  ),
                ),
          _buildDebugOverlay(),
        ],
      ),
    );
  }
} 