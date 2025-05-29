import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_labs/features/scanner/cubit/saved_qr_cubit.dart';

class SavedQrScreen extends StatelessWidget {
  const SavedQrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SavedQrCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Збережене повідомлення')),
        body: BlocBuilder<SavedQrCubit, SavedQrState>(
          builder: (context, state) {
            String text;
            if (state is SavedQrLoading) {
              text = 'Зчитування...';
            } else if (state is SavedQrSuccess) {
              text = state.message;
            } else if (state is SavedQrError) {
              text = state.error;
            } else {
              text = 'Невідомий стан';
            }

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
