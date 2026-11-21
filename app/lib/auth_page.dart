import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
const forest = Color(0xFF173D30);

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool isLogin = true;
  bool loading = false;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (email.text.trim().isEmpty || password.text.length < 6) {
      showMessage('أدخل البريد وكلمة مرور من 6 أحرف على الأقل');
      return;
    }

    setState(() => loading = true);

    try {
      if (isLogin) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text,
        );
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text,
        );
      }

      if (!mounted) return;
      showMessage(isLogin ? 'تم تسجيل الدخول بنجاح' : 'تم إنشاء الحساب بنجاح');
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      showMessage(e.message ?? 'تعذر إتمام العملية');
    } catch (_) {
      showMessage('حدث خطأ، حاول مرة أخرى');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('حساب 21 Kurd')),
      body: ListView(
        padding: const EdgeInsets.all(22),
        children: [
          const SizedBox(height: 25),
          const Icon(Icons.public, size: 65, color: forest),
          const SizedBox(height: 15),
          Center(
            child: Text(
              isLogin ? 'تسجيل الدخول' : 'إنشاء حساب جديد',
              style: const TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: forest,
              ),
            ),
          ),
          const SizedBox(height: 25),
          TextField(
            controller: email,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'البريد الإلكتروني',
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: password,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'كلمة المرور',
              prefixIcon: Icon(Icons.lock_outline),
            ),
          ),
          const SizedBox(height: 22),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: forest,
              padding: const EdgeInsets.all(15),
            ),
            onPressed: loading ? null : submit,
            child: Text(
              loading
                  ? 'يرجى الانتظار...'
                  : isLogin
                      ? 'دخول'
                      : 'إنشاء الحساب',
            ),
          ),
          TextButton(
            onPressed: () => setState(() => isLogin = !isLogin),
            child: Text(
              isLogin
                  ? 'ليس لديك حساب؟ أنشئ حساباً'
                  : 'لديك حساب؟ سجّل الدخول',
            ),
          ),
        ],
      ),
    );
  }
}
