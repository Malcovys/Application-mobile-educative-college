import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CustomProgressIndicator extends StatelessWidget {
  final double progress;
  final String title;
  final String subtitle;
  final Color color;
  final double size;
  final bool showPercentage;

  const CustomProgressIndicator({
    super.key,
    required this.progress,
    required this.title,
    required this.subtitle,
    required this.color,
    this.size = 80,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        CircularPercentIndicator(
          radius: size / 2,
          lineWidth: 8.0,
          percent: progress.clamp(0.0, 1.0),
          center:
              showPercentage
                  ? Text(
                    '${(progress * 100).toInt()}%',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  )
                  : Icon(Icons.check_circle, color: color, size: size / 3),
          progressColor: color,
          backgroundColor: color.withAlpha((0.2 * 255).round()),
          circularStrokeCap: CircularStrokeCap.round,
          animation: true,
          animationDuration: 1200,
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha((0.7 * 255).round()),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class ProgressRow extends StatelessWidget {
  final String label;
  final double progress;
  final Color color;
  final String? trailing;

  const ProgressRow({
    super.key,
    required this.label,
    required this.progress,
    required this.color,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              if (trailing != null)
                Text(
                  trailing!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(
                      (0.7 * 255).round(),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          LinearPercentIndicator(
            padding: EdgeInsets.zero,
            lineHeight: 8,
            percent: progress.clamp(0.0, 1.0),
            progressColor: color,
            backgroundColor: color.withAlpha((0.2 * 255).round()),
            barRadius: const Radius.circular(4),
            animation: true,
            animationDuration: 1000,
          ),
        ],
      ),
    );
  }
}

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withAlpha((0.2 * 255).round()),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withAlpha((0.1 * 255).round()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Text(
                value,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(
                  (0.7 * 255).round(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
