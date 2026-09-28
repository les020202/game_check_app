import 'package:flutter/material.dart';

/// 탈퇴 성공 시 true, 취소 시 false/null
Future<bool?> showReauthenticationDialog(
  BuildContext context,
  Future<void> Function(String password) onConfirm,
) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _ReauthenticationDialog(onConfirm: onConfirm),
  );
}

class _ReauthenticationDialog extends StatefulWidget {
  final Future<void> Function(String password) onConfirm;
  const _ReauthenticationDialog({required this.onConfirm});

  @override
  State<_ReauthenticationDialog> createState() =>
      _ReauthenticationDialogState();
}

class _ReauthenticationDialogState extends State<_ReauthenticationDialog> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final password = _passwordController.text;
    if (password.isEmpty) {
      setState(() => _errorMessage = '비밀번호를 입력하세요.');
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await widget.onConfirm(password);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('비밀번호 확인'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _passwordController,
            obscureText: true,
            enabled: !_isLoading,
            decoration: const InputDecoration(labelText: '비밀번호를 입력하세요'),
            onSubmitted: (_) => _submit(),
          ),
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
          onPressed: _isLoading ? null : () => Navigator.pop(context, false),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          child: _isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('탈퇴하기'),
        ),
      ],
    );
  }
}