import 'package:finance_app/Pages/TransactionsPage.dart';
import 'package:finance_app/Pages/StatisticsPage.dart';
import 'package:finance_app/Pages/ChatPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'backend_API.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Database(),
      child: MaterialApp(
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: const Scaffold(
          body: Center(
            child: HomePage(),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    final database = Provider.of<Database>(context, listen: false);
    database.fetchTransactionsFromFirestore();
    database.transactions.clear();
  }

  int currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    final transactions = Provider.of<Database>(context).transactions;

    return Scaffold(
      bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.explore), label: 'Stats'),
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.person), label: 'Chat'),
          ]),
      body: /*(transactions.isEmpty)
          ? const Center(child: CircularProgressIndicator())
          :*/
          IndexedStack(
        index: currentPageIndex,
        children: const [
          Statisticspage(),
          Transactionspage(),
          Chatpage(),
        ],
      ),
    );
  }
}
