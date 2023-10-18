import 'package:flutter/material.dart' hide AppBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/constants.dart';
import '../../widgets/app_bar.dart';
import '../blueprint/blueprint_view.dart';
import 'widgets/feedback_form_actions.dart';
import 'widgets/feedback_form_view.dart';

class FeedbackView extends ConsumerStatefulWidget {
  const FeedbackView({super.key});

  @override
  ConsumerState<FeedbackView> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends ConsumerState<FeedbackView> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController labelsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlueprintView(
      appBar: const AppBar(
        pathNames: ['Settings', 'Feedback'],
      ),
      body: Column(
        children: [
          Expanded(child: FeedbackFormView(formKey: formKey)),
          SizedBox(height: gap),
          FeedbackFormActions(formKey: formKey),
        ],
      ),
    );
  }
}
