import 'dart:io';

import 'package:chat/components/user_image_picker.dart';
import 'package:chat/core/models/AuthFormData.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(AuthFormData) onSubmit;

  const AuthForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  final _authFormData = AuthFormData();

  void hadleImagePick(File image) {
    _authFormData.image = image;
  }

  void _showError(message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ),
    );
  }

  void submit() {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    if (_authFormData.image == null && _authFormData.isSignup) {
      return _showError('Imagem não selecionada');
    }

    widget.onSubmit(_authFormData);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_authFormData.isSignup)
                UserImagePicker(
                  onImagePickq: hadleImagePick,
                ),
              if (_authFormData.isSignup)
                TextFormField(
                  key: const ValueKey('name'),
                  initialValue: _authFormData.name,
                  onChanged: (name) => _authFormData.name = name,
                  decoration: const InputDecoration(label: Text('Nome')),
                  validator: (_name) {
                    final name = _name ?? '';

                    if (name.trim().length < 5) {
                      return 'Nome deve ter no mínimo cinco caracteres';
                    }

                    return null;
                  },
                ),
              TextFormField(
                key: const ValueKey('email'),
                onChanged: (email) => _authFormData.email = email,
                decoration: const InputDecoration(label: Text('E-mail')),
                validator: (_email) {
                  final email = _email ?? '';

                  if (!email.contains('@')) {
                    return 'Email informado não é válido';
                  }

                  return null;
                },
              ),
              TextFormField(
                key: const ValueKey('password'),
                onChanged: (password) => _authFormData.password = password,
                obscureText: true,
                decoration: const InputDecoration(label: Text('Senha')),
                validator: (_password) {
                  final password = _password ?? '';

                  if (password.length < 6) {
                    return 'Senha deve ter no mínimo 6 caracteres';
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: 12.0,
              ),
              ElevatedButton(
                  onPressed: submit,
                  child: Text(_authFormData.isLogin ? 'Entrar' : 'Cadastrar')),
              TextButton(
                  onPressed: () {
                    setState(() {
                      _authFormData.toggleAuthMode();
                    });
                  },
                  child: Text(_authFormData.isLogin
                      ? 'Criar uma nova conta?'
                      : 'Já Possui conta?'))
            ],
          ),
        ),
      ),
    );
  }
}
