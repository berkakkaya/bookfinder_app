class ServiceProviderNotInitializedError extends StateError {
  final String providerName;

  ServiceProviderNotInitializedError({
    required this.providerName,
    String? message,
  }) : super(message ??
            "$providerName must be initialized before getting its service instance");

  @override
  String toString() {
    return "ServiceProviderNotInitializedError: $message (provider: $providerName)";
  }
}
