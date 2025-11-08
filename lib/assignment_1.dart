// bank account class
abstract class BankAccount {
  final String _accountNumber;
  String _accountHolderName;
  double _balance;
  final List<String> _transactions = [];
  List<String> get transactionHistory {
    return List.unmodifiable(_transactions);
  }

  BankAccount(this._accountNumber, this._accountHolderName, this._balance);

  String get accountNumber {
    return _accountNumber;
  }

  String get accountHolderName {
    return _accountHolderName;
  }

  double get balance {
    return _balance;
  }

  set accountHolderName(String name) {
    _accountHolderName = name;
  }

  void deposit({required double amount});
  void withdraw({required double amount});

  void displayInfo() {
    print('Account Number: $_accountNumber');
    print('Account Holder: $_accountHolderName');
    print('Balance: \$$_balance');
    print('Transactions:');
    for (var t in _transactions) {
      print(' - $t');
    }
  }

  void addTransaction(String description) {
    _transactions.add(description);
  }
}

abstract class InterestBearing {
  // abstract interest bearing class
  void calculateInterest();
}

class SavingsAccount extends BankAccount implements InterestBearing {
  int _withdrawalsThisMonth = 0;
  static const int maxWithdrawals = 3;
  static const double minBalance = 500.0;

  SavingsAccount(
    super._accountNumber,
    super._accountHolderName,
    super._balance,
  );

  @override
  void withdraw({required double amount}) {
    if (_withdrawalsThisMonth >= maxWithdrawals) {
      print('Withdrawal limit reached for this month. try again next month');
      return;
    }
    if (balance - amount >= minBalance) {
      _balance -= amount;
      _withdrawalsThisMonth++;
      print('Withdrew \$ $amount successfuly');
    } else {
      print('Cannot withdraw. it is less than minimum balance');
    }
  }

  @override
  void calculateInterest() {
    double interest = balance * 0.02;
    _balance += interest;
    print('Interest of \$$interest added.');
  }

  @override
  void deposit({required double amount}) {
    if (amount >= 0) {
      _balance += amount;
      print('Deposited \$$amount} successfully');
    } else {
      print('money must be greater than 0. ');
    }
  }
}

class CheckingAccount extends BankAccount {
  static const double overdraftFee = 35.0;
  CheckingAccount(super.accNo, super.name, super.balance);
  @override
  void withdraw({required double amount}) {
    _balance -= amount;
    if (_balance < 0) {
      _balance -= overdraftFee;
      print(
        'Attempting to withdraw when balance is not enough. !! Overdraft! \$35 fee applied. !!',
      );
    }
    print('Withdrew \$$amount');
  }

  @override
  void deposit({required double amount}) {
    if (amount >= 0) {
      _balance += amount;
      print('Deposited \$$amount successfully');
    } else {
      print('money must be greater than 0. ');
    }
  }
}

class PremiumAccount extends BankAccount implements InterestBearing {
  static const double minBalance = 10000.0;

  PremiumAccount(super.accNo, super.name, super.balance);

  @override
  void withdraw({required double amount}) {
    if (balance - amount >= 0) {
      _balance -= amount;
      print('Withdrew \$$amount');
    } else {
      print('Insufficient funds. Please deposit money!');
    }
  }

  @override
  void calculateInterest() {
    double interest = balance * 0.05;
    _balance += interest;
    print('Interest of \$$interest');
  }

  @override
  void deposit({required double amount}) {
    if (amount >= 0) {
      _balance += amount;
      print('Deposited \$$amount successfully');
    } else {
      print('money must be greater than 0. ');
    }
  }
}

class Bank {
  final List<BankAccount> _accounts = [];

  void createAccount(BankAccount account) {
    _accounts.add(account);
    print('Account created for ${account.accountHolderName}');
  }

  BankAccount? findAccount(String accountNumber) {
    try {
      return _accounts.firstWhere((acc) => acc.accountNumber == accountNumber);
    } catch (e) {
      print('Account not found.');
      return null;
    }
  }

  void transfer(String fromAcc, String toAcc, double amount) {
    var sender = findAccount(fromAcc);
    var receiver = findAccount(toAcc);

    if (sender != null && receiver != null) {
      sender.withdraw(amount: amount);
      sender.addTransaction('Transferred \$$amount to $toAcc');
      receiver.deposit(amount: amount);
      receiver.addTransaction('Recieved \$$amount to $toAcc');
      print('Transferred \$$amount from $fromAcc to $toAcc');
    } else {
      print('Transfer failed. One or both accounts not found.');
    }
  }

  void applyMonthlyInterest() {
    for (var acc in _accounts) {
      if (acc is InterestBearing) {
        (acc as InterestBearing).calculateInterest();
        acc.addTransaction('Monthly interest applied');
      }
    }
    print('Monthly interest applied to all interest-bearing accounts.');
  }

  void generateReport() {
    print('\n--- Sarjak Bank Pvt.Ltd ---');
    for (var acc in _accounts) {
      acc.displayInfo();
    }
    print('-------------------');
  }
}

class StudentAccount extends BankAccount {
  static const double maxBalance = 5000.0;

  StudentAccount(super.accNo, super.name, super.balance);

  @override
  void withdraw({required double amount}) {
    if (balance - amount >= 0) {
      _balance -= amount;
      addTransaction('Withdrew \$${amount.toStringAsFixed(2)}');
      print('Withdrew \$$amount');
    } else {
      print('Insufficient funds.');
    }
  }

  @override
  void deposit({required double amount}) {
    if (amount >= 0 && balance + amount <= maxBalance) {
      _balance += amount;
      addTransaction('Deposited \$${amount.toStringAsFixed(2)}');
      print('Deposited \$$amount successfully');
    } else {
      print('Deposit exceeds maximum allowed balance of \$5000.');
    }
  }
}
