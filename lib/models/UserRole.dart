enum UserRole {
  roleUser("ROLE_USER"),
  roleAdmin("ROLE_ADMIN");

  const UserRole(this.role);
  final String role;

  factory UserRole.fromJson(String role) {
    switch (role) {
      case "ROLE_USER":
        return UserRole.roleUser;
      case "ROLE_ADMIN":
        return UserRole.roleAdmin;
      default:
        throw Exception("Invalid role");
    }
  }
}
