import 'package:application_mobile_educative_college/models/matiere_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../models/progress_model.dart';
import '../../../../services/data_service.dart';
import 'subject_card.dart';
import '../../pages/subjects_page.dart';

class SubjectsSection extends StatelessWidget {
  final ThemeData theme;
  final UserProgress? userProgress;

  const SubjectsSection({
    super.key,
    required this.theme,
    required this.userProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Matière',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SubjectsPage()),
                );
              },
              icon: Icon(
                Icons.arrow_forward,
                color: theme.colorScheme.primary,
                size: 18,
              ),
              label: Text(
                'Voir toutes',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: DataService.matieres.length,
            itemBuilder: (context, index) {
              final MatiereModel matiere = DataService.matieres[index];
              final String subjectName = matiere.nom;

              final subjectProgress =
                  userProgress?.subjectProgress
                      .where((p) => p.subject == subjectName)
                      .firstOrNull;

              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: Container(
                      width: 200,
                      margin: EdgeInsets.only(
                        right: index < DataService.matieres.length - 1 ? 16 : 0,
                      ),
                      child: SubjectCard(
                        subject: subjectName,
                        progress: subjectProgress,
                        index: index,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>SubjectsPage(initalSubject: subjectName),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
