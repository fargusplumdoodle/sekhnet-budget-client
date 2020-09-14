import 'package:bloc/bloc.dart';
import 'package:budget/model/models.dart';
import 'package:budget/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class BudgetState extends Equatable {
  const BudgetState();

  @override
  List<Object> get props => [];
}

class BudgetInitial extends BudgetState {}

class BudgetLoadInProgress extends BudgetState {}

class BudgetLoadSuccess extends BudgetState {
  final List<BudgetModel> budgets;

  const BudgetLoadSuccess({@required this.budgets}) : assert(budgets != null);

  @override
  List<BudgetModel> get props => budgets;
}

class BudgetLoadFailure extends BudgetState {}

abstract class BudgetEvent extends Equatable {
  const BudgetEvent();
}

class BudgetRequested extends BudgetEvent {
  const BudgetRequested();

  @override
  List<Object> get props => throw [];
}

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final BudgetRepository budgetRepository;

  BudgetBloc({@required this.budgetRepository})
      : assert(budgetRepository != null),
        super(BudgetInitial());

  @override
  Stream<BudgetState> mapEventToState(BudgetEvent event) async* {
    if (event is BudgetRequested) {
      yield BudgetLoadInProgress();

      try {
        final List<BudgetModel> budgets = await budgetRepository.getBudgets();
        yield BudgetLoadSuccess(budgets: budgets);
      } catch (_) {
        yield BudgetLoadFailure();
      }
    }
  }
}
