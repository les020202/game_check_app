import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_agreement.dart';
import '../pages/terms_detail_page.dart';
import '../services/firestore_support_service.dart';
import '../utils/show_snackbar.dart';
import '../viewmodel/provider/firebase_auth_provider.dart';

// 방금 생성된 계정인지 (생성 시각 ≈ 마지막 로그인 시각)
bool _isNewlyCreated(User user) {
  final created = user.metadata.creationTime;
  final last = user.metadata.lastSignInTime;
  if (created == null || last == null) return false;
  return last.difference(created).inSeconds.abs() < 5;
}

// 동의를 받지 못한 경우: 신규 계정이면 삭제, 항상 로그아웃
Future<void> _abortSignIn(
  FirebaseAuthProvider auth,
  User? user, {
  required bool deleteAccount,
}) async {
  if (deleteAccount && user != null) {
    try {
      await user.delete();
    } catch (_) {
      // 삭제 실패 시에도 로그아웃은 진행
    }
  }
  await auth.signOut();
}

/// 약관 동의 기록이 없으면 동의 다이얼로그를 띄운다.
/// true → 계속 진행, false → 취소/실패 (이미 signOut 처리됨)
Future<bool> ensureTermsAgreement(BuildContext context) async {
  final auth = context.read<FirebaseAuthProvider>();
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return true;
  final uid = user.uid;

  final service = FirestoreSupportService(uid);

  try {
    if (await service.getUserAgreement() != null) return true; // 이미 동의함
  } catch (e) {
    // 기존 계정일 수도 있으므로 삭제하지 않고 로그아웃만
    await auth.signOut();
    if (context.mounted) showSnackBar(context, '약관 정보를 확인하지 못했어요. 다시 시도해주세요.');
    return false;
  }
  if (!context.mounted) return false;

  final isNew = _isNewlyCreated(user);

  // 반환: null이면 취소, 아니면 마케팅 동의 여부
  final marketing = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const _TermsConsentDialog(),
  );

  if (marketing == null) {
    await _abortSignIn(auth, user, deleteAccount: isNew);
    if (context.mounted) showSnackBar(context, '약관에 동의해야 서비스를 이용할 수 있어요.');
    return false;
  }

  try {
    final now = DateTime.now();
    await service.setUserAgreement(
      UserAgreement(
        uid: uid,
        termsOfService: AgreementStatus(agreed: true, agreedAt: now),
        privacyPolicy: AgreementStatus(agreed: true, agreedAt: now),
        marketingConsent: marketing,
        marketingUpdatedAt: now,
      ),
    );
    return true;
  } catch (e) {
    await _abortSignIn(auth, user, deleteAccount: isNew);
    if (context.mounted) showSnackBar(context, '동의 정보를 저장하지 못했어요. 다시 시도해주세요.');
    return false;
  }
}

class _TermsConsentDialog extends StatefulWidget {
  const _TermsConsentDialog();

  @override
  State<_TermsConsentDialog> createState() => _TermsConsentDialogState();
}

class _TermsConsentDialogState extends State<_TermsConsentDialog> {
  bool _age = false;
  bool _terms = false;
  bool _privacy = false;
  bool _marketing = false;

  bool get _all => _age && _terms && _privacy; // 필수만 포함
  bool get _requiredOk => _age && _terms && _privacy;

  void _openTerms(int index) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TermsDetailPage(termsIndex: index)),
    );
  }

  Widget _tile(bool value, ValueChanged<bool?> onChanged, String title,
      {int? termsIndex}) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title),
      controlAffinity: ListTileControlAffinity.leading,
      secondary: termsIndex == null
          ? null
          : IconButton(
              onPressed: () => _openTerms(termsIndex),
              icon: const Icon(Icons.arrow_forward_ios, size: 18),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AlertDialog(
      title: Text('약관 동의',
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CheckboxListTile(
              value: _all,
              onChanged: (v) => setState(() {
                _age = _terms = _privacy = v ?? false; // 마케팅은 건드리지 않음
              }),
              title: Text('필수 약관 전체 동의',
                  style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const Divider(),
            _tile(_age, (v) => setState(() => _age = v ?? false),
                '[필수] 만 14세 이상입니다'),
            _tile(_terms, (v) => setState(() => _terms = v ?? false),
                '[필수] 이용약관 동의', termsIndex: 0),
            _tile(_privacy, (v) => setState(() => _privacy = v ?? false),
                '[필수] 개인정보 수집 및 이용 동의', termsIndex: 1),
            _tile(_marketing, (v) => setState(() => _marketing = v ?? false),
                '[선택] 마케팅 정보 수신 동의', termsIndex: 2),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // null → 취소
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _requiredOk ? () => Navigator.pop(context, _marketing) : null,
          child: const Text('동의하고 계속'),
        ),
      ],
    );
  }
}