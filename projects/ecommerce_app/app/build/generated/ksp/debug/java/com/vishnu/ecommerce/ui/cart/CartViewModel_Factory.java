package com.vishnu.ecommerce.ui.cart;

import com.google.firebase.auth.FirebaseAuth;
import com.vishnu.ecommerce.data.remote.repository.CartRepository;
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
public final class CartViewModel_Factory implements Factory<CartViewModel> {
  private final Provider<CartRepository> cartRepositoryProvider;

  private final Provider<OrderRepository> orderRepositoryProvider;

  private final Provider<FirebaseAuth> firebaseAuthProvider;

  public CartViewModel_Factory(Provider<CartRepository> cartRepositoryProvider,
      Provider<OrderRepository> orderRepositoryProvider,
      Provider<FirebaseAuth> firebaseAuthProvider) {
    this.cartRepositoryProvider = cartRepositoryProvider;
    this.orderRepositoryProvider = orderRepositoryProvider;
    this.firebaseAuthProvider = firebaseAuthProvider;
  }

  @Override
  public CartViewModel get() {
    return newInstance(cartRepositoryProvider.get(), orderRepositoryProvider.get(), firebaseAuthProvider.get());
  }

  public static CartViewModel_Factory create(Provider<CartRepository> cartRepositoryProvider,
      Provider<OrderRepository> orderRepositoryProvider,
      Provider<FirebaseAuth> firebaseAuthProvider) {
    return new CartViewModel_Factory(cartRepositoryProvider, orderRepositoryProvider, firebaseAuthProvider);
  }

  public static CartViewModel newInstance(CartRepository cartRepository,
      OrderRepository orderRepository, FirebaseAuth firebaseAuth) {
    return new CartViewModel(cartRepository, orderRepository, firebaseAuth);
  }
}
