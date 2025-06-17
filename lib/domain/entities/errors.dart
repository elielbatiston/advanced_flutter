// Como exemplo ele deixou a class sealed porem o enum resolve o nosso problema
// enum DomainError {
//   unexpected,
//   sessionExpiredError
// }

sealed class DomainError {}
final class UnexpectedError implements DomainError {}
final class SessionExpiredError implements DomainError {}
