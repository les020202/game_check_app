import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_button.dart';

class OnboardingGameTypePage extends StatefulWidget {
  const OnboardingGameTypePage({super.key});

  @override
  State<OnboardingGameTypePage> createState() => _OnboardingGameTypePageState();
}

class _OnboardingGameTypePageState extends State<OnboardingGameTypePage> {
  final List<List<String>> gameTypeList = [
    ['RPG', '여러 캐릭터로 육성하는 게임'],
    ['모바일 게임', '계정 하나로 플레이하는 게임'],
  ];

  final List<bool> isCheckeds = [false, false];

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
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
        actionsPadding: EdgeInsets.only(right: 20),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              child: LinearProgressIndicator(
                value: 1 / 3,
                backgroundColor: Colors.grey,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 12),
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
            SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              itemCount: gameTypeList.length,
              itemBuilder: (context, index) {
                final gameType = gameTypeList[index];
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${gameType[0]}',
                              style: textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '${gameType[1]}',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        Checkbox(
                          value: isCheckeds[index],
                          onChanged: (isChecked) {
                            setState(() {
                              isCheckeds[index] = isChecked!;
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
            Spacer(),
            CustomButton(
              customText: '다음',
              backgroundColors: colorScheme.primary,
              fontStyle: textTheme.bodyMedium!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
              onPressed: () {
                context.go('/onboarding_game_select_page');
              },
            ),
            SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
