# Common Mistakes and How to Fix Them

## 🚫 Common Mistakes in Flutter Clean Architecture

Based on real issues encountered during the auth feature refactoring.

---

## ❌ Mistake 1: Using Method Widgets Instead of Widget Classes

### Wrong ❌
```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitle(),
        _buildContent(),
      ],
    );
  }

  Widget _buildTitle() {
    return Text('Title');
  }

  Widget _buildContent() {
    return Container(child: Text('Content'));
  }
}
```

### Right ✅
```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Title(),
        _Content(),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Text('Title');
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('Content'));
  }
}
```

**Why?**
- Better performance (const constructors)
- Better readability
- Easier to test
- Follows Flutter best practices

---

## ❌ Mistake 1.5: Using Private Widget Classes Instead of Separate Files

### Wrong ❌
```dart
// my_screen.dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Title(),
        _Content(),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Text('Title');
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('Content'));
  }
}
```

### Right ✅
```dart
// my_screen.dart
import 'package:myapp/feature/my_feature/presentation/widgets/title_widget.dart';
import 'package:myapp/feature/my_feature/presentation/widgets/content_widget.dart';

class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleWidget(),
        ContentWidget(),
      ],
    );
  }
}

// widgets/title_widget.dart
class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('Title');
  }
}

// widgets/content_widget.dart
class ContentWidget extends StatelessWidget {
  const ContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(child: Text('Content'));
  }
}
```

**Why?**
- Better reusability across screens
- Easier to test in isolation
- Better code organization
- Can be used in multiple places
- Follows single responsibility principle

**When to use private classes?**
- ✅ Very small, screen-specific widgets (< 10 lines)
- ✅ Widgets that will never be reused
- ❌ Complex widgets with logic
- ❌ Widgets that might be reused
- ❌ Widgets with multiple parameters

---

## ❌ Mistake 2: Using Try-Catch in Repositories

### Wrong ❌
```dart
@override
Future<Result<User>> registerUser({required Params params}) async {
  try {
    final result = await _remoteDataSource.register(request: request);
    return Success(data: UserMapper.toEntity(result));
  } catch (e) {
    return Error(exception: e);
  }
}
```

### Right ✅
```dart
@override
Future<Result<User>> registerUser({required Params params}) async {
  final result = await _remoteDataSource.register(request: request);
  
  return result.when(
    success: (data) {
      if (data == null) return const Error(exception: null);
      return Success(data: UserMapper.toEntity(data));
    },
    error: (exception) => Error(exception: exception),
  );
}
```

**Why?**
- Consistent error handling
- Type-safe pattern matching
- Better error propagation
- Cleaner code

---

## ❌ Mistake 3: Returning DTOs from Repository

### Wrong ❌
```dart
@override
Future<Result<UserDto>> getUser({required String id}) async {
  final result = await _remoteDataSource.getUser(id: id);
  return result; // ❌ Returning DTO
}
```

### Right ✅
```dart
@override
Future<Result<User>> getUser({required String id}) async {
  final result = await _remoteDataSource.getUser(id: id);
  
  return result.when(
    success: (dto) {
      if (dto == null) return const Error(exception: null);
      return Success(data: UserMapper.toEntity(dto)); // ✅ Return Entity
    },
    error: (exception) => Error(exception: exception),
  );
}
```

**Why?**
- Domain layer should not know about DTOs
- Separation of concerns
- Easier to change API without affecting domain

---

## ❌ Mistake 4: Multiple Cubits Per Feature

### Wrong ❌
```dart
// auth/presentation/cubits/
├── send_otp_cubit.dart
├── verify_otp_cubit.dart
├── register_user_cubit.dart
└── check_auth_cubit.dart
```

### Right ✅
```dart
// auth/presentation/cubit/
├── auth_cubit.dart        // Single cubit
├── auth_events.dart       // All events
└── auth_states.dart       // Single state class
```

**Why?**
- Easier state management
- Shared state between operations
- Less boilerplate
- Better organization

---

## ❌ Mistake 5: Using setState for Async Operations

### Wrong ❌
```dart
class MyScreen extends StatefulWidget {
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  bool _isLoading = false;
  User? _user;

  Future<void> _loadUser() async {
    setState(() => _isLoading = true);
    
    final result = await repository.getUser();
    
    setState(() {
      _isLoading = false;
      _user = result;
    });
  }
}
```

### Right ✅
```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<UserCubit>()..doIntent(LoadUserEvent()),
      child: BlocBuilder<UserCubit, UserStates>(
        builder: (context, state) {
          if (state.userState.isLoading) {
            return LoadingIndicator();
          }
          return UserDisplay(user: state.userState.data);
        },
      ),
    );
  }
}
```

**Why?**
- Separation of concerns
- Testable business logic
- Better error handling
- Consistent state management

**When to use setState?**
- ✅ Form validation errors
- ✅ Text field values
- ✅ Local UI state (expanded/collapsed)
- ✅ Selected items in a list
- ❌ API calls
- ❌ Shared state
- ❌ Business logic

---

## ❌ Mistake 6: Wrong Import Path

### Wrong ❌
```dart
import 'package:darsy/feature/auth/presentation/screens/screens.dart';
```

### Right ✅
```dart
import 'package:darsy/feature/auth/presentation/screen/screens.dart';
```

**Why?**
- Folder is named `screen` (singular) not `screens`
- Causes compilation errors

---

## ❌ Mistake 7: Named Parameters in Navigation

### Wrong ❌
```dart
AuthNavigationHelper.navigateToSuccess(context, user: user);
```

