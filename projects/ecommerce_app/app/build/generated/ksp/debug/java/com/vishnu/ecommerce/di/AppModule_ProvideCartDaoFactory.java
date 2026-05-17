package com.vishnu.ecommerce.di;

import com.vishnu.ecommerce.data.local.dao.CartDao;
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
public final class AppModule_ProvideCartDaoFactory implements Factory<CartDao> {
  private final Provider<ShopDatabase> databaseProvider;

  public AppModule_ProvideCartDaoFactory(Provider<ShopDatabase> databaseProvider) {
    this.databaseProvider = databaseProvider;
  }

  @Override
  public CartDao get() {
    return provideCartDao(databaseProvider.get());
  }

  public static AppModule_ProvideCartDaoFactory create(Provider<ShopDatabase> databaseProvider) {
    return new AppModule_ProvideCartDaoFactory(databaseProvider);
  }

  public static CartDao provideCartDao(ShopDatabase database) {
    return Preconditions.checkNotNullFromProvides(AppModule.INSTANCE.provideCartDao(database));
  }
}
