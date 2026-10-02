import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_agreement.dart';
import '../services/firestore_support_service.dart';
import '../utils/show_snackbar.dart';
import '../viewmodel/provider/firebase_auth_provider.dart';

/// 약관 동의 기록이 없으면 동의 다이얼로그를 띄운다.
/// true → 계속 진행, false → 취소/실패 (이미 signOut 처리됨)
Future<bool> ensureTermsAgreement(BuildContext context) async {
  final auth = context.read<FirebaseAuthProvider>();
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return true;

  final service = FirestoreSupportService(uid);

  try {
    if (await service.getUserAgreement() != null) return true; // 이미 동의함
  } catch (e) {
    await auth.signOut();
    if (context.mounted) showSnackBar(context, '약관 정보를 확인하지 못했어요. 다시 시도해주세요.');
    return false;
  }
  if (!context.mounted) return false;

  // 반환: null이면 취소, 아니면 마케팅 동의 여부
  final marketing = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const _TermsConsentDialog(),
  );

  if (marketing == null) {
    await auth.signOut();
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
      ),
    );
    return true;
  } catch (e) {
    await auth.signOut();
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
  bool _terms = false;
  bool _privacy = false;
  bool _marketing = false;

  bool get _all => _terms && _privacy;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AlertDialog(
      title: Text(
        '약관 동의',
        style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CheckboxListTile(
            value: _all,
            onChanged: (v) => setState(() {
              _terms = _privacy = v ?? false;
            }),
            title: Text('약관 전체 동의',
                style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const Divider(),
          CheckboxListTile(
            value: _terms,
            onChanged: (v) => setState(() => _terms = v ?? false),
            title: const Text('[필수] 이용약관 동의'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            value: _privacy,
            onChanged: (v) => setState(() => _privacy = v ?? false),
            title: const Text('[필수] 개인정보 수집 및 이용 동의'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          CheckboxListTile(
            value: _marketing,
            onChanged: (v) => setState(() => _marketing = v ?? false),
            title: const Text('[선택] 마케팅 정보 수신 동의'),
            controlAffinity: ListTileControlAffinity.leading,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // null → 취소
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: (_terms && _privacy)
              ? () => Navigator.pop(context, _marketing)
              : null,
          child: const Text('동의하고 계속'),
        ),
      ],
    );
  }
}