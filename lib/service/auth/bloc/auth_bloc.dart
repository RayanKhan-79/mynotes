
import 'dart:developer' as dev;

import 'package:bloc/bloc.dart';
import 'package:mynotes/service/auth/auth_service.dart';
import 'package:mynotes/service/auth/bloc/auth_event.dart';
import 'package:mynotes/service/auth/bloc/auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState>
{
  final AuthService provider;
  
  AuthBloc({required this.provider}) : super(UnInitializedState(exception: null, isLoading: false))
  {

    on<SendResetPasswordEmailEvent>((event, emit) async
    {
      try
      {
        if (event.email == null)
        {
          emit(ResetPasswordState
          (
            exception: null,
            isLoading: false,
            emailSent: false
          ));
        }
        else
        {
          emit(ResetPasswordState
          (
            exception: null,
            isLoading: true,
            emailSent: false
          ));

          await provider.sendResetPasswordEmail(email: event.email!);

          emit(ResetPasswordState
          (
            exception: null,
            isLoading: false,
            emailSent: true
          ));
        }
      }
      on Exception catch (e)
      {
        emit(ResetPasswordState
        (
          exception: e,
          isLoading: false,
          emailSent: false
        ));
      }
    });

    on<ShouldRegisterEvent>((event, emit)
    {
      emit(RegisteringState
      (
        exception: null,
        isLoading: false
      ));
    });

    on<SendEmailVerificationEvent>((event, emit) async
    {
      final email = (state as UnVerifiedState).email;
      final password = (state as UnVerifiedState).password;

      emit(UnVerifiedState
      (
        exception: null,
        isLoading: true,
        email: email,
        password: password
      ));

      await provider.sendEmailVerification();
      
      emit(UnVerifiedState
      (
        exception: null,
        isLoading: false,
        email: email,
        password: password
      ));

    });

    on<VeriyEmailEvent>((event, emit) async
    {
      final email = (state as UnVerifiedState).email;
      final password = (state as UnVerifiedState).password;
      
      try 
      {
        emit(UnVerifiedState
        (
          exception: null, 
          isLoading: true, 
          email: email, 
          password: password
        ));

        await provider.verifyAndLogin
        (
          email: email, 
          password: password
        );

        emit(LoggedInState
        (
          exception: null, 
          isLoading: false)
        );

      } 
      on Exception catch (e) 
      {
        emit(UnVerifiedState
        (
          exception: e,
          isLoading: false,
          email: email,
          password: password
        ));
      }
    });

    on<InitializeEvent>((event, emit) async 
    {
        emit(UnInitializedState(exception: null, isLoading: false));

        dev.log('BINGO');

        await provider.initialize();
        if (provider.currentUser == null)
          emit(LoggedOutState
          (
            exception: null,
            isLoading: false
          ));

        else if (provider.currentUser!.verified == false)
          emit(LoggedOutState
          (
            exception: null,
            isLoading: false
          ));

        else
          emit(LoggedInState
          (
            exception: null,
            isLoading: false
          ));

    });

    on<RegisterEvent>((event, emit) async
    {
      try 
      {
        emit(RegisteringState(exception: null, isLoading: true));
        await provider.signup(email: event.email, password: event.password);
        await provider.sendEmailVerification();
        emit(UnVerifiedState
        (
          exception: null,
          isLoading: false,
          email: event.email,
          password: event.password
        ));
      }
      on Exception catch (e) 
      {
        emit(RegisteringState(exception: e, isLoading: false));  
      }

    });

    on<LogoutEvent>((event, emit) async 
    {
      try 
      {
        if (state is LoggedInState)
        {
          emit(LoggedInState
          (
            exception: null,
            isLoading: true
          ));
        }
        else if (state is RegisteringState)
        {
          emit(RegisteringState
          (
            exception: null,
            isLoading: true
          ));
        }
        else if (state is ResetPasswordState)
        {
          emit(ResetPasswordState
          (
            exception: null,
            isLoading: true,
            emailSent: false,
          ));
        }
        await provider.logout();
        emit(LoggedOutState
        (
          exception: null,
          isLoading: false
        ));
      } 
      on Exception catch (e) 
      {
        if (state is LoggedInState)
        {
          emit(LoggedInState
          (
            exception: e,
            isLoading: false
          ));
        }
        else if (state is RegisteringState)
        {
          emit(RegisteringState
          (
            exception: e,
            isLoading: false
          ));
        }
        else if (state is ResetPasswordState)
        {
          emit(ResetPasswordState
          (
            exception: e,
            isLoading: false,
            emailSent: false,
          ));
        }
      }
      
    });

    on<LoginEvent>((event, emit) async 
    {
      try 
      {
        emit(LoggedOutState
        (
          exception: null,
          isLoading: true
        ));

        final user = await provider.login(email: event.email, password: event.password);
        if (!user.verified)
        {
          await provider.sendEmailVerification();
          emit(UnVerifiedState
          (
            exception: null,
            isLoading: false,
            email: event.email, 
            password: event.password
          ));
        }
        else 
          emit(LoggedInState(exception: null, isLoading: false));
      } 
      on Exception catch (e) 
      {
        emit(LoggedOutState
        (
          exception: e,
          isLoading: false
        ));
      }

    });
  }

  @override
  void onTransition(Transition<AuthEvent, AuthState> transition) 
  {
    super.onTransition(transition);
    
    dev.log('Auth => ${transition.toString()}');
  }
}