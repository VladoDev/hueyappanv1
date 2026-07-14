import 'package:hueyappanv1/l10n/app_localizations.dart';
import 'package:hueyappanv1/src/core/theme/vecinal_theme.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/poll_entity.dart';
import '../providers/polls_provider.dart';
import '../../../authentication/presentation/providers/auth_provider.dart';

class PollCard extends ConsumerStatefulWidget {
  final PollEntity poll;

  const PollCard({super.key, required this.poll});

  @override
  ConsumerState<PollCard> createState() => _PollCardState();
}

class _PollCardState extends ConsumerState<PollCard> {
  String? _selectedOptionId;
  bool _isSubmitting = false;

  final _customOptionController = TextEditingController();

  void _submitVote() async {
    if (_selectedOptionId == null) return;
    
    String? customText;
    if (_selectedOptionId == 'custom') {
      customText = _customOptionController.text.trim();
      if (customText.isEmpty) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.pollWriteResponse)));
        }
        return;
      }
    }

    setState(() => _isSubmitting = true);
    try {
      await ref.read(pollsNotifierProvider.notifier).vote(
        widget.poll.id, 
        _selectedOptionId!,
        customOptionText: customText,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _requestRevertVote(String pollTitle) async {
    setState(() => _isSubmitting = true);
    try {
      await ref.read(pollsNotifierProvider.notifier).requestRevertVote(widget.poll.id, pollTitle, '');
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.revertRequestSent)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _customOptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final resident = ref.watch(authStateProvider).value;
    if (resident == null) return const SizedBox.shrink();

    final houseId = '${resident.lot}_${resident.house}';
    final hasVoted = widget.poll.hasHouseVoted(houseId);
    final votedUserName = hasVoted ? widget.poll.votedHouseholds[houseId] : null;
    final totalVotes = widget.poll.totalVotes;
    final bool iVoted = votedUserName == resident.name;
    final bool someoneElseFromMyHouseVoted = hasVoted && !iVoted;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.poll.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                if (!widget.poll.isActive)
                  Chip(
                    label: Text(l10n.closed, style: const TextStyle(color: VecinalColors.white)),
                    backgroundColor: VecinalColors.red800,
                  )
                else if (hasVoted)
                  Chip(
                    label: Text(l10n.alreadyVoted, style: const TextStyle(color: VecinalColors.white)),
                    backgroundColor: VecinalColors.green800,
                  )
              ],
            ),
            if (widget.poll.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(widget.poll.description, style: TextStyle(color: VecinalColors.gray400)),
            ],
            const SizedBox(height: 16),

            // === ALREADY VOTED: show results ===
            if (hasVoted) ...[
              // Info banner
              if (someoneElseFromMyHouseVoted)
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: VecinalColors.amber400.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: VecinalColors.amber400),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.alreadyVotedByOther(votedUserName ?? '', resident.lot, resident.house),
                          style: TextStyle(color: VecinalColors.amber400),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),

              // Pie chart
              if (totalVotes > 0)
                Center(
                  child: SizedBox(
                    width: 180,
                    height: 180,
                    child: CustomPaint(
                      painter: _PieChartPainter(
                        options: widget.poll.options,
                        totalVotes: totalVotes,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),

              // Legend / Results
              ...widget.poll.options.asMap().entries.map((entry) {
                final option = entry.value;
                final index = entry.key;
                final percent = totalVotes == 0 ? 0.0 : (option.votesCount / totalVotes);
                final color = _pieColors[index % _pieColors.length];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(width: 14, height: 14, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Expanded(child: Text(option.text, style: const TextStyle(fontWeight: FontWeight.w500))),
                      Text('${(percent * 100).toStringAsFixed(1)}% (${option.votesCount})'),
                    ],
                  ),
                );
              }),

              // Revert button
              if (widget.poll.isActive && iVoted)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _isSubmitting ? null : () => _requestRevertVote(widget.poll.title),
                    child: _isSubmitting
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(l10n.requestRevertVote, style: const TextStyle(color: VecinalColors.red600)),
                  ),
                ),
            ]

            // === NOT VOTED: show options ===
            else if (widget.poll.isActive) ...[
              ...widget.poll.options.map((option) {
                return RadioListTile<String>(
                  title: Text(option.text),
                  value: option.id,
                  groupValue: _selectedOptionId,
                  onChanged: (val) {
                    setState(() => _selectedOptionId = val);
                  },
                  contentPadding: EdgeInsets.zero,
                );
              }),
              if (widget.poll.allowCustomOptions) ...[
                RadioListTile<String>(
                  title: Text(l10n.pollOtherOption),
                  value: 'custom',
                  groupValue: _selectedOptionId,
                  onChanged: (val) {
                    setState(() => _selectedOptionId = val);
                  },
                  contentPadding: EdgeInsets.zero,
                ),
                if (_selectedOptionId == 'custom')
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: TextField(
                      controller: _customOptionController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: l10n.pollWriteResponseHint,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                  ),
              ],
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _selectedOptionId == null || _isSubmitting ? null : _submitVote,
                  child: _isSubmitting
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: VecinalColors.white, strokeWidth: 2))
                      : Text(l10n.vote),
                ),
              ),
            ]

            // === CLOSED and never voted ===
            else ...[
              Text(l10n.pollClosedNoVote),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Pie Chart Colors ───────────────────────────────────────────────────
const _pieColors = [
  Color(0xFF26A69A), // teal
  Color(0xFFEF5350), // red
  Color(0xFF42A5F5), // blue
  Color(0xFFFFCA28), // amber
  Color(0xFFAB47BC), // purple
  Color(0xFFFF7043), // deep orange
  Color(0xFF66BB6A), // green
  Color(0xFF8D6E63), // brown
];

// ─── Custom Pie Chart Painter ───────────────────────────────────────────
class _PieChartPainter extends CustomPainter {
  final List<PollOptionEntity> options;
  final int totalVotes;

  _PieChartPainter({required this.options, required this.totalVotes});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;
    double startAngle = -pi / 2; // Start from top

    for (int i = 0; i < options.length; i++) {
      final option = options[i];
      final sweepAngle = totalVotes == 0 ? 0.0 : (option.votesCount / totalVotes) * 2 * pi;

      if (sweepAngle > 0) {
        final paint = Paint()
          ..color = _pieColors[i % _pieColors.length]
          ..style = PaintingStyle.fill;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          true,
          paint,
        );

        // Draw separator line
        final separatorPaint = Paint()
          ..color = VecinalColors.black.withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          startAngle,
          sweepAngle,
          true,
          separatorPaint,
        );

        // Draw percentage label inside slice
        final midAngle = startAngle + sweepAngle / 2;
        final labelRadius = radius * 0.6;
        final labelX = center.dx + labelRadius * cos(midAngle);
        final labelY = center.dy + labelRadius * sin(midAngle);
        final percent = (option.votesCount / totalVotes * 100).toStringAsFixed(0);

        if (sweepAngle > 0.3) { // Only show label if slice is big enough
          final textPainter = TextPainter(
            text: TextSpan(
              text: '$percent%',
              style: TextStyle(
                color: VecinalColors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(blurRadius: 2, color: VecinalColors.gray600)],
              ),
            ),
            textDirection: TextDirection.ltr,
          )..layout();

          textPainter.paint(
            canvas,
            Offset(labelX - textPainter.width / 2, labelY - textPainter.height / 2),
          );
        }

        startAngle += sweepAngle;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
