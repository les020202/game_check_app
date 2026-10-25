import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/game_type.dart';
import '../utils/show_snackbar.dart';
import '../viewmodel/provider/game_template_provider.dart';
import '../widgets/custom_button.dart';

class OnboardingGameTypePage extends StatelessWidget {
  const OnboardingGameTypePage({super.key});

  static const List<List<String>> _labels = [
    ['RPG', '캐릭터 육성형 게임'],
    ['모바일 게임', '모바일 플랫폼 게임'],
  ];
  static const List<GameType> _values = [GameType.rpg, GameType.mobile];

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final onboardingProvider = context.watch<GameTemplateProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '초기 설정',
          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        actions: [
          Text(
            '1 / 3',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
          ),
        ],
        actionsPadding: const EdgeInsets.only(right: 20),
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
                          value: 1 / 3,
                          backgroundColor: Colors.grey,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '어떤 타입의 게임을\n즐겨 하시나요?',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '중복 선택 가능해요.',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _labels.length,
                        itemBuilder: (context, index) {
                          final type = _values[index];
                          final label = _labels[index];
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
                                      Text(
                                        label[0],
                                        style: textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        label[1],
                                        style: textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Checkbox(
                                    value: onboardingProvider.isTypeSelected(
                                      type,
                                    ),
                                    onChanged: (_) {
                                      context
                                          .read<GameTemplateProvider>()
                                          .toggleGameType(type);
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
                fontStyle: textTheme.bodyMedium!.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w400,
                ),
                onPressed: () async {
                  final provider = context.read<GameTemplateProvider>();
                  if (provider.selectedGameTypes.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('게임 타입을 선택해주세요')),
                    );
                    return;
                  }
                  try {
                    await provider.loadFilteredTemplates();
                    if (context.mounted)
                      context.go('/onboarding_game_select_page');
                  } catch (e, st) {
                    debugPrint('온보딩 1→2 이동 실패: $e\n$st');
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('에러: ${errorText(e)}')),
                      );
                    }
                  }
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
