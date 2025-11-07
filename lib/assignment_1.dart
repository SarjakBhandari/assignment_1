// bank account class
abstract class BankAccount {
  final String _accountNumber;
  String _accountHolderName;
  double _balance;

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
      receiver.deposit(amount: amount);
      print('Transferred \$$amount from $fromAcc to $toAcc');
    } else {
      print('Transfer failed. One or both accounts not found.');
    }
  }

  void generateReport() {
    print('\n--- Sarjak Bank Pvt.Ltd ---');
    for (var acc in _accounts) {
      acc.displayInfo();
    }
    print('-------------------');
  }
}
