import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';

class OnboardingGameSelectPage extends StatefulWidget {
  const OnboardingGameSelectPage({super.key});

  @override
  State<OnboardingGameSelectPage> createState() =>
      _OnboardingGameSelectPageState();
}

class _OnboardingGameSelectPageState extends State<OnboardingGameSelectPage> {
  final List<List<String>> gameSelectList = [
    ['메이플스토리', 'RPG'],
    ['로스트아크', 'RPG'],
    ['명조', '모바일 게임'],
  ]; //임시
  int? selectedIndex;
  final List<bool> isCheckeds = [false, false, false]; //임시

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CustomAppBar(
        title: '초기 설정',
        actions: [
          Text(
            '2 / 3',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
          ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        child: LinearProgressIndicator(
                          value: 2 / 3,
                          backgroundColor: Colors.grey,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        '즐겨하는 게임을\n하나 골라주세요',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 12),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: gameSelectList.length,
                        itemBuilder: (context, index) {
                          final gameSelect = gameSelectList[index];
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                                        '${gameSelect[0]}',
                                        style: textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        '${gameSelect[1]}',
                                        style: textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Checkbox(
                                    value: selectedIndex == index,
                                    onChanged: (isChecked) {
                                      setState(() {
                                        selectedIndex =
                                            (isChecked! &&
                                                selectedIndex != index)
                                            ? index
                                            : null;
                                      });
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
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
                onPressed: () {
                  context.go(
                    '/onboarding_game_select_page/onboarding_game_preset_page',
                  );
                },
              ),
              CustomButton(
                customText: '내가 하는 게임이 없어요, 넘어갈게요',
                backgroundColors: Colors.white,
                fontStyle: textTheme.bodyMedium!.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w400,
                ),
                borderSide: BorderSide(color: colorScheme.primary),
                onPressed: () {
                  context.go('/game_main_page');
                },
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
