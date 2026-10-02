import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/game_template.dart';
import '../models/game_type.dart';
import '../viewmodel/provider/game_template_provider.dart';
import '../utils/show_snackbar.dart';

/// 템플릿을 고르고 적용을 확정하면 그 템플릿을, 취소하면 null을 반환
Future<GameTemplate?> showGameTemplatePicker(
  BuildContext context,
  GameType gameType,
  TextTheme textTheme,
  ColorScheme colorScheme,
) async {
  final templateProvider = context.read<GameTemplateProvider>();

  List<GameTemplate> templates;
  try {
    templates = await templateProvider.getTemplatesForType(gameType);
  } catch (e) {
    if (context.mounted) showSnackBar(context, '템플릿을 불러오지 못했습니다.');
    return null;
  }
  if (!context.mounted) return null;

  if (templates.isEmpty) {
    showSnackBar(context, '해당 유형의 템플릿이 없습니다.');
    return null;
  }

  final selected = await showModalBottomSheet<GameTemplate>(
    context: context,
    builder: (sheetContext) => SafeArea(
      // ← '_' 대신 이름 붙여서 받기
      child: ListView(
        shrinkWrap: true,
        children: templates.map((t) {
          return ListTile(
            title: Text(t.gameName),
            onTap: () => Navigator.pop(sheetContext, t), // ← 시트의 context 사용
          );
        }).toList(),
      ),
    ),
  );

  if (selected == null || !context.mounted) return null;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(
        '템플릿 적용',
        style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      content: Text(
        '현재 입력한 내용이 "${selected.gameName}" 템플릿 내용으로 대체됩니다. 계속할까요?',
        style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: Text(
            '취소',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
          ),
          child: Text(
            '적용',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700,color: colorScheme.onPrimary),
          ),
        ),
      ],
    ),
  );

  return confirmed == true ? selected : null;
}
