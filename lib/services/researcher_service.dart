import '../models/researcher.dart';

class ResearcherService {
  static final ResearcherService _instance = ResearcherService._internal();
  factory ResearcherService() => _instance;
  ResearcherService._internal();

  final List<Researcher> _researchers = [];

  // Get all researchers
  List<Researcher> getAllResearchers() {
    return List.unmodifiable(_researchers);
  }

  // Add new researcher
  bool addResearcher(Researcher researcher) {
    try {
      _researchers.add(researcher);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Update researcher
  bool updateResearcher(String id, Researcher updatedResearcher) {
    try {
      final index = _researchers.indexWhere((researcher) => researcher.id == id);
      if (index != -1) {
        _researchers[index] = updatedResearcher;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Delete researcher
  bool deleteResearcher(String id) {
    try {
      _researchers.removeWhere((researcher) => researcher.id == id);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Find researcher by ID
  Researcher? findResearcherById(String id) {
    try {
      return _researchers.firstWhere((researcher) => researcher.id == id);
    } catch (e) {
      return null;
    }
  }

  // Search researchers by name
  List<Researcher> searchByName(String query) {
    return _researchers
        .where((researcher) =>
            researcher.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}