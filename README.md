# peopleslab

Production-ready Flutter skeleton with clean feature-first architecture, basic auth screens, and gRPC scaffolding.

## Structure

- `lib/app/`: App bootstrap and global pages
  - `app.dart`: `MaterialApp` + routes
  - `home_page.dart`: placeholder home
- `lib/core/`: Cross-cutting concerns
  - `config/app_config.dart`: flags and endpoints
  - `grpc/grpc_channel.dart`: channel factory
  - `router/app_router.dart`: route names and generator
  - `providers.dart`: DI (Riverpod)
  - `utils/validators.dart`: form validators
- `lib/common/`: Shared UI widgets
  - `widgets/primary_button.dart`: full-width button with loading
- `lib/features/auth/`: Auth feature
  - `domain/auth_repository.dart`: repository contract + `AuthUser`
  - `data/fake_auth_repository.dart`: local fake backend
  - `data/grpc_auth_repository.dart`: placeholder for gRPC
  - `presentation/controllers/auth_controller.dart`: Riverpod state
  - `presentation/login_page.dart`, `presentation/register_page.dart`: forms

## Dependencies

- `flutter_riverpod`: state management and DI
- `grpc`, `protobuf`: gRPC client/runtime

Run to fetch packages:

```
flutter pub get
```

## Configure backend

- Toggle fake vs real backend in `lib/core/config/app_config.dart` via `useFakeBackend`.
- Set `grpcHost`, `grpcPort`, `grpcUseTls`.

## Hooking up gRPC

1. Generate Dart stubs from your `.proto` files to `lib/gen/` (suggested):
   - Example command: `protoc --dart_out=grpc:lib/gen -Iprotos protos/*.proto`
2. Inject the generated client into `GrpcAuthRepository` and implement `signIn/signUp`.
3. Flip `useFakeBackend` to `false`.

## Development

- Start: `flutter run`
- Lints: see `analysis_options.yaml` (Flutter recommended lints)


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
