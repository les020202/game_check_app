import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../local/database.dart';
import '../services/drift_game_service.dart';
import '../services/firestore_game_service.dart';
import '../services/local_migration_service.dart';
import '../utils/show_snackbar.dart';
import '../viewmodel/provider/firebase_auth_provider.dart';
import '../viewmodel/provider/game_provider.dart';

enum LocalDataChoice { save, discard, cancel }

/// 로그인/회원가입 성공 직후 호출.
/// true → 계속 진행, false → 취소 또는 실패 (이미 signOut 처리됨)
Future<bool> handleLocalDataOnLogin(
  BuildContext context, {
  bool isNewAccount = false,
}) async {
  final db = context.read<AppDatabase>();
  final auth = context.read<FirebaseAuthProvider>();
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return true;

  final local = DriftGameService(db);
  if (!await local.hasLocalData()) return true;
  if (!context.mounted) return false;

  final choice = await showDialog<LocalDataChoice>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: const Text('기기에 저장된 데이터가 있어요'),
      content: Text(
        isNewAccount
            ? '기기에 저장된 데이터를 새 계정에 저장할까요?\n'
                  '버리면 기기에 저장된 데이터가 삭제돼요.'
            : '계정에 저장하면 기존 계정의 데이터가 덮어씌워져서 사라질 수 있어요.\n'
                  '버리면 기기에 저장된 데이터가 삭제돼요.',
      ),
      actions: [
        if (!isNewAccount)
          TextButton(
            onPressed: () => Navigator.pop(ctx, LocalDataChoice.cancel),
            child: const Text('로그인 취소'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, LocalDataChoice.discard),
          child: const Text('버리기'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, LocalDataChoice.save),
          child: const Text('계정에 저장'),
        ),
      ],
    ),
  );

  if (choice == null || choice == LocalDataChoice.cancel) {
    await auth.signOut();
    if (context.mounted) showSnackBar(context, '로그인이 취소되었습니다.');
    return false;
  }
  if (!context.mounted) return false;

  // 진행 중 표시
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  try {
    if (choice == LocalDataChoice.save) {
      await overwriteCloudWithLocal(local, FirestoreGameService(uid));
    }
    await local.clearAll(); // 저장/버리기 모두 로컬 초기화
    
    // 새 데이터가 화면에 반영되도록 목록 다시 로드
    if (context.mounted) {
      try {
        await context.read<GameProvider>().reloadAll();
      } catch (e) {
        debugPrint('reloadAll error: $e');// 이전은 끝났으니 로드 실패는 무시 (화면 진입 시 다시 로드됨)
      }
    }
    return true;
  } catch (e) {
    await auth.signOut(); // 로컬 데이터는 그대로 남아 있음
    if (context.mounted) {
      showSnackBar(context, '데이터 이전에 실패했어요. 다시 시도해주세요.');
    }
    return false;
  } finally {
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop(); // 로딩 닫기
    }
  }
}