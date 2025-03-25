import 'package:flutter/material.dart';

class DeviceInfoCard extends StatelessWidget {
  final String model;
  final String osVersion;
  final bool isESIMSupported;
  final VoidCallback onNextSteps;

  const DeviceInfoCard({
    super.key,
    required this.model,
    required this.osVersion,
    required this.isESIMSupported,
    required this.onNextSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.phone_android,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Device Information',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Model:', model),
            const SizedBox(height: 8),
            _buildInfoRow('OS Version:', osVersion),
            const SizedBox(height: 16),
            _buildESIMStatus(context),
            if (isESIMSupported) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onNextSteps,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Get an eSIM'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildESIMStatus(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isESIMSupported ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            isESIMSupported ? Icons.check_circle : Icons.error,
            color: isESIMSupported ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isESIMSupported
                  ? 'Your device supports eSIM!'
                  : 'Your device does not support eSIM',
              style: TextStyle(
                fontSize: 16,
                color: isESIMSupported ? Colors.green.shade900 : Colors.red.shade900,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 