# Flutter · Vue · Supabase Starter

Starter độc lập cho Android/iOS, web và backend Supabase local. Không có nghiệp vụ,
đăng nhập, bảng dữ liệu hoặc liên kết đến project cloud.

## Cấu trúc

```text
app/        Flutter, Signals, Riverpod, Việt/Anh, local/dev/prod
web/        Vue 3, TypeScript, Vite, Nuxt UI, Tailwind
supabase/   Supabase CLI config, migrations và seed rỗng
.codex/     Skill Flutter cho Codex
.opencode/  Skill Flutter cho OpenCode
.vscode/    Cấu hình chạy ba flavor Flutter
```

Flutter dùng Signals cho state và Riverpod cho dependency injection. Feature
Counter minh họa screen/store, quản lý dispose và điều hướng bằng RouteInput.
Ngôn ngữ mặc định là tiếng Việt; lựa chọn ngôn ngữ giữ trong bộ nhớ phiên chạy.

## Yêu cầu

- Flutter **3.41.5**, Dart **3.11.3** là toolchain đã dùng để tạo starter.
- Node.js **22.12+**, Yarn **1.22.22**.
- Supabase CLI **2.117.0**, Docker hoặc container runtime tương thích đang chạy.
- Android SDK/JDK và license Android đã chấp nhận cho build Android.
- macOS, Xcode và CocoaPods cho iOS; signing riêng khi phát hành.
- `rtk` để chạy các lệnh dưới đây theo quy tắc của repo.

