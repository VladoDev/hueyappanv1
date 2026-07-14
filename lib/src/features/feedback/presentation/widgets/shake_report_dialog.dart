import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hueyappanv1/l10n/app_localizations.dart';
import '../../data/datasources/github_issues_datasource.dart';

class ShakeReportDialog extends ConsumerStatefulWidget {
  final Uint8List? screenshotBytes;

  const ShakeReportDialog({super.key, this.screenshotBytes});

  @override
  ConsumerState<ShakeReportDialog> createState() => _ShakeReportDialogState();
}

class _ShakeReportDialogState extends ConsumerState<ShakeReportDialog> {
  String? _selectedType;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _currentScreenshotBytes;

  @override
  void initState() {
    super.initState();
    _currentScreenshotBytes = widget.screenshotBytes;
  }

  void _submit() async {
    final loc = AppLocalizations.of(context)!;
    if (_titleController.text.trim().isEmpty || _descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.fillAllFields)),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final datasource = ref.read(githubIssuesDatasourceProvider);
      
      await datasource.createIssue(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        type: _selectedType!,
        screenshotBytes: _selectedType == 'bug' ? _currentScreenshotBytes : null,
      );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.reportThanks)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.errorGeneric(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    if (_selectedType == null) {
      return AlertDialog(
        title: Text(loc.whatToReport),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.bug_report, color: Colors.red),
              title: Text(loc.reportBug),
              onTap: () => setState(() => _selectedType = 'bug'),
            ),
            ListTile(
              leading: const Icon(Icons.lightbulb, color: Colors.amber),
              title: Text(loc.appIdea),
              onTap: () => setState(() => _selectedType = 'idea'),
            ),
            ListTile(
              leading: const Icon(Icons.home_work, color: Colors.blue),
              title: Text(loc.neighborhoodProblem),
              onTap: () => setState(() => _selectedType = 'problem'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(loc.cancel),
          ),
        ],
      );
    }

    return AlertDialog(
      title: Text(_getTitleForType(_selectedType!, loc)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: loc.briefTitle,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: loc.detailedDescription,
                border: const OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            if (_selectedType == 'bug' && _currentScreenshotBytes != null) ...[
              const SizedBox(height: 16),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(
                        _currentScreenshotBytes!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        _currentScreenshotBytes = null;
                      });
                    },
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
      actions: [
        if (!_isLoading)
          TextButton(
            onPressed: () => setState(() => _selectedType = null),
            child: Text(loc.back),
          ),
        if (!_isLoading)
          ElevatedButton(
            onPressed: _submit,
            child: Text(loc.sendReport),
          ),
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  String _getTitleForType(String type, AppLocalizations loc) {
    switch (type) {
      case 'bug':
        return loc.reportBug;
      case 'idea':
        return loc.suggestIdea;
      case 'problem':
        return loc.neighborhoodProblem;
      default:
        return loc.reportLabel;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
