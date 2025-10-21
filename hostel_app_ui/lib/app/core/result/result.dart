sealed class Result<T, E> {
  const Result();

  bool get isSuccess => this is Success<T, E>;
  bool get isFailure => this is Failure<T, E>;

  T get successValue => (this as Success<T, E>).value;
  E get failureValue => (this as Failure<T, E>).error;

  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(E error) onFailure,
  }) {
    if (this is Success<T, E>) {
      return onSuccess(successValue);
    } else {
      return onFailure(failureValue);
    }
  }

  Result<R, E> map<R>(R Function(T value) mapper) {
    return fold(
      onSuccess: (value) => Success(mapper(value)),
      onFailure: (error) => Failure(error),
    );
  }

  Result<T, R> mapError<R>(R Function(E error) mapper) {
    return fold(
      onSuccess: (value) => Success(value),
      onFailure: (error) => Failure(mapper(error)),
    );
  }
}

class Success<T, E> extends Result<T, E> {
  final T value;
  const Success(this.value);

  @override
  String toString() => 'Success($value)';
}

class Failure<T, E> extends Result<T, E> {
  final E error;
  const Failure(this.error);

  @override
  String toString() => 'Failure($error)';
}
