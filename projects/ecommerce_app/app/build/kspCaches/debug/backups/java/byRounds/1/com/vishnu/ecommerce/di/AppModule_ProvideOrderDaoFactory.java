package com.vishnu.ecommerce.di;

import com.vishnu.ecommerce.data.local.dao.OrderDao;
import com.vishnu.ecommerce.data.local.database.ShopDatabase;
import dagger.internal.DaggerGenerated;
import dagger.internal.Factory;
import dagger.internal.Preconditions;
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
public final class AppModule_ProvideOrderDaoFactory implements Factory<OrderDao> {
  private final Provider<ShopDatabase> databaseProvider;

  public AppModule_ProvideOrderDaoFactory(Provider<ShopDatabase> databaseProvider) {
    this.databaseProvider = databaseProvider;
  }

  @Override
  public OrderDao get() {
    return provideOrderDao(databaseProvider.get());
  }

  public static AppModule_ProvideOrderDaoFactory create(Provider<ShopDatabase> databaseProvider) {
    return new AppModule_ProvideOrderDaoFactory(databaseProvider);
  }

  public static OrderDao provideOrderDao(ShopDatabase database) {
    return Preconditions.checkNotNullFromProvides(AppModule.INSTANCE.provideOrderDao(database));
  }
}
