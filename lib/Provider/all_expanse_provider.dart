import '../model/expense_model.dart';
import '../repository/get_expanse.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

ExpenseRepo expanseRepo = ExpenseRepo();
final expenseProvider = FutureProvider.autoDispose<List<ExpenseModel>>(
    (ref) => expanseRepo.getAllExpense());
