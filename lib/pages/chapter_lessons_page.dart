import 'package:flutter/material.dart';
import '../models/chapitre_model.dart';
import '../models/lecon_model.dart';
import '../services/data_service.dart';
import 'lesson_page.dart';

class ChapterLessonsPage extends StatefulWidget {
  final ChapitreModel chapitre;
  final Color subjectColor;

  const ChapterLessonsPage({
    super.key,
    required this.chapitre,
    required this.subjectColor,
  });

  @override
  State<ChapterLessonsPage> createState() => _ChapterLessonsPageState();
}

class _ChapterLessonsPageState extends State<ChapterLessonsPage> {
  List<LeconModel> lecons = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLecons();
  }

  Future<void> _loadLecons() async {
    await DataService.loadChapitreLecons(widget.chapitre.id);
    setState(() {
      lecons = DataService.lecons;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chapitre.nom),
        backgroundColor: widget.subjectColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : lecons.isEmpty
              ? Center(
                  child: Text(
                    'Aucune leçon pour ce chapitre.',
                    style: theme.textTheme.titleMedium,
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: lecons.length,
                  itemBuilder: (context, index) {
                    final lecon = lecons[index];
                    return _buildLessonCard(context, lecon, index, theme, widget.subjectColor);
                  },
                ),
    );
  }

  Widget _buildLessonCard(BuildContext context, LeconModel lecon, int index, ThemeData theme, Color subjectColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withAlpha((0.2 * 255).round()),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LessonPage(lecon: lecon),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: subjectColor.withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: subjectColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lecon.titre,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
}