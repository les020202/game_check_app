import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_dotted_button.dart';

class GameSetupPage extends StatefulWidget {
  GameSetupPage({super.key});

  @override
  State<GameSetupPage> createState() => _GameSetupPageState();
}

class _GameSetupPageState extends State<GameSetupPage> {
  final _formKey = GlobalKey<FormState>();

  final weekList = ['월', '화', '수', '목', '금', '토', '일'];

  final characterList = ['렌', '아크', '카인', '레테']; //임시
  final dailyQuestList = ['일일 퀘스트', '몬스터 파크']; //임시
  final weeklyQuestList = ['스우(하드)', '데미안(하드)']; //임시
  final monthlyQuestList = ['검은 마법사(하드)']; //임시
  final targetQuestList = ['자석펫 구매']; //임시

  int weekSelectedIndex = 0;
  int chracterSelectedIndex = 0;
  bool isDailyChecked = false;
  bool isChracterChecked = false;
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: CustomAppBar(title: '게임 설정'),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '게임 이름',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: '게임 이름을 입력하세요.',
                          filled: true,
                          fillColor: Colors.grey.shade300,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '게임 유형',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'RPG',
                                    style: textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text('캐릭터 여러 개', style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w400,
                                  )),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '모바일 게임',
                                    style: textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Text(
                                    '계정 1개', 
                                    style: textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      '게임 초기화 설정',
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '초기화 시간',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                                    index.toString().padLeft(2, '0'),
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
                                    index.toString().padLeft(2, '0'),
                                  ), // 00, 01, 02 ...
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      '주간 초기화 요일',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    ...getWeekButton(),
                    SizedBox(height: 12),
                    getCheckBox(
                      textTheme,
                      '일일 퀘스트 종류',
                      isDailyChecked,
                      (value) => setState(() => isDailyChecked = value),
                    ),
                    ...getDailyInputText('일일 퀘스트를 입력하세요.'),
                    CustomDottedButton(customText: '+ 일일 퀘스트 추가', onPressed: () {}),
                    SizedBox(height: 12),
                    getCheckBox(
                      textTheme,
                      '캐릭터별 설정',
                      isChracterChecked,
                      (value) => setState(() => isChracterChecked = value),
                    ),
                    Text(
                      '캐릭터별로 주/월 퀘스트와 목표를 설정할 수 있어요.',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    ...getCharacterButton(),
                    SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${characterList[chracterSelectedIndex]} 캐릭터 개별 설정',
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Divider(
                            height: 24, // 위아래 여백 포함 전체 높이
                            thickness: 1, // 선 두께
                            color: Colors.grey.shade300,
                            indent: 5, // 왼쪽 여백
                            endIndent: 5, // 오른쪽 여백
                          ),
                          Text(
                            '주간 퀘스트',
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          ...getWeeklyInputText('주간 퀘스트를 입력하세요.'),
                          CustomDottedButton(
                            customText: '+ 주간 퀘스트 추가',
                            onPressed: () {
                              setState(() {});
                            },
                          ),
                          Text(
                            '월간 퀘스트',
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          ...getMonthlyInputText('월간 퀘스트를 입력하세요.'),
                          CustomDottedButton(
                            customText: '+ 월간 퀘스트 추가',
                            onPressed: () {
                              setState(() {});
                            },
                          ),
                          Text(
                            '목표',
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          ...getTargetlyInputText('목표를 입력해주세요.'),
                          CustomDottedButton(
                            customText: '+ 목표 추가',
                            onPressed: () {
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12),
                    CustomButton(
                      customText: '설정 완료',
                      backgroundColors: colorScheme.primary,
                      fontStyle: textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                      onPressed: (){
                        context.go('/game_main_page/game_detail_page');
                      },
                      borderSide: BorderSide(color: colorScheme.primary,),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row getCheckBox(
    TextTheme textTheme,
    String text,
    bool isChecked,
    Function(bool) onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          text,
          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  onChanged(value ?? false);
                });
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            Text('없음'),
          ],
        ),
      ],
    );
  }

  List<Widget> getDailyInputText(String text) {
    List<Widget> dailyQuestWidget = [];
    for (int i = 0; i < dailyQuestList.length; i++) {
      dailyQuestWidget.add(
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: text,
              filled: true,
              fillColor: Colors.grey.shade300,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: IconButton(icon: Icon(Icons.close), onPressed: () {}),
            ),
          ),
        ),
      );
    }
    return dailyQuestWidget;
  }

  List<Widget> getWeeklyInputText(String text) {
    List<Widget> weeklyQuestWidget = [];
    for (int i = 0; i < weeklyQuestList.length; i++) {
      weeklyQuestWidget.add(
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: text,
              filled: true,
              fillColor: Colors.grey.shade300,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: IconButton(icon: Icon(Icons.close), onPressed: () {}),
            ),
          ),
        ),
      );
    }
    return weeklyQuestWidget;
  }

  List<Widget> getMonthlyInputText(String text) {
    List<Widget> monthlyQuestWidget = [];
    for (int i = 0; i < monthlyQuestList.length; i++) {
      monthlyQuestWidget.add(
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: text,
              filled: true,
              fillColor: Colors.grey.shade300,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: IconButton(icon: Icon(Icons.close), onPressed: () {}),
            ),
          ),
        ),
      );
    }
    return monthlyQuestWidget;
  }

  List<Widget> getTargetlyInputText(String text) {
    List<Widget> targetQuestWidget = [];
    for (int i = 0; i < targetQuestList.length; i++) {
      targetQuestWidget.add(
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: TextFormField(
            decoration: InputDecoration(
              hintText: text,
              filled: true,
              fillColor: Colors.grey.shade300,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: IconButton(icon: Icon(Icons.close), onPressed: () {}),
            ),
          ),
        ),
      );
    }
    return targetQuestWidget;
  }

  List<Widget> getWeekButton() {
    List<Widget> weekButton = [];
    bool isSelected;
    weekButton.add(
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(weekList.length, (index) {
            return Padding(
              padding: EdgeInsets.only(right: 1),
              child: ChoiceChip(
                label: Text(weekList[index]),
                selected: isSelected = weekSelectedIndex == index,
                onSelected: (bool selected) {
                  setState(() {
                    weekSelectedIndex = index;
                  });
                },
                showCheckmark: false,
                labelPadding: EdgeInsets.symmetric(horizontal: 4),
                selectedColor: Colors.blue,
                backgroundColor: Colors.white,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          }),
        ),
      ),
    );
    return weekButton;
  }

  List<Widget> getCharacterButton() {
    List<Widget> chracterButton = [];
    bool isSelected;
    chracterButton.add(
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...List.generate(characterList.length, (index) {
              return Padding(
                padding: EdgeInsets.only(right: 5),
                child: ChoiceChip(
                  label: Text(characterList[index]),
                  selected: isSelected = chracterSelectedIndex == index,
                  onSelected: (bool selected) {
                    setState(() {
                      chracterSelectedIndex = index;
                    });
                  },
                  showCheckmark: false,
                  labelPadding: EdgeInsets.symmetric(horizontal: 8),
                  selectedColor: Colors.blue,
                  backgroundColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: DottedBorder(
                options: CircularDottedBorderOptions(
                  dashPattern: [6, 3],
                  strokeWidth: 1.5,
                  color: Colors.blue,
                  padding: EdgeInsets.zero,
                ),
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      shape: CircleBorder(),
                      padding: EdgeInsets.zero,
                      side: BorderSide.none,
                    ),
                    child: Text('+',style: TextStyle(fontWeight: FontWeight.w700),),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    return chracterButton;
  }
}
