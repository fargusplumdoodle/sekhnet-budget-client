import 'package:bloc/bloc.dart';
import 'package:budget/model/models.dart';
import 'package:budget/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoadInProgress extends TransactionState {}

class TransactionLoadSuccess extends TransactionState {
  final List<TransactionModel> transactions;

  const TransactionLoadSuccess({@required this.transactions})
      : assert(transactions != null);

  @override
  List<TransactionModel> get props => transactions;
}

class TransactionLoadFailure extends TransactionState {}

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
}

class TransactionRequested extends TransactionEvent {
  final int maxTransactions;
  final int budgetID;
  const TransactionRequested(
      {@required this.budgetID, @required this.maxTransactions})
      : assert(maxTransactions != null && budgetID != null);

  @override
  List<Object> get props => throw [budgetID, maxTransactions];
}

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final BudgetRepository budgetRepository;

  TransactionBloc({@required this.budgetRepository})
      : assert(budgetRepository != null),
        super(TransactionInitial());

  @override
  Stream<TransactionState> mapEventToState(TransactionEvent event) async* {
    if (event is TransactionRequested) {
      yield TransactionLoadInProgress();

      try {
        final List<TransactionModel> transactions = await budgetRepository
            .getTransactions(event.budgetID, event.maxTransactions);
        yield TransactionLoadSuccess(transactions: transactions);
      } catch (_) {
        yield TransactionLoadFailure();
      }
    }
  }
}
