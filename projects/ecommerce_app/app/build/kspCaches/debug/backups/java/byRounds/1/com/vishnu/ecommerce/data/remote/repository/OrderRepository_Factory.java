package com.vishnu.ecommerce.data.remote.repository;

import com.vishnu.ecommerce.data.local.dao.CartDao;
import com.vishnu.ecommerce.data.local.dao.OrderDao;
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
public final class OrderRepository_Factory implements Factory<OrderRepository> {
  private final Provider<OrderDao> orderDaoProvider;

  private final Provider<CartDao> cartDaoProvider;

  public OrderRepository_Factory(Provider<OrderDao> orderDaoProvider,
      Provider<CartDao> cartDaoProvider) {
    this.orderDaoProvider = orderDaoProvider;
    this.cartDaoProvider = cartDaoProvider;
  }

  @Override
  public OrderRepository get() {
    return newInstance(orderDaoProvider.get(), cartDaoProvider.get());
  }

  public static OrderRepository_Factory create(Provider<OrderDao> orderDaoProvider,
      Provider<CartDao> cartDaoProvider) {
    return new OrderRepository_Factory(orderDaoProvider, cartDaoProvider);
  }

  public static OrderRepository newInstance(OrderDao orderDao, CartDao cartDao) {
    return new OrderRepository(orderDao, cartDao);
  }
}
