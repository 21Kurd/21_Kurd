import 'package:material_ui/material_ui.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'auth_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const TwentyOneKurdApp());
}

const forest = Color(0xFF173D30);
const gold = Color(0xFFD7B45A);
const cream = Color(0xFFF7F5EF);
const red = Color(0xFFB83A3A);

class TwentyOneKurdApp extends StatelessWidget {
  const TwentyOneKurdApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '21 Kurd',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: cream,
        colorScheme: ColorScheme.fromSeed(seedColor: forest),
        appBarTheme: const AppBarTheme(
          backgroundColor: forest,
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int index = 0;
  String language = 'العربية';

  final pages = const [
    HomePage(),
    ExplorePage(),
    SubmitPage(),
    SavedPage(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: language == 'English' || language == 'Français'
          ? TextDirection.ltr
          : TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('21 KURD',
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.4)),
          actions: [
            PopupMenuButton<String>(
              tooltip: 'Language',
              icon: const Icon(Icons.language),
              onSelected: (value) => setState(() => language = value),
              itemBuilder: (_) => ['العربية', 'کوردی - سۆرانی', 'Kurmancî', 'English', 'Français']
                  .map((v) => PopupMenuItem(value: v, child: Text(v)))
                  .toList(),
            ),
            IconButton(
              onPressed: () => _notice(context, 'لا توجد إشعارات جديدة'),
              icon: const Icon(Icons.notifications_none),
            ),
          ],
        ),
        body: pages[index],
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (v) => setState(() => index = v),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
            NavigationDestination(icon: Icon(Icons.explore_outlined), label: 'اكتشف'),
            NavigationDestination(icon: Icon(Icons.add_circle_outline), label: 'انشر'),
            NavigationDestination(icon: Icon(Icons.bookmark_border), label: 'المحفوظات'),
            NavigationDestination(icon: Icon(Icons.person_outline), label: 'حسابي'),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      ('التاريخ', Icons.account_balance),
      ('السياسة', Icons.public),
      ('الثقافة والتراث', Icons.diversity_3),
      ('الفن والموسيقى', Icons.music_note),
      ('اللغة والشعر', Icons.menu_book),
      ('الصور والفيديو', Icons.photo_library_outlined),
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [forest, Color(0xFF285B45)],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('من كوردستان إلى العالم',
                  style: TextStyle(color: gold, fontSize: 23, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('اكتشف التاريخ والثقافة والفنون واللغة الكوردية.',
                  style: TextStyle(color: Colors.white, height: 1.5)),
              SizedBox(height: 18),
              Row(children: [
                Icon(Icons.wb_sunny_outlined, color: gold, size: 34),
                SizedBox(width: 10),
                Text('21 KURD', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
              ]),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const SectionTitle('استكشف الأقسام'),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 2.3,
          ),
          itemBuilder: (_, i) => Card(
            elevation: 0,
            color: Colors.white,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => _notice(context, 'سيتم فتح قسم ${categories[i].$1}'),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(children: [
                  Icon(categories[i].$2, color: forest),
                  const SizedBox(width: 9),
                  Expanded(child: Text(categories[i].$1, style: const TextStyle(fontWeight: FontWeight.w600))),
                ]),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const SectionTitle('أحدث المنشورات'),
        const SizedBox(height: 10),
        const ArticleCard(
          title: 'محطات من تاريخ كوردستان',
          category: 'التاريخ',
          description: 'مساحة معرفية للتعرّف على الأحداث والشخصيات والمصادر التاريخية.',
          icon: Icons.account_balance,
        ),
        const ArticleCard(
          title: 'الموسيقى والتراث الكوردي',
          category: 'الفن والثقافة',
          description: 'تعرف على الآلات الموسيقية والفنون الشعبية والتقاليد.',
          icon: Icons.music_note,
        ),
      ],
    );
  }
}

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: const [
      SectionTitle('اكتشف 21 Kurd'),
      SizedBox(height: 12),
      TextField(decoration: InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'ابحث عن مقال أو موضوع')),
      SizedBox(height: 16),
      ArticleCard(title: 'التاريخ الكوردستاني', category: 'التاريخ', description: 'مقالات موثقة ومراجع للقراءة.', icon: Icons.history_edu),
      ArticleCard(title: 'اللغة والأدب', category: 'اللغة والشعر', description: 'مواد تعليمية وقصائد وأعمال أدبية.', icon: Icons.menu_book),
    ],
  );
}

