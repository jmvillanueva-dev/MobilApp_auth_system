import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AuthSignUpRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
              fullName: _fullNameController.text.trim().isNotEmpty
                  ? _fullNameController.text.trim()
                  : null,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSignUpSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.requiresEmailConfirmation
                      ? 'Registro exitoso. Revisa tu email para confirmar tu cuenta.'
                      : 'Registro exitoso.',
                ),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icono de persona
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.person_add_outlined,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Título
                    Text(
                      'Crear Cuenta',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Completa tus datos para registrarte',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                    ),
                    const SizedBox(height: 32),

                    // Campo de nombre completo
                    AuthTextField(
                      controller: _fullNameController,
                      label: 'Nombre completo',
                      prefixIcon: Icons.person_outline,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 16),

                    // Campo de email
                    AuthTextField(
                      controller: _emailController,
                      label: 'Email',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Ingrese un email válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Campo de contraseña
                    AuthTextField(
                      controller: _passwordController,
                      label: 'Contraseña',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese una contraseña';
                        }
                        if (value.length < 6) {
                          return 'La contraseña debe tener al menos 6 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Campo de confirmar contraseña
                    AuthTextField(
                      controller: _confirmPasswordController,
                      label: 'Confirmar contraseña',
                      prefixIcon: Icons.lock_outline,
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor confirme su contraseña';
                        }
                        if (value != _passwordController.text) {
                          return 'Las contraseñas no coinciden';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _onRegister(),
                    ),
                    const SizedBox(height: 32),

                    // Botón de registro
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return AuthButton(
                          text: 'Registrarse',
                          onPressed: _onRegister,
                          isLoading: state is AuthLoading,
                          icon: Icons.person_add,
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // Link a login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('¿Ya tienes cuenta?'),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Inicia sesión'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
