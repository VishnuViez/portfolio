package com.vishnu.ecommerce.data.remote.repository;

import com.vishnu.ecommerce.data.local.dao.ProductDao;
import com.vishnu.ecommerce.data.remote.api.ShopApiService;
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
public final class ProductRepository_Factory implements Factory<ProductRepository> {
  private final Provider<ShopApiService> apiServiceProvider;

  private final Provider<ProductDao> productDaoProvider;

  public ProductRepository_Factory(Provider<ShopApiService> apiServiceProvider,
      Provider<ProductDao> productDaoProvider) {
    this.apiServiceProvider = apiServiceProvider;
    this.productDaoProvider = productDaoProvider;
  }

  @Override
  public ProductRepository get() {
    return newInstance(apiServiceProvider.get(), productDaoProvider.get());
  }

  public static ProductRepository_Factory create(Provider<ShopApiService> apiServiceProvider,
      Provider<ProductDao> productDaoProvider) {
    return new ProductRepository_Factory(apiServiceProvider, productDaoProvider);
  }

  public static ProductRepository newInstance(ShopApiService apiService, ProductDao productDao) {
    return new ProductRepository(apiService, productDao);
  }
}
