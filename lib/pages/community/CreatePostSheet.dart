import 'package:bhakti_bhoomi/services/apis/PostApi.dart';
import 'package:bhakti_bhoomi/singletons/NotificationService.dart';
import 'package:bhakti_bhoomi/theme/app_colors.dart';
import 'package:bhakti_bhoomi/theme/app_typography.dart';
import 'package:bhakti_bhoomi/widgets/common/primary_button.dart';
import 'package:flutter/material.dart';

/// Compose a new community post (text). Returns true via Navigator.pop on success.
class CreatePostSheet extends StatefulWidget {
  const CreatePostSheet({super.key});

  @override
  State<CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends State<CreatePostSheet> {
  final _controller = TextEditingController();
  bool _posting = false;

  Future<void> _post() async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;
    setState(() => _posting = true);
    try {
      await PostApi().create(content: content);
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted) {
        setState(() => _posting = false);
        NotificationService.showSnackbar(text: 'Could not post. Please try again.', color: Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(2))),
          ),
          const SizedBox(height: 16),
          Text('Share with the Sangha', style: AppTypography.textTheme.headlineSmall),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            maxLines: 5,
            minLines: 3,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'A reflection, a blessing, a question…'),
          ),
          const SizedBox(height: 16),
          PrimaryButton(label: 'Post', loading: _posting, onPressed: _post),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
