import 'dart:io';
import 'dart:convert';

class Course {
  final String id;
  final String name;
  final String instructor;
  final List<String> courseMaterials;
  final List<String> quizzes;
  Map<String, int> grades;

  Course(
    this.id,
    this.name,
    this.instructor,
    this.courseMaterials,
    this.quizzes,
    this.grades,
  );
}

class User {
  final String username;
  List<String> enrolledCourseIds;

  User(this.username, this.enrolledCourseIds);
}

void main() {
  List<Course> courses = [
    Course(
      "c1",
      "Introduction to Programming",
      "Hammad",
      ["Introduction Slides", "Getting Started Guide"],
      ["Basic Quiz", "Functions Quiz"],
      {},
    ),
    Course(
      "c2",
      "Web Development Basics",
      "Jhanzaib",
      ["HTML Basics", "CSS Basics"],
      ["HTML Quiz", "CSS Quiz"],
      {},
    ),
  ];

  List<User> users = [];

  while (true) {
    print("\n==== Learning Management System ====");
    print("1. Login");
    print("2. Register");
    print("3. Exit");
    stdout.write("Enter your choice (1/2/3): ");

    var choice = int.tryParse(stdin.readLineSync() ?? '');

    switch (choice) {
      case 1:
        login(users, courses);
        break;
      case 2:
        register(users);
        break;
      case 3:
        saveData(users, courses);
        print("Goodbye!");
        return;
      default:
        print("Invalid choice. Please try again.");
    }
  }
}

void login(List<User> users, List<Course> courses) {
  stdout.write("Enter your username: ");
  var username = stdin.readLineSync() ?? '';

  var user = users.firstWhere((u) => u.username == username);
  if (user == null) {
    print("User not found. Please register first.");
  } else {
    loggedInMenu(user, courses);
  }
}

void loggedInMenu(User user, List<Course> courses) {
  while (true) {
    print("\n==== Logged In Menu ====");
    print("1. View All Courses");
    print("2. Enroll in a Course");
    print("3. View Enrolled Courses");
    print("4. View Course Materials");
    print("5. Take Quiz");
    print("6. View Grades");
    print("7. Logout");
    stdout.write("Enter your choice (1/2/3/4/5/6/7): ");

    var choice = int.tryParse(stdin.readLineSync() ?? '');

    switch (choice) {
      case 1:
        viewAllCourses(courses);
        break;
      case 2:
        enrollInCourse(user, courses);
        break;
      case 3:
        viewEnrolledCourses(user, courses);
        break;
      case 4:
        viewCourseMaterials(user, courses);
        break;
      case 5:
        takeQuiz(user, courses);
        break;
      case 6:
        viewGrades(user, courses);
        break;
      case 7:
        print("Logged out successfully.");
        return;
      default:
        print("Invalid choice. Please try again.");
    }
  }
}

void register(List<User> users) {
  stdout.write("Enter your username: ");
  var username = stdin.readLineSync() ?? '';
  var user =
      users.length > 0 ? users.firstWhere((u) => u.username == username) : null;
  if (user != null) {
    print("Username already exists. Please choose a different username.");
  } else {
    users.add(User(username, []));
    print("Registration successful!");
  }
}

void viewAllCourses(List<Course> courses) {
  print("\n==== All Courses ====");
  for (var i = 0; i < courses.length; i++) {
    var course = courses[i];
    print("${i + 1}. ${course.name} - ${course.instructor}");
  }
}

void enrollInCourse(User user, List<Course> courses) {
  viewAllCourses(courses);

  stdout.write("Enter the course number to enroll: ");
  var courseNumber = int.tryParse(stdin.readLineSync() ?? '');

  if (courseNumber == null ||
      courseNumber < 1 ||
      courseNumber > courses.length) {
    print("Invalid course number. Please try again.");
    return;
  }

  var selectedCourse = courses[courseNumber - 1];
  if (user.enrolledCourseIds.contains(selectedCourse.id)) {
    print("You are already enrolled in this course.");
  } else {
    user.enrolledCourseIds.add(selectedCourse.id);
    print("Enrolled in '${selectedCourse.name}' successfully!");
  }
}

void viewEnrolledCourses(User user, List<Course> courses) {
  if (user.enrolledCourseIds.isEmpty) {
    print("You are not enrolled in any courses.");
    return;
  }

  print("\n==== Enrolled Courses ====");
  for (var courseId in user.enrolledCourseIds) {
    var course = courses.firstWhere((c) => c.id == courseId);
    if (course != null) {
      print("${course.name} - ${course.instructor}");
    }
  }
}

void viewCourseMaterials(User user, List<Course> courses) {
  viewEnrolledCourses(user, courses);

  stdout.write("Enter the course number to view materials: ");
  var courseNumber = int.tryParse(stdin.readLineSync() ?? '');

  if (courseNumber == null ||
      courseNumber < 1 ||
      courseNumber > user.enrolledCourseIds.length) {
    print("Invalid course number. Please try again.");
    return;
  }

  var courseId = user.enrolledCourseIds[courseNumber - 1];
  var course = courses.firstWhere((c) => c.id == courseId);
  if (course != null) {
    print("\n==== Course Materials for '${course.name}' ====");
    for (var material in course.courseMaterials) {
      print("- $material");
    }
  }
}

void takeQuiz(User user, List<Course> courses) {
  viewEnrolledCourses(user, courses);

  stdout.write("Enter the course number to take the quiz: ");
  var courseNumber = int.tryParse(stdin.readLineSync() ?? '');

  if (courseNumber == null ||
      courseNumber < 1 ||
      courseNumber > user.enrolledCourseIds.length) {
    print("Invalid course number. Please try again.");
    return;
  }

  var courseId = user.enrolledCourseIds[courseNumber - 1];
  var course = courses.firstWhere((c) => c.id == courseId);
  if (course != null) {
    print("\n==== Quiz for '${course.name}' ====");
    for (var i = 0; i < course.quizzes.length; i++) {
      var quiz = course.quizzes[i];
      stdout.write("Question ${i + 1}: What is the answer to '$quiz'? ");
      var answer = stdin.readLineSync() ?? '';
      if (answer.toLowerCase() == 'yes') {
        course.grades[user.username] = (course.grades[user.username] ?? 0) + 1;
        print("Correct!");
      } else {
        print("Incorrect!");
      }
    }
  }
}

void viewGrades(User user, List<Course> courses) {
  if (user.enrolledCourseIds.isEmpty) {
    print("You are not enrolled in any courses.");
    return;
  }

  print("\n==== Your Grades ====");
  for (var courseId in user.enrolledCourseIds) {
    var courseGrade = user.enrolledCourseIds.length > 0
        ? user.enrolledCourseIds.fold(0, (sum, id) {
              var course = courses.firstWhere((c) => c.id == id);
              if (course != null) {
                return sum + (course.grades[user.username] ?? 0);
              }
              return sum;
            }) /
            user.enrolledCourseIds.length
        : 0;

    print("- Course: $courseId - Grade: $courseGrade");
  }
}

void saveData(List<User> users, List<Course> courses) {
  var userJson = json.encode(users.map((user) {
    return {
      'username': user.username,
      'enrolledCourseIds': user.enrolledCourseIds,
    };
  }).toList());

  var courseJson = json.encode(courses.map((course) {
    return {
      'id': course.id,
      'name': course.name,
      'instructor': course.instructor,
      'courseMaterials': course.courseMaterials,
      'quizzes': course.quizzes,
      'grades': course.grades,
    };
  }).toList());

  // Save data to files
  File('users.json').writeAsStringSync(userJson);
  File('courses.json').writeAsStringSync(courseJson);
}