### Right ✅
```dart
AuthNavigationHelper.navigateToSuccess(context, user);
```

**Why?**
- Method signature expects positional parameter
- Check the method definition before calling

---

## ❌ Mistake 8: Using Non-Existent String Constants

### Wrong ❌
```dart
CustomButton(
  text: RegistrationDataString.registerBtn, // ❌ Doesn't exist
)
```

### Right ✅
```dart
CustomButton(
  text: RegistrationDataString.continueBtn, // ✅ Exists
)
```

**How to fix:**
1. Search for the constant in `app_strings.dart`
2. Use the correct constant name
3. Or add the new constant if needed

---

## ❌ Mistake 9: Putting Business Logic in Widgets

### Wrong ❌
```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // ❌ Business logic in widget
        final result = await repository.sendOtp(phone);
        if (result.isSuccess) {
          Navigator.push(...);
        }
      },
      child: Text('Send'),
    );
  }
}
```

### Right ✅
```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state.sendOtpState.isSuccess) {
          // Navigate on success
        }
      },
      builder: (context, state) {
        return ElevatedButton(
          onPressed: () {
            // ✅ Just trigger the event
            context.read<AuthCubit>().doIntent(
              SendOtpEvent(params: params),
            );
          },
          child: Text('Send'),
        );
      },
    );
  }
}
```

---

## ❌ Mistake 10: Not Validating Router Arguments

### Wrong ❌
```dart
GoRoute(
  path: '/profile',
  pageBuilder: (context, state) {
    final user = state.extra as User; // ❌ Might be null
    return ProfileScreen(user: user);
  },
)
```

### Right ✅
```dart
GoRoute(
  path: '/profile',
  pageBuilder: (context, state) {
    final user = state.extra as User?;
    
    if (user == null) {
      throw ArgumentError('User is required for profile screen');
    }
    
    return buildAnimatedPage(
      key: state.pageKey,
      child: ProfileScreen(user: user),
    );
  },
)
```

**Why?**
- Catches errors early
- Better error messages
- Type safety

---

## ❌ Mistake 11: Forgetting to Run build_runner

### Symptoms:
```
Error: Part file not found
Error: _$UserDtoFromJson is not defined
```

### Fix:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**When to run:**
- After creating/modifying DTOs with `@JsonSerializable()`
- After creating/modifying API clients with `@RestApi()`
- When you see "part file not found" errors

---

## ❌ Mistake 12: Wrong Use Case File Naming

### Wrong ❌
```dart
send_otp_usecase.dart
verify_otp_usecase.dart
register_user_use_case.dart  // Inconsistent
```

### Right ✅
```dart
send_otp.dart
verify_otp.dart
register_user.dart
```

**Why?**
- Cleaner file names
- Consistent with products feature
- Less redundant

---

## ❌ Mistake 13: Not Using Contracts for Data Sources

### Wrong ❌
```dart
// Repository directly depends on implementation
class AuthRepositoryImpl {
  final AuthRemoteDataSourceImpl _remoteDataSource; // ❌
}
```

### Right ✅
```dart
// Repository depends on contract (interface)
class AuthRepositoryImpl {
  final AuthRemoteDataSourceContract _remoteDataSource; // ✅
}
```

**Why?**
- Dependency Inversion Principle
- Easier to test (can mock the contract)
- Can swap implementations

---

## ❌ Mistake 14: Mixing Local and Remote Logic in Repository

### Wrong ❌
```dart
@override
Future<Result<User>> getUser() async {
  try {
    // ❌ Mixing concerns
    final cachedUser = await _localStorage.getUser();
    if (cachedUser != null) return Success(data: cachedUser);
    
    final remoteUser = await _remoteDataSource.getUser();
    await _localStorage.saveUser(remoteUser);
    return Success(data: remoteUser);
  } catch (e) {
    return Error(exception: e);
  }
}
```

### Right ✅
```dart
@override
Future<Result<User>> getUser() async {
  final result = await _remoteDataSource.getUser();
  
  return result.when(
    success: (dto) {
      if (dto == null) return const Error(exception: null);
      
      final user = UserMapper.toEntity(dto);
      
      // Store in background, don't wait
      _localDataSource.saveUser(user);
      
      return Success(data: user);
    },
    error: (exception) => Error(exception: exception),
  );
}
```

---

## ❌ Mistake 15: Not Handling Null in Success Case

### Wrong ❌
```dart
return result.when(
  success: (data) => Success(data: UserMapper.toEntity(data)), // ❌ data might be null
  error: (exception) => Error(exception: exception),
);
```

### Right ✅
```dart
return result.when(
  success: (data) {
    if (data == null) {
      return const Error(exception: null);
    }
    return Success(data: UserMapper.toEntity(data));
  },
  error: (exception) => Error(exception: exception),
);
```

---

## 🔧 Quick Fixes Checklist

When you encounter an error:

- [ ] Check import paths (screen vs screens)
- [ ] Verify method signatures (positional vs named parameters)
- [ ] Check if string constants exist in app_strings.dart
- [ ] Run build_runner if using @JsonSerializable or @RestApi
- [ ] Validate router arguments are not null
- [ ] Use .when() instead of try-catch in repositories
- [ ] Return entities, not DTOs, from repositories
- [ ] Use separate widget classes, not methods
- [ ] Use cubit for async operations, setState for local UI
- [ ] Check that data source contracts are used, not implementations

---

## 📚 Related Skills

- `flutter-clean-architecture-feature.md` - Complete architecture guide
- `flutter-feature-templates.md` - Code templates
- `README.md` - Skills overview

---

**Last Updated**: May 2026
**Version**: 1.0.0
