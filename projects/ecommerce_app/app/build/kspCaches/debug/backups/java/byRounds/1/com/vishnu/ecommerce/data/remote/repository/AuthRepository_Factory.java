package com.vishnu.ecommerce.data.remote.repository;

import com.google.firebase.auth.FirebaseAuth;
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
public final class AuthRepository_Factory implements Factory<AuthRepository> {
  private final Provider<FirebaseAuth> firebaseAuthProvider;

  public AuthRepository_Factory(Provider<FirebaseAuth> firebaseAuthProvider) {
    this.firebaseAuthProvider = firebaseAuthProvider;
  }

  @Override
  public AuthRepository get() {
    return newInstance(firebaseAuthProvider.get());
  }

  public static AuthRepository_Factory create(Provider<FirebaseAuth> firebaseAuthProvider) {
    return new AuthRepository_Factory(firebaseAuthProvider);
  }

  public static AuthRepository newInstance(FirebaseAuth firebaseAuth) {
    return new AuthRepository(firebaseAuth);
  }
}
