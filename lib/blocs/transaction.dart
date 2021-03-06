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

class TransactionLoadFailure extends TransactionState {
  final errorMsg;

  TransactionLoadFailure(this.errorMsg);
}

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

class TransactionDateQueryRequested extends TransactionEvent {
  final TransactionDateQuery data;

  const TransactionDateQueryRequested({
    @required this.data,
  }) : assert(data != null);

  @override
  List<Object> get props => throw [data];
}

class TransferFundsRequested extends TransactionEvent {
  final TransferFundsData data;

  const TransferFundsRequested({
    @required this.data,
  }) : assert(data != null);

  @override
  List<Object> get props => throw [data];
}

class AllTransactionsRequested extends TransactionEvent {
  const AllTransactionsRequested();

  @override
  List<Object> get props => [];
}

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final BudgetRepository budgetRepository =
      BudgetRepository(budgetApiClient: BudgetApiClient());
  final AddTransactionRepository transactionRepository =
      AddTransactionRepository(
          addTransactionApiClient: AddTransactionApiClient());

  TransactionBloc() : super(TransactionInitial());

  @override
  Stream<TransactionState> mapEventToState(TransactionEvent event) async* {
    if (event is TransactionRequested) {
      yield TransactionLoadInProgress();

      try {
        final List<TransactionModel> transactions = await budgetRepository
            .getTransactions(event.budgetID, event.maxTransactions);

        yield TransactionLoadSuccess(transactions: transactions);
      } catch (e) {
        yield TransactionLoadFailure(e.toString());
      }
    }
    if (event is AllTransactionsRequested) {
      yield TransactionLoadInProgress();

      try {
        final List<TransactionModel> transactions =
            await transactionRepository.getAllTransactions();

        yield TransactionLoadSuccess(transactions: transactions);
      } catch (e) {
        yield TransactionLoadFailure(e.toString());
      }
    }

    if (event is TransferFundsRequested) {
      yield TransactionLoadInProgress();

      try {
        final List<TransactionModel> transactions =
            await transactionRepository.transferFunds(event.data);
        yield TransactionLoadSuccess(transactions: transactions);
      } catch (e) {
        print('Failed to transfer funds:' + e.toString());
        yield TransactionLoadFailure(e);
      }
    }

    if (event is TransactionDateQueryRequested) {
      yield TransactionLoadInProgress();

      try {
        final List<TransactionModel> transactions =
            await transactionRepository.getTransactionsDateQuery(event.data);
        yield TransactionLoadSuccess(transactions: transactions);
      } catch (e) {
        print('Failed to get transactions:' + e.toString());
        yield TransactionLoadFailure(e);
      }
    }
  }
}
