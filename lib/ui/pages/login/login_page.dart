import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/components.dart';
import 'login_presenter.dart';
import '../../components/components.dart';

class LoginPage extends StatefulWidget {
  final LoginPresenter presenter;

  const LoginPage(this.presenter);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void dispose() {
    super.dispose();
    widget.presenter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          widget.presenter.isLoadingStream.listen((isLoading) {
            if (isLoading) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });
          widget.presenter.mainErrorStream.listen((error) {
            if (error != null) {
              showErrorMessage(context, error);
            }
          });
          return SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              const LoginHeader(),
              HeadLine1(text: 'Login'),
              Padding(
                padding: const EdgeInsets.all(32),
                child: Provider(
                  create: (_) => widget.presenter,
                  child: Form(
                      child: Column(
                    children: [
                      EmailInput(),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 32),
                        child: StreamBuilder<dynamic>(
                            stream: widget.presenter.passwordErrorStream,
                            builder: (context, snapshot) {
                              return TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Senha',
                                    icon: Icon(Icons.lock, color: Theme.of(context).primaryColorLight),
                                    errorText: snapshot.data.toString().isEmpty ? null : snapshot.data),
                                obscureText: true,
                                onChanged: widget.presenter.validatePassword,
                              );
                            }),
                      ),
                      StreamBuilder<dynamic>(
                          stream: widget.presenter.isFormValidStream,
                          builder: (context, snapshot) {
                            return ElevatedButton(
                              onPressed: snapshot.data == true ? widget.presenter.auth : null,
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)))),
                              child: Text('Entrar'.toUpperCase()),
                            );
                          }),
                      TextButton.icon(
                          onPressed: () {}, icon: const Icon(Icons.person), label: const Text('Criar Conta'))
                    ],
                  )),
                ),
              )
            ]),
          );
        },
      ),
    );
  }
}
