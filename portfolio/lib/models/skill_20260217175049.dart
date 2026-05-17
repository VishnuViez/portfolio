class Skill {
  final String name;
  final double proficiency; // 0.0 to 1.0
  final String category;

  Skill({
    required this.name,
    required this.proficiency,
    required this.category,
  });
}

class SkillCategory {
  final String name;
  final List<Skill> skills;

  SkillCategory({
    required this.name,
    required this.skills,
  });
}
