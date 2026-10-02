import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/provider/game_provider.dart';

/// 삭제 성공 시 true, 취소/실패 시 false 또는 null
Future<bool?> showGameDeleteDialog(BuildContext context, String gameId) {
  return showDialog<bool>(
    context: context,
    builder: (_) => _GameDeleteDialog(deleteGameId: gameId),
  );
}

class _GameDeleteDialog extends StatefulWidget {
  final String deleteGameId;
  const _GameDeleteDialog({required this.deleteGameId});

  @override
  State<_GameDeleteDialog> createState() => _GameDeleteDialogState();
}

class _GameDeleteDialogState extends State<_GameDeleteDialog> {
  bool _isDeleting = false;
  String? _errorMessage;

  Future<void> _delete() async {
    setState(() {
      _isDeleting = true;
      _errorMessage = null;
    });
    try {
      await Provider.of<GameProvider>(
        context,
        listen: false,
      ).deleteGame(widget.deleteGameId);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isDeleting = false;
        _errorMessage = '삭제에 실패했습니다.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Text('게임 삭제 확인',style: textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
      )),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('정말 해당 게임을 삭제하시겠습니까?',style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w400,
          )),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isDeleting ? null : () => Navigator.pop(context, false),
          child: Text('취소',style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w700,
          )),
        ),
        FilledButton(
          onPressed: _isDeleting ? null : _delete,
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.error,
            foregroundColor: colorScheme.onError,
          ),
          child: _isDeleting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text('삭제하기',style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onPrimary,
                )),
        ),
      ],
    );
  }
}
