package com.vishnu.ecommerce.ui.product;

import com.vishnu.ecommerce.data.remote.repository.CartRepository;
import com.vishnu.ecommerce.data.remote.repository.ProductRepository;
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
public final class ProductDetailViewModel_Factory implements Factory<ProductDetailViewModel> {
  private final Provider<ProductRepository> productRepositoryProvider;

  private final Provider<CartRepository> cartRepositoryProvider;

  public ProductDetailViewModel_Factory(Provider<ProductRepository> productRepositoryProvider,
      Provider<CartRepository> cartRepositoryProvider) {
    this.productRepositoryProvider = productRepositoryProvider;
    this.cartRepositoryProvider = cartRepositoryProvider;
  }

  @Override
  public ProductDetailViewModel get() {
    return newInstance(productRepositoryProvider.get(), cartRepositoryProvider.get());
  }

  public static ProductDetailViewModel_Factory create(
      Provider<ProductRepository> productRepositoryProvider,
      Provider<CartRepository> cartRepositoryProvider) {
    return new ProductDetailViewModel_Factory(productRepositoryProvider, cartRepositoryProvider);
  }

  public static ProductDetailViewModel newInstance(ProductRepository productRepository,
      CartRepository cartRepository) {
    return new ProductDetailViewModel(productRepository, cartRepository);
  }
}
