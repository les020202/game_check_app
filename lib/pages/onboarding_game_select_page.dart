import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/game_type.dart';
import '../viewmodel/app_preferences.dart';
import '../viewmodel/provider/game_template_provider.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';

class OnboardingGameSelectPage extends StatelessWidget {
  const OnboardingGameSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final gameTemplateProvider = context.watch<GameTemplateProvider>();
    final templates = gameTemplateProvider.filteredTemplates;

    if (gameTemplateProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: '초기 설정',
        actions: [
          Text('2 / 3',
              style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400)),
        ],
      ),
      body: SafeArea(
        child: Padding(
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
                          value: 2 / 3,
                          backgroundColor: Colors.grey,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('즐겨하는 게임을\n하나 골라주세요',
                          style: textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 12),
                      if (templates.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            '선택한 타입에 해당하는 프리셋이 없어요.\n아래 버튼으로 넘어가주세요.',
                            style: textTheme.bodyMedium,
                          ),
                        ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: templates.length,
                        itemBuilder: (context, index) {
                          final template = templates[index];
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: colorScheme.onPrimary,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(template.gameName,
                                          style: textTheme.bodyLarge?.copyWith(
                                              fontWeight: FontWeight.w700)),
                                      Text(
                                        template.gameType == GameType.rpg
                                            ? 'RPG'
                                            : '모바일 게임',
                                        style: textTheme.bodyMedium?.copyWith(
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  Checkbox(
                                    value: gameTemplateProvider
                                        .isTemplateSelected(template),
                                    onChanged: (_) {
                                      context
                                          .read<GameTemplateProvider>()
                                          .selectTemplate(template);
                                    },
                                    shape: const CircleBorder(),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              CustomButton(
                customText: '다음',
                backgroundColors: colorScheme.primary,
                fontStyle: textTheme.bodyMedium!
                    .copyWith(color: colorScheme.onPrimary, fontWeight: FontWeight.w400),
                onPressed: () {
                  if (gameTemplateProvider.selectedTemplate == null) return;
                  context.go(
                    '/onboarding_game_select_page/onboarding_game_preset_page',
                  );
                },
              ),
              CustomButton(
                customText: '내가 하는 게임이 없어요, 넘어갈게요',
                backgroundColors: colorScheme.onPrimary,
                fontStyle: textTheme.bodyMedium!
                    .copyWith(color: colorScheme.primary, fontWeight: FontWeight.w400),
                borderSide: BorderSide(color: colorScheme.primary),
                onPressed: () async{
                  context.read<GameTemplateProvider>().reset();
                  await AppPreferences.setOnboardingDone();
                  context.go('/game_main_page');
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}