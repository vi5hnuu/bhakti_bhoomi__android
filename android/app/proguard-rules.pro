# Suppress R8 warnings for missing classes referenced by Google Tink
# (pulled in transitively, e.g. via flutter_secure_storage). These annotation
# classes are compile-time only and safe to ignore at runtime.
-dontwarn com.google.errorprone.annotations.CanIgnoreReturnValue
-dontwarn com.google.errorprone.annotations.CheckReturnValue
-dontwarn com.google.errorprone.annotations.Immutable
-dontwarn com.google.errorprone.annotations.RestrictedApi
-dontwarn javax.annotation.Nullable
-dontwarn javax.annotation.concurrent.GuardedBy