class SubmitPage extends StatefulWidget {
  const SubmitPage({super.key});
  @override
  State<SubmitPage> createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  final title = TextEditingController();
  final body = TextEditingController();
  String category = 'التاريخ';
  @override
  void dispose() { title.dispose(); body.dispose(); super.dispose(); }

  Future<void> _submit() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _notice(context, 'سجّل الدخول قبل إرسال المساهمة.');
      return;
    }

    final titleText = title.text.trim();
    final bodyText = body.text.trim();
    if (titleText.isEmpty || bodyText.isEmpty) {
      _notice(context, 'أدخل العنوان والنص أولاً.');
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('submissions').add({
        'title': titleText,
        'body': bodyText,
        'category': category,
        'ownerUid': user.uid,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
      if (!mounted) return;
      title.clear();
      body.clear();
      _notice(context, 'أُرسلت المساهمة للمراجعة.');
    } on FirebaseException {
      if (!mounted) return;
      _notice(context, 'تعذّر الإرسال. تحقق من الاتصال ثم حاول مجدداً.');
    }
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      const SectionTitle('إرسال مشاركة للمراجعة'),
      const SizedBox(height: 8),
      const Text('يمكن للناشرين إرسال محتوى. لن يظهر للجمهور قبل موافقة الإدارة.'),
      const SizedBox(height: 16),
      TextField(controller: title, decoration: const InputDecoration(labelText: 'عنوان المقال')),
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(
        initialValue: category,
        decoration: const InputDecoration(labelText: 'القسم'),
        items: ['التاريخ', 'السياسة', 'الثقافة والتراث', 'الفن والموسيقى', 'اللغة والشعر']
            .map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
        onChanged: (v) => setState(() => category = v ?? category),
      ),
      const SizedBox(height: 12),
      TextField(controller: body, maxLines: 7, decoration: const InputDecoration(labelText: 'نص المشاركة', alignLabelWithHint: true)),
      const SizedBox(height: 12),
      OutlinedButton.icon(
        onPressed: _submit,
        icon: const Icon(Icons.attach_file), label: const Text('إرفاق صورة أو فيديو (قريباً)'),
      ),
      const SizedBox(height: 16),
      FilledButton(
        style: FilledButton.styleFrom(backgroundColor: forest, padding: const EdgeInsets.all(15)),
        onPressed: () {
          if (title.text.trim().isEmpty || body.text.trim().isEmpty) {
            _notice(context, 'يرجى إدخال العنوان ونص المشاركة');
            return;
          }
          _notice(context, 'هذه نسخة تجريبية: سيتم إرسال المشاركة للمراجعة بعد ربط قاعدة البيانات');
        },
        child: const Text('إرسال للمراجعة'),
      ),
    ],
  );
}

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('ستظهر هنا المقالات المحفوظة لديك.'));
}

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      const CircleAvatar(radius: 38, backgroundColor: forest, child: Icon(Icons.person, color: Colors.white, size: 38)),
      const SizedBox(height: 12),
      const Center(child: Text('مرحباً بك في 21 Kurd', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
      const SizedBox(height: 20),
      ListTile(leading: const Icon(Icons.login), title: const Text('تسجيل الدخول'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AuthPage()))),
      ListTile(leading: const Icon(Icons.person_add_alt), title: const Text('إنشاء حساب قارئ أو طلب حساب ناشر'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AuthPage()))),
      ListTile(leading: const Icon(Icons.rule), title: const Text('سياسة النشر والمراجعة'), onTap: () => _notice(context, 'كل المنشورات والتعليقات تخضع للمراجعة')),
    ],
  );
}

class ArticleCard extends StatelessWidget {
  final String title, category, description;
  final IconData icon;
  const ArticleCard({super.key, required this.title, required this.category, required this.description, required this.icon});
  @override
  Widget build(BuildContext context) => Card(
    color: Colors.white, elevation: 0, margin: const EdgeInsets.only(bottom: 10),
    child: ListTile(
      contentPadding: const EdgeInsets.all(14),
      leading: CircleAvatar(backgroundColor: const Color(0xFFE8EFEA), child: Icon(icon, color: forest)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Padding(padding: const EdgeInsets.only(top: 5), child: Text('$category • $description')),
      trailing: const Icon(Icons.chevron_left),
      onTap: () => _notice(context, 'صفحة المقال ستضاف في مرحلة ربط المحتوى'),
    ),
  );
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: forest));
}

void _notice(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
