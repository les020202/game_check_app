import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../viewmodel/app_preferences.dart';
import '../viewmodel/provider/game_provider.dart';
import '../viewmodel/provider/game_template_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';

class OnboardingGamePresetPage extends StatefulWidget {
  const OnboardingGamePresetPage({super.key});

  @override
  State<OnboardingGamePresetPage> createState() =>
      _OnboardingGamePresetPageState();
}

class _OnboardingGamePresetPageState extends State<OnboardingGamePresetPage> {
  bool _isSaving = false;

  Future<void> _saveAndNavigate(String destinationPath) async {
    setState(() => _isSaving = true);
    final gameTemplateProvider =
        context.read<GameTemplateProvider>();
    final gp = context.read<GameProvider>();
    await gameTemplateProvider.createGameFromSelectedTemplate(gp);
    gameTemplateProvider.reset();
    await AppPreferences.setOnboardingDone();
    if (mounted) context.go(destinationPath);
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final gameTemplateProvider = context.watch<GameTemplateProvider>();
    final template = gameTemplateProvider.selectedTemplate!;

    if (_isSaving) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final presetSections = <List<String>>[
      [
        '일일 퀘스트(공통)',
        ...(template.dailyItems.isEmpty
            ? ['없음']
            : template.dailyItems.map((d) => d.name)),
      ],
      [
        '캐릭터별 주간 퀘스트',
        ...(template.characterTemplate.weeklyItems.isEmpty
            ? ['없음']
            : template.characterTemplate.weeklyItems.map((q) => q.name)),
      ],
      [
        '캐릭터별 월간 퀘스트',
        ...(template.characterTemplate.monthlyItems.isEmpty
            ? ['없음']
            : template.characterTemplate.monthlyItems.map((q) => q.name)),
      ],
      [
        '캐릭터별 목표',
        ...(template.characterTemplate.goalItems.isEmpty
            ? ['없음']
            : template.characterTemplate.goalItems.map((q) => q.name)),
      ],
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: '초기 설정',
        actions: [
          Text('3 / 3',
              style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const ClipRRect(
                      child: LinearProgressIndicator(
                        value: 3 / 3,
                        backgroundColor: Colors.grey,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('초기 설정을 확인 해주세요',
                        style: textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: colorScheme.onPrimary,
                        border: Border.all(color: Colors.grey),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: presetSections.length,
                        itemBuilder: (context, index) {
                          final section = presetSections[index];
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(section[0],
                                    style: textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: colorScheme.primary)),
                                const SizedBox(height: 6),
                                for (int i = 1; i < section.length; i++)
                                  Text('● ${section[i]}',
                                      style: textTheme.bodyMedium
                                          ?.copyWith(fontWeight: FontWeight.w400)),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const Divider(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CustomButton(
              customText: '이 프리셋 사용하기',
              backgroundColors: colorScheme.primary,
              fontStyle: textTheme.bodyMedium!
                  .copyWith(color: colorScheme.onPrimary, fontWeight: FontWeight.w400),
              onPressed: () => _saveAndNavigate('/game_main_page'),
            ),
            CustomButton(
              customText: '추가 설정하고 시작하기',
              backgroundColors: colorScheme.onPrimary,
              fontStyle: textTheme.bodyMedium!
                  .copyWith(color: colorScheme.primary, fontWeight: FontWeight.w400),
              borderSide: BorderSide(color: colorScheme.primary),
              onPressed: () => _saveAndNavigate(
                '/game_main_page/game_setup_page?games_index=0',
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () async{
                  context.read<GameTemplateProvider>().reset();
                  await AppPreferences.setOnboardingDone();
                  context.go('/game_main_page');
                },
                child: Text(
                  '사용하지 않고 시작할게요',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade700,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}