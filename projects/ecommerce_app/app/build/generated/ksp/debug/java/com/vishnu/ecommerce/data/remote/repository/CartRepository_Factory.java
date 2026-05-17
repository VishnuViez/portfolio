package com.vishnu.ecommerce.data.remote.repository;

import com.vishnu.ecommerce.data.local.dao.CartDao;
import dagger.internal.DaggerGenerated;
import dagger.internal.Factory;
import dagger.internal.QualifierMetadata;
import dagger.internal.ScopeMetadata;
import javax.annotation.processing.Generated;
import javax.inject.Provider;

@ScopeMetadata("javax.inject.Singleton")
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
public final class CartRepository_Factory implements Factory<CartRepository> {
  private final Provider<CartDao> cartDaoProvider;

  public CartRepository_Factory(Provider<CartDao> cartDaoProvider) {
    this.cartDaoProvider = cartDaoProvider;
  }

  @Override
  public CartRepository get() {
    return newInstance(cartDaoProvider.get());
  }

  public static CartRepository_Factory create(Provider<CartDao> cartDaoProvider) {
    return new CartRepository_Factory(cartDaoProvider);
  }

  public static CartRepository newInstance(CartDao cartDao) {
    return new CartRepository(cartDao);
  }
}
