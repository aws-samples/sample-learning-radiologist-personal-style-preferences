import 'package:flutter/material.dart';

import '../../models/user_settings.dart';

/// Card for selecting data source (synthetic or MIMIC)
class DataSourceCard extends StatefulWidget {
  const DataSourceCard({
    super.key,
    required this.settings,
    required this.onChanged,
  });

  final UserSettings settings;
  final void Function(String, String?) onChanged;

  @override
  State<DataSourceCard> createState() => _DataSourceCardState();
}

class _DataSourceCardState extends State<DataSourceCard> {
  late String _dataSource;
  late TextEditingController _bucketController;

  @override
  void initState() {
    super.initState();
    _dataSource = widget.settings.dataSource;
    _bucketController =
        TextEditingController(text: widget.settings.mimicBucket ?? '');
  }

  @override
  void dispose() {
    _bucketController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data Source',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'synthetic',
                  label: Text('Synthetic'),
                  icon: Icon(Icons.science_outlined),
                ),
                ButtonSegment(
                  value: 'mimic',
                  label: Text('MIMIC'),
                  icon: Icon(Icons.medical_services_outlined),
                ),
              ],
              selected: {_dataSource},
              onSelectionChanged: (selection) {
                setState(() => _dataSource = selection.first);
                if (selection.first == 'synthetic') {
                  _showDataResetWarning(context, selection.first);
                }
              },
            ),
            if (_dataSource == 'mimic') ...[
              const SizedBox(height: 16),
              TextField(
                controller: _bucketController,
                decoration: const InputDecoration(
                  labelText: 'S3 Bucket Name',
                  hintText: 'my-mimic-bucket',
                  prefixIcon: Icon(Icons.storage_outlined),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: () => _showDataResetWarning(context, 'mimic'),
                  child: const Text('Apply'),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Builder(builder: (context) {
              final cs = Theme.of(context).colorScheme;
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.tertiaryContainer,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: cs.tertiary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber, color: cs.onTertiaryContainer),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Changing data source will reset all your data (cases, preferences, edit history).',
                        style: TextStyle(
                          color: cs.onTertiaryContainer,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showDataResetWarning(BuildContext context, String newSource) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Data?'),
        content: const Text(
          'Changing the data source will reset all your cases, preferences, '
          'and edit history. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onChanged(
                newSource,
                newSource == 'mimic' ? _bucketController.text : null,
              );
            },
            child: const Text('Reset & Change'),
          ),
        ],
      ),
    );
  }
}
