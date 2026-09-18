import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '/widgets/custom_dotted_button.dart';
import '/widgets/app_switch.dart';
import '/widgets/custom_app_bar.dart';

class NotificationSettingsPage extends StatefulWidget {
  NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool isOn = false; //임시
  List<bool> isCheckeds = [false, false]; //임시
  List<String> games = ['메이플스토리', '로스트아크'];
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CustomAppBar(title: '알림 설정'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '등록된 알림',
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 12),
                      Opacity(
                        //나중에 로직할때 내가 추가한 알림만큼 늘어나게 수정해야함
                        opacity: isOn ? 1.0 : 0.4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorScheme.onPrimary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '오후 9:00',
                                    style: textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    '메이플스토리, 로스트아크',
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              AppSwitch(
                                value: isOn,
                                onChanged: (v) {
                                  setState(() {
                                    isOn = v;
                                  });
                                },
                                scale: 0.8,
                              ),
                              IconButton(
                                onPressed: () {
                                  //알림 삭제 로직
                                },
                                color: Colors.red,
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Divider(),
                      SizedBox(height: 12),
                      Text(
                        '새 알림 추가',
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        '게임 선택  (여러 개 선택 가능)',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 12),
                      ...getGameList(colorScheme, textTheme, isCheckeds, games),
                      SizedBox(height: 24),
                      Text(
                        '알림 시간 설정  (직접 스크롤해서 설정)',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 12),
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: colorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: CupertinoPicker(
                                itemExtent: 32,
                                onSelectedItemChanged: (int index) {},
                                children: List.generate(24, (index) {
                                  return Center(
                                    child: Text(
                                      '${index.toString().padLeft(2, '0')} 시',
                                      style: textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: colorScheme.primary,
                                      ),
                                    ), // 00, 01, 02 ...
                                  );
                                }),
                              ),
                            ),
                            Text(':', style: TextStyle(fontSize: 24)),
                            Expanded(
                              child: CupertinoPicker(
                                itemExtent: 32,
                                onSelectedItemChanged: (int index) {},
                                children: List.generate(60, (index) {
                                  return Center(
                                    child: Text(
                                      '${index.toString().padLeft(2, '0')} 분',
                                      style: textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: colorScheme.primary,
                                      ),
                                    ), // 00, 01, 02 ...
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              CustomDottedButton(
                customText: '알림 추가하기',
                onPressed: () {
                  setState(() {
                    //알림 추가 로직
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Container> getGameList(
    ColorScheme colorScheme,
    TextTheme textTheme,
    List<bool> isCheckeds,
    List<String> games,
  ) {
    List<Container> gameList = [];
    for (int i = 0; i < isCheckeds.length; i++) {
      gameList.add(
        Container(
          decoration: BoxDecoration(
            color: isCheckeds[i] ? Colors.blue.shade50 : colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isCheckeds[i] ? colorScheme.primary : colorScheme.onPrimary,
            ),
          ),
          child: Row(
            children: [
              Checkbox(
                value: isCheckeds[i],
                onChanged: (value) {
                  setState(() {
                    isCheckeds[i] = value!;
                  });
                },
              ),
              Text(
                '${games[i]}',
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return gameList;
  }
}
