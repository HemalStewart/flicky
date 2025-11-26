import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../data/auth_repository.dart';
import '../theme/app_colors.dart';
import '../widgets/background_collage.dart';
import '../widgets/flicky_mark.dart';

class SubscribeScreen extends StatefulWidget {
  SubscribeScreen({
    super.key,
    required this.onOtpRequested,
    required this.onLoginSuccess,
  });

  final void Function(String mobile) onOtpRequested;
  final VoidCallback onLoginSuccess;
  final TextEditingController _controller = TextEditingController();

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    widget._controller.dispose();
    super.dispose();
  }

  Future<void> _handleSendOtp() async {
    final mobile = widget._controller.text;
    setState(() => _loading = true);
    try {
      final result = await AuthService.instance.requestOtp(mobile);
      if (!mounted) return;
      if (result.userExists) {
        widget.onLoginSuccess();
      } else if (result.referenceNo != null) {
        widget.onOtpRequested(result.mobile);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP sent')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unexpected response, try again')),
        );
      }
    } on AuthDomainException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send OTP, try again')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    final slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          const BackgroundCollage(
            assetPath: 'assets/images/subscribe_bg.png',
            dim: 0.6,
          ),
          Container(color: const Color.fromRGBO(0, 0, 0, 0.4)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 16),
              child: SlideTransition(
                position: slide,
                child: FadeTransition(
                  opacity: fade,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),
                      const Hero(
                        tag: 'flicky-logo',
                        child: FlickyMark(size: 120),
                      ),
                      const SizedBox(height: 26),
                      Text(
                        'Flicky',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Subscribe to continue',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 28),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Enter your mobile number',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: TextField(
                          controller: widget._controller,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: '07X XXX XXXX',
                            hintStyle: TextStyle(color: AppColors.muted),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _loading ? null : _handleSendOtp,
                          child: _loading
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Send OTP',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'By clicking subscribe button, You are agree to our terms & condition. You can deactivate from the service anytime. LKR 12+ tax daily.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.muted, fontSize: 12),
                      ),
                      const Spacer(),
                      Text(
                        'The phrase “Copyright Reserved” or “All Rights Reserved” is a legal statement used in copyright notices to indicate that the copyright holder retains all exclusive rights to their work.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.muted, fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
