sealed class Result<R, E> {
  const Result();

  factory Result.ok(R value) => Ok(value);
  factory Result.error(E error) => Error(error);
}

final class Ok<R, E> extends Result<R, E> {
  final R value;

  const Ok(this.value);
}

final class Error<R, E> extends Result<R, E> {
  final E error;

  const Error(this.error);
}
