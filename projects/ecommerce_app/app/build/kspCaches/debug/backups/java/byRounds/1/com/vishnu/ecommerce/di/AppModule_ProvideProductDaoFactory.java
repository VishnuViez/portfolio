package com.vishnu.ecommerce.di;

import com.vishnu.ecommerce.data.local.dao.ProductDao;
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
public final class AppModule_ProvideProductDaoFactory implements Factory<ProductDao> {
  private final Provider<ShopDatabase> databaseProvider;

  public AppModule_ProvideProductDaoFactory(Provider<ShopDatabase> databaseProvider) {
    this.databaseProvider = databaseProvider;
  }

  @Override
  public ProductDao get() {
    return provideProductDao(databaseProvider.get());
  }

  public static AppModule_ProvideProductDaoFactory create(Provider<ShopDatabase> databaseProvider) {
    return new AppModule_ProvideProductDaoFactory(databaseProvider);
  }

  public static ProductDao provideProductDao(ShopDatabase database) {
    return Preconditions.checkNotNullFromProvides(AppModule.INSTANCE.provideProductDao(database));
  }
}
