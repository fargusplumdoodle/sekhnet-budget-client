import 'package:bloc/bloc.dart';
import 'package:budget/model/models.dart';
import 'package:budget/repositories/repositories.dart';
import 'package:budget/repositories/transaction.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// ------------------  BUDGET STATE
abstract class AddTransactionState extends Equatable {
  const AddTransactionState();

  @override
  List<Object> get props => [];
}

class AddTransactionInitial extends AddTransactionState {}

class AddTransactionLoadInProgress extends AddTransactionState {}

class AddTransactionLoadSuccess extends AddTransactionState {
  final TransactionModel transaction;

  const AddTransactionLoadSuccess({@required this.transaction})
      : assert(transaction != null);

  @override
  List<TransactionModel> get props => [transaction];
}

class AddIncomeLoadSuccess extends AddTransactionState {
  final List<TransactionModel> transactions;

  const AddIncomeLoadSuccess({@required this.transactions})
      : assert(transactions != null);

  @override
  List<TransactionModel> get props => transactions;
}

class AddTransactionLoadFailure extends AddTransactionState {}

// ------------------  BUDGET EVENT
abstract class AddTransactionEvent extends Equatable {
  const AddTransactionEvent();
}

class UpdateTransactionRequested extends AddTransactionEvent {
  final TransactionModel trans;

  UpdateTransactionRequested({@required this.trans}) : assert(trans != null);
  @override
  List<TransactionModel> get props => [trans];
}

class AddTransactionRequested extends AddTransactionEvent {
  final TransactionModel trans;

  const AddTransactionRequested({
    @required this.trans,
  }) : assert(trans != null);

  @override
  List<Object> get props => throw [trans];
}

class AddIncomeRequested extends AddTransactionEvent {
  final int amount;
  final String description;
  final DateTime date;
  const AddIncomeRequested(
      {@required this.amount, @required this.description, @required this.date})
      : assert(amount != null && description != null && date != null);

  @override
  List<Object> get props => throw [];
}

// ------------------  BUDGET BLOC
class AddTransactionBloc
    extends Bloc<AddTransactionEvent, AddTransactionState> {
  final AddTransactionRepository addTransactionRepository;

  AddTransactionBloc({@required this.addTransactionRepository})
      : assert(addTransactionRepository != null),
        super(AddTransactionInitial());

  @override
  Stream<AddTransactionState> mapEventToState(
      AddTransactionEvent event) async* {
    if (event is AddTransactionRequested) {
      yield AddTransactionLoadInProgress();

      try {
        final TransactionModel transaction =
            await addTransactionRepository.addTransaction(event.trans);
        yield AddTransactionLoadSuccess(transaction: transaction);
      } catch (e) {
        print('Failed to add transaction:' + e.toString());
        yield AddTransactionLoadFailure();
      }
    }

    if (event is AddIncomeRequested) {
      yield AddTransactionLoadInProgress();

      try {
        final List<TransactionModel> transactions =
            await addTransactionRepository.addIncome(
                event.amount, event.description, event.date);
        yield AddIncomeLoadSuccess(transactions: transactions);
      } catch (e) {
        print('Failed to add income:' + e.toString());
        yield AddTransactionLoadFailure();
      }
    }

    if (event is UpdateTransactionRequested) {
      yield AddTransactionLoadInProgress();

      try {
        final TransactionModel transaction =
            await addTransactionRepository.updateTransaction(event.trans);
        yield AddTransactionLoadSuccess(transaction: transaction);
      } catch (e) {
        print('Failed to update transaction:' + e.toString());
        yield AddTransactionLoadFailure();
      }
    }
  }
}
