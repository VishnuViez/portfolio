package com.vishnu.ecommerce.ui.orders;

import com.google.firebase.auth.FirebaseAuth;
import com.vishnu.ecommerce.data.remote.repository.OrderRepository;
import dagger.internal.DaggerGenerated;
import dagger.internal.Factory;
import dagger.internal.QualifierMetadata;
import dagger.internal.ScopeMetadata;
import javax.annotation.processing.Generated;
import javax.inject.Provider;

@ScopeMetadata
@QualifierMetadata
@DaggerGenerated
@Generated(
    value = "dagger.internal.codegen.ComponentProcessor",
    comments = "https://dagger.dev"
)
@SuppressWarnings({
    "unchecked",
    "rawtypes",
    "KotlinInternal",
    "KotlinInternalInJava"
})
public final class OrdersViewModel_Factory implements Factory<OrdersViewModel> {
  private final Provider<OrderRepository> orderRepositoryProvider;

  private final Provider<FirebaseAuth> firebaseAuthProvider;

  public OrdersViewModel_Factory(Provider<OrderRepository> orderRepositoryProvider,
      Provider<FirebaseAuth> firebaseAuthProvider) {
    this.orderRepositoryProvider = orderRepositoryProvider;
    this.firebaseAuthProvider = firebaseAuthProvider;
  }

  @Override
  public OrdersViewModel get() {
    return newInstance(orderRepositoryProvider.get(), firebaseAuthProvider.get());
  }

  public static OrdersViewModel_Factory create(Provider<OrderRepository> orderRepositoryProvider,
      Provider<FirebaseAuth> firebaseAuthProvider) {
    return new OrdersViewModel_Factory(orderRepositoryProvider, firebaseAuthProvider);
  }

  public static OrdersViewModel newInstance(OrderRepository orderRepository,
      FirebaseAuth firebaseAuth) {
    return new OrdersViewModel(orderRepository, firebaseAuth);
  }
}
