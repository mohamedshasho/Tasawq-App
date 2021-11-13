import 'package:delivery_app/bloc/Auth/auth_bloc.dart';
import 'package:delivery_app/bloc/Products/bloc_product.dart';
import 'package:delivery_app/componants/build_button.dart';
import 'package:delivery_app/componants/input_decoration_auth.dart';
import 'package:delivery_app/componants/snack_bar.dart';
import 'package:delivery_app/helper/Session.dart';
import 'package:delivery_app/helper/Strings.dart';
import 'package:delivery_app/wedgets/wedget_title_start.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'Home_screen.dart';
import '../componants/build_circle_avatar.dart';
import '../constants.dart';
import 'policy_screen.dart';

class AuthScreen extends StatefulWidget {
  static const String id = 'authScreen';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

enum Auth { singIN, singUp }

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth.singIN;
  late String _username, _password, _confirmPassword, _email;
  bool _visible = true;
  String choose = USER;
  bool checkBox = false, policy = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? category = categoriesString[0];
  String? _emailValidator(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value!.length == 0) {
      return getTranslated(context, 'Please enter email');
    } else if (!regExp.hasMatch(value)) {
      return getTranslated(context, 'Please enter valid email');
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.height;
    final passwordField = TextFormField(
      obscureText: _visible,
      validator: (value) => value!.isEmpty
          ? getTranslated(context, 'Please enter password')
          : null,
      onSaved: (value) => _password = value!,
      decoration: buildInputDecoration(
        Icons.lock_outlined,
        Colors.black,
      ).copyWith(
        suffixIcon: IconButton(
          icon: Icon(_visible ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _visible = !_visible;
            });
          },
        ),
      ),
    );
    final confirmPasswordField = TextFormField(
      obscureText: _visible,
      validator: (value) => value!.isEmpty
          ? getTranslated(context, 'Please enter confirm password')
          : null,
      onSaved: (value) => _confirmPassword = value!,
      decoration: buildInputDecoration(
        Icons.lock_outlined,
        Colors.black,
      ).copyWith(
        suffixIcon: IconButton(
          icon: Icon(_visible ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _visible = !_visible;
            });
          },
        ),
      ),
    );
    final emailField = TextFormField(
      validator: _emailValidator,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) => _email = value!,
      decoration: buildInputDecoration(
        Icons.email_outlined,
        Colors.black,
      ),
    );
    final usernameField = TextFormField(
      validator: (value) => value!.isEmpty
          ? getTranslated(context, 'Please enter username')
          : null,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) => _username = value!,
      decoration: buildInputDecoration(
        Icons.person,
        Colors.black,
      ),
    );
    return SafeArea(
      child: Scaffold(
        body: CustomPaint(
          size: Size(width, height),
          painter: BackgroundCustomColor(context),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              //todo add path widget to draw this screen
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TitleStart(),
                SizedBox(height: height * 0.05),
                _auth == Auth.singIN
                    ? Text(
                        getTranslated(context, 'Welcome Back!'),
                        style: Theme.of(context).textTheme.headline3,
                      )
                    : const SizedBox(),
                SizedBox(height: height * 0.02),
                Text(
                  getTranslated(context, 'Enter your credentials to continue'),
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: height * 0.02),
                Row(
                  children: [
                    GestureDetector(
                      child: BuildCircleAvatar(FontAwesomeIcons.facebook),
                      onTap: () {
                        AuthBloc.get(context).add(SignInWithFacebook());
                      },
                    ),
                    SizedBox(width: width * 0.01),
                    GestureDetector(
                      child: BuildCircleAvatar(FontAwesomeIcons.google),
                      onTap: () async {
                        AuthBloc.get(context).add(SignInWithGoogle());
                      },
                    ),
                    SizedBox(width: width * 0.01),
                    Text(
                      getTranslated(context, 'OR'),
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const Expanded(
                      child: const Divider(),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.02),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _auth == Auth.singUp
                          ? Text(
                              choose == USER
                                  ? getTranslated(context, 'Username')
                                  : getTranslated(context, 'Store Name'),
                              style: Theme.of(context).textTheme.headline6)
                          : const SizedBox(),
                      _auth == Auth.singUp ? usernameField : const SizedBox(),
                      Text(getTranslated(context, 'Email'),
                          style: Theme.of(context).textTheme.headline6),
                      emailField,
                      SizedBox(height: height * 0.02),
                      Text(getTranslated(context, 'Password'),
                          style: Theme.of(context).textTheme.headline6),
                      passwordField,
                      _auth == Auth.singUp
                          ? SizedBox(height: height * 0.02)
                          : const SizedBox(),
                      _auth == Auth.singUp
                          ? Text(getTranslated(context, 'ConfirmPassword'),
                              style: Theme.of(context).textTheme.headline6)
                          : const SizedBox(),
                      _auth == Auth.singUp
                          ? confirmPasswordField
                          : const SizedBox(),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                _auth == Auth.singIN
                    ? Row(
                        children: [
                          const Spacer(),
                          GestureDetector(
                            child: Text(
                              getTranslated(context, 'Forget Password'),
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            onTap: () {},
                          ),
                        ],
                      )
                    : const SizedBox(),
                SizedBox(height: height * 0.01),
                Auth.singUp == _auth
                    ? Row(
                        children: [
                          Text(
                            getTranslated(context, 'Are you have a store?'),
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          const Spacer(),
                          Checkbox(
                              value: checkBox,
                              onChanged: (val) {
                                setState(() {
                                  checkBox = val!;
                                  if (checkBox == false)
                                    choose = USER;
                                  else
                                    choose = DELIVERY;
                                });
                              }),
                        ],
                      )
                    : const SizedBox(),
                Auth.singUp == _auth
                    ? Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, PolicyScreen.id);
                            },
                            child: Text(getTranslated(context, 'Policy'),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(
                                      color: Colors.blueAccent,
                                      decoration: TextDecoration.underline,
                                    )),
                          ),
                          const Spacer(),
                          Checkbox(
                              value: policy,
                              onChanged: (val) {
                                setState(() {
                                  policy = val!;
                                });
                              }),
                        ],
                      )
                    : const SizedBox(),
                Auth.singUp == _auth && checkBox == true
                    ? DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: category,
                          items: categoriesString.map((e) {
                            if (e != 'All')
                              return DropdownMenuItem(
                                  value: e,
                                  child: Text(getTranslated(context, e)));
                            return DropdownMenuItem(
                                value: e,
                                child: Text(
                                    getTranslated(context, 'Choose category')));
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              category = val.toString();
                            });
                          },
                        ),
                      )
                    : const SizedBox(),
                SizedBox(height: height * 0.01),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (ctx, state) {
                    if (state is AuthLoading) {
                      return SpinKitFadingCube(
                        color: Theme.of(context).shadowColor,
                      );
                    }
                    if (state is AuthSingInSuccess) {
                      /// todo SchedulerBinding مافهمتا هي وبدونا عبضرب
                      SchedulerBinding.instance!
                          .addPostFrameCallback((timeStamp) {
                        BlocProduct.get(context).add(FetchProducts());

                        /// start load data
                        Navigator.pushNamedAndRemoveUntil(
                            context, Home.id, (r) => false);
                      });
                    }
                    if (state is AuthSingInError) {
                      SchedulerBinding.instance!
                          .addPostFrameCallback((timeStamp) {
                        setSnackbar(state.msg, context);
                      });
                    }
                    return BuildButton(
                        height: height,
                        width: width,
                        title: _auth == Auth.singIN
                            ? getTranslated(context, 'Login')
                            : getTranslated(context, 'Sing Up'),
                        onPress: () async {
                          final form = _formKey.currentState;
                          if (form!.validate()) {
                            form.save();
                            if (_auth == Auth.singUp) {
                              if (_password != _confirmPassword) {
                                setSnackbar(
                                    getTranslated(
                                        context, 'Password not the same!'),
                                    context);
                                return;
                              }
                              if (!policy) {
                                setSnackbar(
                                    getTranslated(context,
                                        'Please Agree to the usage policy!'),
                                    context);
                                return;
                              }
                            }
                            if (_auth == Auth.singIN) {
                              AuthBloc.get(context).add(
                                  SingIn(email: _email, password: _password));
                            } else if (_auth == Auth.singUp) {
                              if (category == categoriesString[0] &&
                                  choose == DELIVERY) {
                                setSnackbar(
                                    getTranslated(context,
                                        'Please select Store Category!'),
                                    context);
                                return;
                              }

                              AuthBloc.get(context).add(SingUP(
                                email: _email,
                                password: _password,
                                username: _username,
                                typePerson:
                                    choose == DELIVERY ? DELIVERY : USER,
                                category: category,
                              ));
                            }
                          }
                        });
                  },
                ),
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        _auth == Auth.singIN
                            ? getTranslated(
                                context, "Don't have An Account yet!")
                            : getTranslated(context, 'Do you have An Account!'),
                        style: Theme.of(context).textTheme.headline6),
                    SizedBox(width: width * 0.01),
                    GestureDetector(
                      child: Text(
                          _auth == Auth.singIN
                              ? getTranslated(context, 'Sing Up')
                              : getTranslated(context, 'Sing In'),
                          style: Theme.of(context).textTheme.headline5),
                      onTap: () {
                        setState(() {
                          if (_auth == Auth.singIN)
                            _auth = Auth.singUp;
                          else
                            _auth = Auth.singIN;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