Dùng Supabase CLI đúng baseline **2.117.0**. CLI v3 thay đổi mặc định target và
một số lệnh: [changelog](https://supabase.com/changelog/supabase-cli-v3).
Starter không tự nâng cấp CLI hoặc link đến cloud.

## 1. Backend local

Từ root repo, với Docker đang chạy:

```sh
rtk proxy supabase start
rtk proxy supabase status
```

Project ID: `flutter-vue-supabase-starter`. Các cổng được tách khỏi dự án nguồn:

| Dịch vụ | Địa chỉ |
| --- | --- |
| API | http://127.0.0.1:55321 |
| PostgreSQL | 127.0.0.1:55322 |
| Studio | http://127.0.0.1:55323 |
| Email local | http://127.0.0.1:55324 |

Dùng publishable key từ output của CLI để cấu hình app/web. Không sao chép toàn bộ
output vào env client vì output có thể chứa cả secret key. Chạy `rtk proxy supabase
stop` tại root khi muốn dừng riêng stack này và giữ dữ liệu.

Chưa có schema nghiệp vụ. Khi cần, tạo migration bằng `rtk proxy supabase migration
new <name>`, bật RLS cho bảng được expose và viết policy theo quyền truy cập thực tế.
Không sao chép migration hay seed từ dự án khác khi chưa rà soát.

## 2. Flutter app

Chạy các lệnh sau trong `app/`:

```sh
rtk proxy cp env/.env.local.example env/.env.local
rtk proxy cp env/.env.dev.example env/.env.dev
rtk proxy cp env/.env.prod.example env/.env.prod
rtk proxy flutter pub get
rtk proxy flutter gen-l10n
```

Cả ba file phải tồn tại do được khai báo là Flutter assets. Điền URL và publishable
key cho môi trường cần chạy:

```dotenv
SUPABASE_URL=http://127.0.0.1:55321
SUPABASE_PUBLISHABLE_KEY=sb_publishable_your_local_key
```

| Thiết bị local | SUPABASE_URL |
| --- | --- |
| iOS Simulator | http://127.0.0.1:55321 |
| Android Emulator | http://10.0.2.2:55321 |
| Thiết bị thật | IP LAN của máy chạy Supabase, cổng 55321 |

```sh
rtk proxy flutter run --flavor local
```

| Flavor | Tên hiển thị | Application/bundle ID |
| --- | --- | --- |
| local | Starter Local | com.example.starterapp.local |
| dev | Starter Dev | com.example.starterapp.dev |
| prod | Starter | com.example.starterapp |

Dùng `--flavor dev` hoặc `--flavor prod` với file môi trường tương ứng đã cấu hình;
hai môi trường này yêu cầu HTTPS. Nếu truyền `APP_ENV`, giá trị phải khớp flavor.
Ba cấu hình tương ứng có sẵn trong VS Code khi mở root repo.

**Tất cả env asset được đóng gói trong mỗi build.** Chỉ chứa URL và publishable key;
không chứa secret/service-role key, password hoặc token riêng tư. Các file thật
được Git ignore. Các giá trị `replace_me` chỉ là placeholder, không chứng minh kết
nối backend đã hoạt động. Khởi động lại app khi đổi cấu hình.

## 3. Web

Chạy trong `web/`:

```sh
rtk proxy yarn install --frozen-lockfile
rtk proxy cp .env.localdev.example .env.localdev.local
rtk proxy cp .env.development.example .env.development.local
rtk proxy cp .env.production.example .env.production.local
```

Điền `VITE_SUPABASE_URL` và `VITE_SUPABASE_PUBLISHABLE_KEY` cho mode cần dùng.
Tên file tách biệt để giá trị local không ghi đè development/production.

```sh
rtk proxy yarn dev:local
```

Web local chạy tại http://127.0.0.1:5173. `yarn dev:development` dùng cấu hình
cloud dev. Mọi biến `VITE_*` đều có thể đọc được từ browser, chỉ dùng publishable key.
Client được khởi tạo lúc startup; trang Home chưa gọi query hoặc yêu cầu đăng nhập.
Thiếu hoặc sai cấu hình sẽ dừng startup với thông báo lỗi.

## Kiểm tra

Trong `app/`:

```sh
rtk proxy flutter analyze
rtk proxy flutter test
rtk proxy flutter build apk --debug --flavor local
rtk proxy flutter build ios --simulator --debug --no-codesign --flavor local
```

Trong `web/`:

```sh
rtk proxy yarn typecheck
rtk proxy yarn test
rtk proxy yarn build:local
rtk proxy yarn build:development
rtk proxy yarn build:production
```

Các build cần các env asset/file môi trường tương ứng. Build thành công không
chứng minh URL/key đúng hoặc backend có thể truy cập được.

## Skill Flutter và thêm feature

- Codex: gọi `$flutter-arch`; skill nằm trong `.codex/skills/flutter-arch/`.
- OpenCode: gọi `@flutter-arch`; skill nằm trong `.opencode/skills/flutter-arch/`.
- Cả hai là opt-in, cùng hướng dẫn kiến trúc thực tế của starter.
- Bắt đầu từ `app/lib/features/counter/`; thêm screen/store, provider factory,
  RouteName, RouteInput, RouteScreen và RoutePage. Provider được tạo một lần cho
  từng route và truyền vào screen, tránh chia sẻ state giữa các lần mở.
- Thêm chuỗi ở cả hai ARB, chạy `rtk proxy flutter gen-l10n`; không sửa file generate.
- Khi sửa quy ước kiến trúc, đồng bộ hai skill và test tương ứng.

## Đổi tên cho sản phẩm mới

- Đổi tên Dart trong `app/pubspec.yaml` và mọi import `package:starter_app/`.
- Android: đổi namespace/applicationId trong `app/android/app/build.gradle.kts`,
  package và thư mục Kotlin của MainActivity, cùng tên hiển thị trong các flavor.
- iOS: đổi bundle IDs cho Runner/RunnerTests và mọi build configuration, cùng
  `APP_DISPLAY_NAME` trong Xcode. Các flavor local/dev giữ hậu tố riêng.
- Đổi tên web trong `web/package.json`, `web/index.html` và `web/src/App.vue`.
- Đổi project ID/cổng Supabase trước lần chạy đầu nếu tạo thêm bản starter song song;
  cập nhật env examples tương ứng. Project ID khác nhưng cổng trùng vẫn xung đột.
- Cập nhật hai skill khi đổi tên package. Tạo icon/branding và signing riêng trước
  khi phát hành; Android release hiện dùng debug signing mặc định của Flutter.

Chưa có CI/CD, auth flow, persistence, nghiệp vụ, monitoring hoặc deploy cloud.

## Kết quả kiểm chứng khi khởi tạo (2026-11-05)

- Flutter analyzer sạch; 20 test thường qua, thêm một test cấu hình flavor chạy riêng.
- Android APK debug local và iOS Simulator debug local build thành công.
- Web: 3 test cấu hình và build local/development/production thành công.
- Hai skill qua validator; các scheme và bundle ID được kiểm tra tĩnh.
- Supabase local khởi động thành công, `select 1` trả về `ok = 1`.
- File env local đã được điền publishable key của stack này và được Git ignore.
- Kiểm tra DOM bằng Chrome headless bị timeout; chưa xác minh UI trong browser.
- Chưa kiểm tra thiết bị thật, build phát hành/signing hoặc backend cloud dev/prod.
