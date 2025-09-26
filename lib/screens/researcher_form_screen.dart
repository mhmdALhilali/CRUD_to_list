import 'package:flutter/material.dart';
import '../models/researcher.dart';
import '../services/researcher_service.dart';

class ResearcherFormScreen extends StatefulWidget {
  final Researcher? researcher;

  const ResearcherFormScreen({Key? key, this.researcher}) : super(key: key);

  @override
  State<ResearcherFormScreen> createState() => _ResearcherFormScreenState();
}

class _ResearcherFormScreenState extends State<ResearcherFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ResearcherService _researcherService = ResearcherService();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _specialtyController;
  late TextEditingController _universityController;
  late TextEditingController _phoneController;

  bool get isEditing => widget.researcher != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.researcher?.name ?? '');
    _emailController = TextEditingController(text: widget.researcher?.email ?? '');
    _specialtyController = TextEditingController(text: widget.researcher?.specialty ?? '');
    _universityController = TextEditingController(text: widget.researcher?.university ?? '');
    _phoneController = TextEditingController(text: widget.researcher?.phoneNumber ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _specialtyController.dispose();
    _universityController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveResearcher() {
    if (_formKey.currentState!.validate()) {
      final researcher = Researcher(
        id: widget.researcher?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        specialty: _specialtyController.text.trim(),
        university: _universityController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
      );

      bool success;
      if (isEditing) {
        success = _researcherService.updateResearcher(widget.researcher!.id, researcher);
      } else {
        success = _researcherService.addResearcher(researcher);
      }

      if (success) {
        Navigator.pop(context, true);
        _showSnackBar(isEditing ? 'تم تحديث الباحث بنجاح' : 'تم إضافة الباحث بنجاح');
      } else {
        _showSnackBar('حدث خطأ أثناء الحفظ');
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'تعديل الباحث' : 'إضافة باحث جديد'),
        actions: [
          TextButton(
            onPressed: _saveResearcher,
            child: const Text(
              'حفظ',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'المعلومات الأساسية',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'الاسم الكامل',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال الاسم';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'البريد الإلكتروني',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال البريد الإلكتروني';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'يرجى إدخال بريد إلكتروني صحيح';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'رقم الهاتف',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال رقم الهاتف';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'المعلومات الأكاديمية',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _specialtyController,
                      decoration: const InputDecoration(
                        labelText: 'التخصص',
                        prefixIcon: Icon(Icons.science),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال التخصص';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _universityController,
                      decoration: const InputDecoration(
                        labelText: 'الجامعة',
                        prefixIcon: Icon(Icons.school),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'يرجى إدخال الجامعة';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _saveResearcher,
                child: Text(
                  isEditing ? 'تحديث الباحث' : 'إضافة الباحث',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}