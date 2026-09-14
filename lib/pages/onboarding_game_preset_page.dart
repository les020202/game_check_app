import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';

class OnboardingGamePresetPage extends StatelessWidget {
  OnboardingGamePresetPage({super.key});
  final List<List<String>> gamePresetList = [
    ['일일 퀘스트(공통)', '일일 퀘스트', '몬스터 파크'],
    ['캐릭터별 주간 퀘스트', '없음'],
    ['캐릭터별 월간 퀘스트', '없음'],
    ['캐릭터별 목표', '없음'],
  ]; //임시
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
      body: Padding(
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
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey),
                      ),
                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: gamePresetList.length,
                        itemBuilder: (context, index) {
                          final gamePreset = gamePresetList[index];
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${gamePreset[0]}',
                                      style: textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    for (int i = 1; i < gamePreset.length; i++)
                                      Text(
                                        '● ${gamePreset[i]}',
                                        style: textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const Divider();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CustomButton(
              customText: '이 프리셋 사용하기',
              backgroundColors: colorScheme.primary,
              fontStyle: textTheme.bodyMedium!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
              onPressed: () {
                context.go('/game_main_page');
              },
            ),
            CustomButton(
              customText: '추가 설정하고 시작하기',
              backgroundColors: Colors.white,
              fontStyle: textTheme.bodyMedium!.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w400,
              ),
              borderSide: BorderSide(color: colorScheme.primary),
              onPressed: () {
                context.go('/game_main_page/game_setup_page');
              },
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
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
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
