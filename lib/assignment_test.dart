import 'package:assignment_1/assignment_1.dart';

void main() {
  var bank = Bank();

  var savings = SavingsAccount('1234', 'Sarjak', 9000);
  var checking = CheckingAccount('1235', 'Ravi', 2000);
  var premium = PremiumAccount('1236', 'Anisha', 1000);

  bank.createAccount(savings);
  bank.createAccount(checking);
  bank.createAccount(premium);

  savings.withdraw(amount: 200);
  savings.calculateInterest();

  checking.withdraw(amount: 250);

  premium.calculateInterest();

  bank.transfer('1234', '1235', 500);
  bank.generateReport();
}
