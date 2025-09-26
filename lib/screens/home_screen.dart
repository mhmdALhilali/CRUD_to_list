import 'package:flutter/material.dart';
import '../models/researcher.dart';
import '../services/researcher_service.dart';
import '../widgets/researcher_card.dart';
import 'researcher_form_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ResearcherService _researcherService = ResearcherService();
  final TextEditingController _searchController = TextEditingController();
  List<Researcher> _displayedResearchers = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadResearchers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadResearchers() {
    setState(() {
      _displayedResearchers = _researcherService.getAllResearchers();
    });
  }

  void _searchResearchers(String query) {
    setState(() {
      if (query.isEmpty) {
        _displayedResearchers = _researcherService.getAllResearchers();
      } else {
        _displayedResearchers = _researcherService.searchByName(query);
      }
    });
  }

  void _deleteResearcher(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذا الباحث؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              _researcherService.deleteResearcher(id);
              _loadResearchers();
              Navigator.pop(context);
              _showSnackBar('تم حذف الباحث بنجاح');
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text('تسجيل خروج'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'البحث عن باحث...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: _searchResearchers,
              )
            : const Text('إدارة الباحثين'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchController.clear();
                  _loadResearchers();
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _displayedResearchers.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'لا يوجد باحثون',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _displayedResearchers.length,
              itemBuilder: (context, index) {
                final researcher = _displayedResearchers[index];
                return ResearcherCard(
                  researcher: researcher,
                  onEdit: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResearcherFormScreen(
                          researcher: researcher,
                        ),
                      ),
                    );
                    if (result == true) {
                      _loadResearchers();
                    }
                  },
                  onDelete: () => _deleteResearcher(researcher.id),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ResearcherFormScreen(),
            ),
          );
          if (result == true) {
            _loadResearchers();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}