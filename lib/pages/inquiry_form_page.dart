import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'dart:typed_data';

import '../services/firebase_storage_service.dart';
import '../widgets/custom_button.dart';
import '/widgets/tag_filter.dart';
import '/widgets/custom_app_bar.dart';
import '../utils/show_snackbar.dart';
import '../viewmodel/provider/firestore_support_provider.dart';

class InquiryFormPage extends StatefulWidget {
  InquiryFormPage({super.key});

  @override
  State<InquiryFormPage> createState() => _InquiryFormPageState();
}

class _InquiryFormPageState extends State<InquiryFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  int _selectedTag = 0;
  bool _isSending = false;

  List<String> customerTypeNames = ['계정', '게임 설정', '오류 신고', '기타']; //, '알림'

  Uint8List? _imageBytes;
  String? _imagePath;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    if (bytes.length > 5 * 1024 * 1024) {
      if (mounted) showSnackBar(context, '5MB 이하의 이미지만 첨부할 수 있어요.');
      return;
    }
    if (!mounted) return;
    setState(() {
      _imageBytes = bytes;
      _imagePath = picked.path;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSending) return;
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email;
    if (user == null || email == null) {
      showSnackBar(context, '로그인이 필요해요.');
      return;
    }

    setState(() => _isSending = true);
    try {
      final inquiryId = const Uuid().v4();
      String? imageUrl;
      if (_imageBytes != null) {
        imageUrl = await FirebaseStorageService().uploadInquiryImage(
          bytes: _imageBytes!,
          path: _imagePath ?? '',
          uid: user.uid,
          inquiryId: inquiryId,
        );
      }
      if (!mounted) return;
      await Provider.of<FirestoreSupportProvider>(
        context,
        listen: false,
      ).addInquiry(
        id: inquiryId,
        contactEmail: email,
        tag: customerTypeNames[_selectedTag],
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        imageUrl: imageUrl,
      );
      if (!mounted) return;
      showSnackBar(context, '문의가 접수되었습니다.');
      context.go('/my_page/customer_service_page');
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSending = false);
      showSnackBar(context, '문의 접수에 실패했습니다. 잠시 후 다시 시도해주세요.');
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    final isCheckeds = List.generate(
      customerTypeNames.length,
      (i) => i == _selectedTag,
    );
    return Scaffold(
      appBar: CustomAppBar(title: '문의하기'),
      body: SafeArea(
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '태그   ',
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '   하나만 선택해주세요',
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: customerTypeNames.length,
                        itemBuilder: (context, index) {
                          return TagFilter(
                            onTap: () => setState(() => _selectedTag = index),
                            isCheckeds: isCheckeds,
                            typeNames: customerTypeNames,
                            index: index,
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _titleController,
                      maxLength: 100,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? '제목을 입력해주세요' : null,
                      decoration: InputDecoration(
                        labelText: '제목',
                        labelStyle: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        filled: true,
                        fillColor: colorScheme.onPrimary,
                        hintText: '문의 제목을 입력해주세요\n(최대100자)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    SizedBox(height: 40),
                    TextFormField(
                      controller: _contentController,
                      maxLength: 3000,
                      maxLines: 8,
                      minLines: 5,
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? '내용을 입력해주세요' : null,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        labelText: '내용',
                        labelStyle: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        filled: true,
                        fillColor: colorScheme.onPrimary,
                        hintText:
                            '어떤 문제가 있으셨나요?\n어떤 화면에서 발생했는지,\n언제부터 그랬는지 적어주시면\n더 빠르게 도와드릴 수 있어요.\n(최대 3000자)',
                        hintMaxLines: 5,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: _pickImage,
                      child: _imageBytes == null
                          ? DottedBorder(
                              options: RoundedRectDottedBorderOptions(
                                dashPattern: [6, 3],
                                strokeWidth: 1.5,
                                radius: Radius.circular(12),
                                color: Colors.grey,
                                padding: EdgeInsets.zero,
                              ),
                              child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: colorScheme.onPrimary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add_photo_alternate),
                                    SizedBox(height: 6),
                                    Text(
                                      '이미지 첨부',
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Text(
                                      '(선택)',
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.memory(
                                    _imageBytes!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () => setState(() {
                                      _imageBytes = null;
                                      _imagePath = null;
                                    }),
                                    child: const CircleAvatar(
                                      radius: 12,
                                      backgroundColor: Colors.black54,
                                      child: Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          Icon(Icons.error, color: colorScheme.primary),
                          SizedBox(width: 6),
                          Text(
                            '답변은 가입하신 계정의 이메일로 보내드립니다.\n(답변 메일이 안보일 경우 스펨함을 확인해주세요.)',
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w400,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '문의 접수를 위해 이메일 주소, 문의 내용(및 첨부 이미지)을 수집하며, 회원 탈퇴 시 파기됩니다. 자세한 내용은 개인정보 처리방침을 확인해주세요.',
                      style: textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                    CustomButton(
                      customText: _isSending ? '보내는 중...' : '문의 보내기',
                      onPressed: _submit,
                      backgroundColors: colorScheme.primary,
                      fontStyle: textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onPrimary,
                      ),
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
}
