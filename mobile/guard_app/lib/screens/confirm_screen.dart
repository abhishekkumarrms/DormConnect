import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/gate_provider.dart';

class ConfirmScreen extends ConsumerStatefulWidget {
  final PendingRequest request;
  const ConfirmScreen({super.key, required this.request});

  @override
  ConsumerState<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends ConsumerState<ConfirmScreen>
    with SingleTickerProviderStateMixin {
  bool _confirming = false;
  bool _success = false;
  bool _failed = false;

  late AnimationController _flashCtrl;
  late Animation<Color?> _flashAnim;
  final _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _flashCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _flashAnim = ColorTween(begin: Colors.transparent, end: Colors.transparent)
        .animate(_flashCtrl);
  }

  @override
  void dispose() {
    _flashCtrl.dispose();
    _player.dispose();
    super.dispose();
  }

  bool get _isLeave => widget.request.movementType == 'leave';

  Future<void> _confirm() async {
    setState(() => _confirming = true);
    final ok = await ref
        .read(gateProvider.notifier)
        .confirmPassage(widget.request);

    if (ok) {
      // Green flash + beep
      _flashAnim = ColorTween(
        begin: const Color(0xFF10B981).withOpacity(0.3),
        end: Colors.transparent,
      ).animate(_flashCtrl);
      _flashCtrl.forward(from: 0);
      try {
        await _player.play(AssetSource('beep.mp3'));
      } catch (_) {}
      setState(() {
        _success = true;
        _confirming = false;
      });
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) context.go('/gate');
    } else {
      // Red flash
      _flashAnim = ColorTween(
        begin: const Color(0xFFEF4444).withOpacity(0.3),
        end: Colors.transparent,
      ).animate(_flashCtrl);
      _flashCtrl.forward(from: 0);
      setState(() {
        _failed = true;
        _confirming = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.request;
    final isOut = r.movementType == 'out';

    return AnimatedBuilder(
      animation: _flashAnim,
      builder: (_, child) => Container(
        color: _flashAnim.value,
        child: child,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: const Color(0xFF0F172A),
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.go('/gate'),
          ),
          title: Text(
            isOut ? 'Confirm Exit' : _isLeave ? 'On Leave' : 'Confirm Entry',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 16),

                // Student photo — large, prominent
                _StudentPhoto(
                    photoUrl: r.photoUrl, name: r.studentName),

                const SizedBox(height: 20),

                // Name + room
                Text(
                  r.studentName,
                  style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.w800),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Room ${r.roomNumber}',
                  style: const TextStyle(
                      fontSize: 16, color: Color(0xFF6B7280)),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                // OTP / status box
                _OtpBox(request: r),

                const SizedBox(height: 12),

                if (_failed)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color(0xFFEF4444).withOpacity(0.4)),
                    ),
                    child: const Text(
                      'Confirmation failed. Check OTP and try again.',
                      style: TextStyle(
                          color: Color(0xFFEF4444),
                          fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),

                const Spacer(),

                // CONFIRM button — large, green, full width
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton.icon(
                    onPressed: _confirming || _success ? null : _confirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _success
                          ? const Color(0xFF059669)
                          : const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor:
                          const Color(0xFF10B981).withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: _confirming
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : Icon(
                            _success
                                ? Icons.check_circle_rounded
                                : (isOut
                                    ? Icons.arrow_circle_up_rounded
                                    : Icons.arrow_circle_down_rounded),
                            size: 26,
                          ),
                    label: Text(
                      _success
                          ? 'Confirmed!'
                          : _isLeave
                              ? 'LOG EXIT (On Leave)'
                              : isOut
                                  ? 'CONFIRM EXIT'
                                  : 'CONFIRM ENTRY',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Cancel
                TextButton.icon(
                  onPressed: () => context.go('/gate'),
                  icon: const Icon(Icons.close_rounded,
                      size: 16, color: Color(0xFF9CA3AF)),
                  label: const Text(
                    'Cancel — Wrong Person',
                    style: TextStyle(
                        color: Color(0xFF9CA3AF), fontSize: 14),
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StudentPhoto extends StatelessWidget {
  final String? photoUrl;
  final String name;
  const _StudentPhoto({this.photoUrl, required this.name});

  @override
  Widget build(BuildContext context) {
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return ClipOval(
        child: CachedNetworkImage(
          imageUrl: photoUrl!,
          width: 120,
          height: 120,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => _InitialsAvatar(name: name),
        ),
      );
    }
    return _InitialsAvatar(name: name);
  }
}

class _InitialsAvatar extends StatelessWidget {
  final String name;
  const _InitialsAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final initials =
        name.trim().split(' ').take(2).map((w) => w[0]).join();
    return Container(
      width: 120,
      height: 120,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF1E293B),
      ),
      alignment: Alignment.center,
      child: Text(
        initials.toUpperCase(),
        style: const TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w700,
          color: Color(0xFF38BDF8),
        ),
      ),
    );
  }
}

class _OtpBox extends StatelessWidget {
  final PendingRequest request;
  const _OtpBox({required this.request});

  @override
  Widget build(BuildContext context) {
    final isLeave = request.movementType == 'leave';
    final isOut = request.movementType == 'out';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: isLeave
            ? const Color(0xFF2DD4BF).withOpacity(0.1)
            : isOut
                ? const Color(0xFFF59E0B).withOpacity(0.1)
                : const Color(0xFF10B981).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isLeave
                ? const Color(0xFF2DD4BF).withOpacity(0.4)
                : isOut
                    ? const Color(0xFFF59E0B).withOpacity(0.4)
                    : const Color(0xFF10B981).withOpacity(0.4)),
      ),
      child: Column(children: [
        Text(
          isLeave
              ? 'ON LEAVE'
              : isOut
                  ? 'GOING OUT'
                  : 'RETURNING',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isLeave
                ? const Color(0xFF2DD4BF)
                : isOut
                    ? const Color(0xFFF59E0B)
                    : const Color(0xFF10B981),
            letterSpacing: 1.5,
          ),
        ),
        if (!isLeave) ...[
          const SizedBox(height: 6),
          Text(
            request.otp,
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w800,
              color: isOut
                  ? const Color(0xFFF59E0B)
                  : const Color(0xFF10B981),
              fontFamily: 'monospace',
              letterSpacing: 6,
            ),
          ),
        ],
      ]),
    );
  }
}
