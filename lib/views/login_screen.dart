import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// Ensure these paths correctly point to your BLoC files
import '../viewmodels/login/login_bloc.dart';
import '../viewmodels/login/login_event.dart';
import '../viewmodels/login/login_state.dart';
import 'home_screen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key}); // Good practice to include key
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // For form validation
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  // This will replace your 'selectedRole'. It can be 'Customer' or 'Vendor'.
  // Your BLoC's LoginSubmitted event expects 'customer' or 'vendor' (lowercase).
  // We will convert this before sending to the BLoC.
  String _selectedUserType = 'Customer'; // Default selection

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  void _submitLoginWithBloc() {
    if (!_formKey.currentState!.validate()) {
      return; // Don't submit if form is invalid
    }
    // Convert UI's 'Customer'/'Vendor' to BLoC's 'customer'/'vendor'
    final roleForBloc = _selectedUserType.toLowerCase();

    context.read<LoginBloc>().add(LoginSubmitted(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      role: roleForBloc,
    ));
  }

  // --- Methods from the new UI structure (adapted for BLoC) ---
  void _navigateToHome(String method, String email, String userType, String id) {
    // Make sure your HomeScreen can accept these parameters or adapt as needed
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomeScreen(
          userId: id,// This is 'Customer' or 'Vendor' from UI state
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog( // Changed context to ctx to avoid conflict
        title: const Text('Login Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    // You might have password validation in your BLoC.
    // This is client-side validation for immediate feedback.
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
  // --- End of methods from new UI ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            // Assuming LoginSuccess might have a user object or token.
            // For now, just showing a generic success message and navigating.
            // ScaffoldMessenger.of(context).showSnackBar(
            //   // Assuming LoginSuccess has a message property, or use a generic one.
            //   SnackBar(content: Text(state.message ?? 'Login Successful!')),
            // );
            // Navigate to home. Pass relevant data.
            // The 'userType' here is from the UI selection (_selectedUserType).
            // If your LoginSuccess state provides more specific user details, use those.
            _navigateToHome('Email/Password (BLoC)', _emailController.text.trim(), _selectedUserType, state.token);
          } else if (state is LoginFailure) {
            _showErrorDialog(state.message); // state.message comes from your BLoC
          }
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient( // Fallback if image doesn't load
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue[400]!,
                Colors.purple[400]!,
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Card(
                  elevation: 12,
                  color: Colors.white.withOpacity(0.95),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Form( // Wrap content in a Form for validation
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.lock_outline,
                            size: 64,
                            color: Colors.blue,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Welcome Back',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Sign in to your account',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // User Type Selection (from the new UI)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'I am a:',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => setState(() => _selectedUserType = 'Customer'),
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: _selectedUserType == 'Customer'
                                                ? Colors.blue[50]
                                                : Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: _selectedUserType == 'Customer'
                                                  ? Colors.blue
                                                  : Colors.grey[300]!,
                                              width: 2,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.shopping_cart_outlined,
                                                color: _selectedUserType == 'Customer'
                                                    ? Colors.blue
                                                    : Colors.grey[600],
                                                size: 32,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Customer',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: _selectedUserType == 'Customer'
                                                      ? Colors.blue
                                                      : Colors.grey[700],
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Buy products',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => setState(() => _selectedUserType = 'Vendor'),
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: _selectedUserType == 'Vendor'
                                                ? Colors.orange[50]
                                                : Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: _selectedUserType == 'Vendor'
                                                  ? Colors.orange
                                                  : Colors.grey[300]!,
                                              width: 2,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.store_outlined,
                                                color: _selectedUserType == 'Vendor'
                                                    ? Colors.orange
                                                    : Colors.grey[600],
                                                size: 32,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                'Vendor',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: _selectedUserType == 'Vendor'
                                                      ? Colors.orange
                                                      : Colors.grey[700],
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'Sell products',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Email TextFormField
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: _validateEmail,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              prefixIcon: const Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.blue),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Password TextFormField
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            validator: _validatePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock_outlined),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(color: Colors.blue),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Login Button (using BlocBuilder for loading state)
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: BlocBuilder<LoginBloc, LoginState>(
                              builder: (context, state) {
                                final isLoading = state is LoginLoading;
                                return ElevatedButton(
                                  onPressed: isLoading ? null : _submitLoginWithBloc,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                  ),
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                      : const Text(
                                    'Sign In with Email',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Demo credentials info (optional, can be removed or updated)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue[200]!),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Demo Credentials:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[800],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Update this if your demo credentials or BLoC logic changes
                                Text(
                                  'Email: swaroop.vass@gmail.com\nPassword: @Tyrion99\nrole: vendor',
                                  style: TextStyle(
                                    color: Colors.blue[700],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}