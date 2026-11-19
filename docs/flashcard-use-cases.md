# Tài liệu phân tích use case ứng dụng flashcard tiếng Nhật

**Tên sản phẩm tạm thời:** Nihongo Cards  
**Phiên bản tài liệu:** 1.2  
**Ngày lập:** 19/11/2026  
**Đối tượng sử dụng:** Chủ sản phẩm, thiết kế, lập trình viên và kiểm thử viên.

Tài liệu mô tả các tác nhân, quyền truy cập, luồng nghiệp vụ, ngoại lệ và tiêu chí nghiệm thu cho ứng dụng flashcard trên điện thoại, website học tập và website quản trị. Trọng tâm là học từ vựng có Kanji và dòng Hiragana, kết hợp hình ảnh, ví dụ và ghi chú cá nhân.

Các yêu cầu đã được xác định từ trao đổi gồm đăng nhập, đăng xuất, bộ thẻ có sẵn, thẻ có ảnh và chữ, ghi chú, Kanji và Hiragana, bản web, bản app và web admin. Các chính sách chi tiết trong tài liệu là **đề xuất nghiệp vụ để triển khai và rà soát**, chưa phải những chức năng đã tồn tại trong mã nguồn.

**Quyết định hiện tại:** Tạm thời không yêu cầu xác minh email khi đăng ký hoặc đăng nhập. Đăng ký thành công tạo tài khoản hoạt động ngay; người dùng có thể đăng nhập và học mà không mở email xác nhận. AC02 được giữ làm đặc tả mở rộng P2, không thuộc luồng hiện tại. Email khôi phục mật khẩu vẫn được hỗ trợ.

## 1 Mục tiêu và phạm vi

### 1.1 Mục tiêu sản phẩm

Người học có thể chọn một bộ thẻ có sẵn hoặc tự tạo bộ thẻ, học từ mới, tự đánh giá mức nhớ và ôn lại những thẻ đến hạn. Một tài khoản dùng chung trên web và điện thoại. Quản trị viên xây dựng và duy trì nội dung chính thức mà không can thiệp vào ghi chú riêng của người học.

Giá trị cốt lõi là cho phép người học kiểm soát việc hiện cách đọc Hiragana: có thể xem ngay khi mới học, ẩn để luyện đọc Kanji và mở gợi ý khi cần.

### 1.2 Phân kỳ đề xuất

| Mức | Ý nghĩa | Phạm vi |
|---|---|---|
| P0 | Luồng cốt lõi cần hoàn thành trước khi phát hành MVP | Tài khoản; bộ thẻ chính thức; bộ thẻ riêng; ảnh; Kanji và Hiragana; học và ôn; ghi chú; đồng bộ; quản trị nội dung và phân quyền |
| P1 | Hoàn thiện vận hành sau khi các luồng P0 ổn định | Quản lý phiên đăng nhập khác; mục yêu thích; báo lỗi; import CSV; quản lý chủ đề; thống kê quản trị |
| P2 | Mở rộng, chưa thuộc MVP | Xác minh email khi đăng ký; phát âm; furigana theo từng cụm; thẻ Kanji chuyên biệt; chia sẻ cộng đồng; AI; offline; xuất dữ liệu cá nhân |

P0 và P1 đều được đặc tả ở mức use case để nhìn thấy toàn bộ hệ thống. AC02 được giữ dưới dạng đặc tả dự kiến P2 trong mục 6; các phần mở rộng P2 khác được định hướng trong mục 13. P2 không được hiểu là cam kết triển khai cùng bản đầu tiên.

### 1.3 Ranh giới hệ thống

| Thành phần | Trách nhiệm |
|---|---|
| App iOS và Android | Học, ôn, thư viện, tạo thẻ, ảnh, ghi chú và tài khoản |
| Web người học | Cùng nghiệp vụ và dữ liệu với app; tối ưu thao tác bàn phím và nhập nội dung |
| Web admin | Quản lý nội dung chính thức, người dùng, vai trò và vận hành |
| Backend dùng chung | Xác thực quyền, lưu dữ liệu, ghi nhận lượt ôn, tính lịch, đồng bộ và audit |
| Dịch vụ email bên ngoài | Gửi thư khôi phục mật khẩu và thông báo bảo mật; không gửi thư xác minh khi đăng ký trong phạm vi hiện tại |

Không có thanh toán, gói thuê bao, mạng xã hội, lớp học hoặc kỳ thi chấm điểm chính thức trong phạm vi hiện tại. MVP cần kết nối mạng để xác nhận thay đổi và lưu tiến độ; chế độ offline hoàn chỉnh thuộc P2.

## 2 Thuật ngữ và mô hình nghiệp vụ

| Thuật ngữ | Định nghĩa |
|---|---|
| Bộ thẻ | Tập hợp flashcard theo chủ đề hoặc cấp độ; dùng từ bộ thẻ thay cho bộ đề khi không có bài thi |
| Bộ chính thức | Nội dung do admin quản lý và xuất bản |
| Bộ cá nhân | Nội dung do người học tạo, mặc định riêng tư |
| Thư viện | Danh sách bộ thẻ người dùng đang theo học hoặc tự sở hữu |
| Ghi chú nội dung | Nội dung giải thích do tác giả bộ thẻ cung cấp; ai được xem thẻ thì xem được phần này |
| Ghi chú cá nhân | Nội dung riêng của từng người học trên một thẻ; không được hiển thị cho tác giả bộ hoặc admin |
| Thẻ mới | Người học chưa từng đánh giá thẻ trong luồng học chính thức |
| Thẻ đến hạn | Thẻ có lịch ôn không muộn hơn thời điểm hiện tại và thuộc bộ đang được theo học |
| Phiên học | Một lượt học hoặc ôn có danh sách thẻ, thứ tự và trạng thái riêng |
| Lượt đánh giá | Sự kiện người học chọn Chưa nhớ, Khó, Nhớ hoặc Dễ sau khi mở đáp án |
| Lịch ôn | Thời điểm cần học lại, được tính theo tiến độ riêng của người dùng và thẻ |
| Lưu trữ | Ẩn nội dung khỏi sử dụng mới, vẫn giữ định danh và các dữ liệu liên quan theo chính sách |

### 2.1 Các đối tượng dữ liệu chính

| Đối tượng | Thông tin nghiệp vụ quan trọng |
|---|---|
| Hồ sơ người dùng | Định danh, tên, ảnh đại diện, trạng thái, vai trò, múi giờ và thiết lập học |
| Bộ thẻ | Tác giả, loại chính thức hoặc cá nhân, tên, mô tả, cấp độ, chủ đề, ảnh bìa và trạng thái |
| Flashcard | Bộ thẻ, loại, từ hoặc câu hỏi, cách đọc, nghĩa hoặc đáp án, ảnh, ví dụ, ghi chú nội dung và phiên bản |
| Quan hệ thư viện | Người dùng, bộ thẻ, đang theo học hay đã gỡ và ngày thêm |
| Tiến độ thẻ | Người dùng, thẻ, trạng thái học, lần ôn trước và thời điểm ôn tiếp theo |
| Lượt học và phiên học | Định danh sự kiện, đánh giá, chế độ học, thời điểm được chấp nhận và trạng thái phiên |
| Ghi chú và yêu thích | Người dùng, thẻ và nội dung hoặc trạng thái cá nhân |
| Báo lỗi nội dung | Thẻ, phiên bản, loại lỗi, mô tả, người gửi, trạng thái xử lý và kết quả |
| Tệp ảnh | Người sở hữu, loại tệp, kích thước, phạm vi truy cập và tham chiếu đang sử dụng |
| Nhật ký quản trị | Người thực hiện, hành động, đối tượng, thời gian và thay đổi liên quan |

Đề xuất MVP: một thẻ thuộc một bộ thẻ. Tiến độ gắn với định danh thẻ, không gắn với vị trí của thẻ trong danh sách. Việc hỗ trợ dùng chung một thẻ giữa nhiều bộ cần thiết kế bổ sung sau.

### 2.2 Nội dung và kiểm tra dữ liệu flashcard

| Trường | Thẻ từ vựng tiếng Nhật | Thẻ chữ hoặc ảnh thông thường |
|---|---|---|
| Nội dung mặt trước | Bắt buộc; ví dụ 学校 hoặc ありがとう | Cần có chữ hoặc ảnh, không được trống cả hai |
| Cách đọc | Bắt buộc khi từ chứa Kanji; ví dụ がっこう | Tùy chọn |
| Nghĩa hoặc đáp án | Bắt buộc | Cần có chữ hoặc ảnh đáp án |
| Ảnh minh họa | Tùy chọn | Tùy chọn theo mặt thẻ |
| Câu ví dụ tiếng Nhật | Tùy chọn | Tùy chọn |
| Cách đọc và dịch câu ví dụ | Tùy chọn; được lưu riêng | Tùy chọn |
| Ghi chú nội dung | Tùy chọn | Tùy chọn |
| Ghi chú cá nhân | Tạo riêng bởi người đang học | Tạo riêng bởi người đang học |

Chấp nhận từ chỉ có Kana; không bắt người dùng nhập Kanji cho mọi từ. Trường cách đọc hỗ trợ Kana, thường là Hiragana cho từ chứa Kanji; từ mượn viết Katakana không bị chuyển đổi máy móc. Không dùng Romaji thay cho dòng Hiragana theo mặc định.

Đề xuất giới hạn ban đầu: tên bộ 100 ký tự; từ hoặc câu hỏi 500 ký tự; cách đọc 500 ký tự; nghĩa, ví dụ hoặc ghi chú nội dung 2.000 ký tự mỗi trường; ghi chú cá nhân 5.000 ký tự. Ảnh JPEG, PNG hoặc WebP tối đa 5 MB mỗi tệp. Đây là cấu hình sản phẩm có thể thay đổi, phải được kiểm tra ở cả giao diện và backend.

## 3 Tác nhân và quyền truy cập

### 3.1 Tác nhân

| Mã | Tác nhân | Mục tiêu và trách nhiệm |
|---|---|---|
| ACT01 | Khách | Khám phá nội dung, xem trước, học thử và tạo tài khoản |
| ACT02 | Người học | Quản lý tài khoản, thư viện, nội dung riêng, phiên học, tiến độ và ghi chú |
| ACT03 | Quản trị viên | Quản lý nội dung chính thức, phân quyền, tài khoản và hoạt động vận hành |
| EXT01 | Dịch vụ email | Tác nhân hỗ trợ bên ngoài, nhận yêu cầu gửi email và trả trạng thái xử lý |

Admin dùng cùng cơ chế xác thực tài khoản nhưng cần quyền quản trị riêng. Một tài khoản admin có thể đồng thời sử dụng chức năng người học; quyền học chỉ áp dụng với dữ liệu cá nhân của chính tài khoản đó. Không bổ sung vai trò giáo viên, biên tập viên hoặc quản trị cấp cao trong MVP.

Backend, cơ sở dữ liệu, kho ảnh và bộ tính lịch ôn là các thành phần bên trong ranh giới sản phẩm, không được coi là các tác nhân người dùng độc lập. Các tiến trình tự động liên quan được mô tả trong mục 9.

### 3.2 Ma trận quyền

| Hành động | Khách | Người học | Admin |
|---|---|---|---|
| Xem bộ chính thức đã xuất bản | Có | Có | Có |
| Học thử giới hạn | Có | Có | Có |
| Lưu thư viện và tiến độ | Không | Dữ liệu của mình | Dữ liệu học của mình |
| Tạo và sửa bộ cá nhân | Không | Bộ của mình | Bộ cá nhân của mình |
| Đọc bộ cá nhân của người khác | Không | Không | Không |
| Đọc hoặc sửa ghi chú cá nhân | Không | Ghi chú của mình | Ghi chú học của mình |
| Tạo và sửa bộ chính thức | Không | Không | Có |
| Xuất bản hoặc lưu trữ bộ chính thức | Không | Không | Có |
| Quản lý chủ đề và cấp độ | Không | Không | Có |
| Gửi báo lỗi nội dung | Không | Có | Có dưới tư cách người học |
| Xử lý báo lỗi nội dung chính thức | Không | Không | Có |
| Xem thông tin tài khoản phục vụ quản lý | Không | Hồ sơ của mình | Giới hạn theo mục đích quản lý |
| Khóa tài khoản hoặc thay đổi vai trò | Không | Không | Có, có kiểm soát |
| Xem mật khẩu, token hoặc bí mật xác thực | Không | Không | Không |
| Reset tiến độ học | Không | Tiến độ của mình | Tiến độ học của mình |
| Xem nhật ký quản trị | Không | Không | Có |

Kiểm tra quyền phải thực hiện tại backend cho từng đối tượng; việc ẩn nút trên giao diện không thay thế kiểm tra quyền. Admin không có quyền xem ghi chú và bộ thẻ riêng chỉ vì có thể quản lý tài khoản.

## 4 Danh mục use case

Tài liệu có **39 use case tương tác** và **3 tiến trình hỗ trợ**. Trong đó, **38 use case thuộc phạm vi P0 hoặc P1** và **AC02 được hoãn sang P2**. Mỗi use case bên dưới ghi rõ điều kiện, luồng, ngoại lệ, kết quả và tiêu chí nghiệm thu.

| Nhóm | Mã | Số lượng | Mục tiêu |
|---|---|---|---|
| Khách | G01 đến G03 | 3 | Khám phá, xem chi tiết, học thử |
| Tài khoản | AC01 đến AC07, AC09 | 8 | Đăng ký, đăng nhập, quản lý danh tính và xóa tài khoản; AC02 hoãn sang P2 |
| Người học | ST01 đến ST16 | 16 | Thư viện, học, ôn, tạo nội dung và theo dõi tiến độ |
| Quản trị | AD01 đến AD12 | 12 | Nội dung, báo lỗi, người dùng, quyền và vận hành |
| Hỗ trợ hệ thống | SYS01 đến SYS03 | 3 | Email, đồng bộ và tính lịch ôn |

Các use case học và quản trị yêu cầu AC03 thành công, không yêu cầu AC02. Các thao tác ảnh dùng chung chính sách kiểm tra tệp trong BR08. ST05 sử dụng SYS02 và SYS03; khôi phục mật khẩu dùng SYS01.

## 5 Use case của khách

### G01 Khám phá bộ thẻ

- **Tác nhân và kênh:** Khách; app và web; P0.
- **Điều kiện và kích hoạt:** Người dùng mở mục Khám phá, không cần đăng nhập.
- **Luồng chính:** Hệ thống liệt kê bộ chính thức đã xuất bản. Khách tìm theo tên, lọc cấp độ hoặc chủ đề, thay đổi thứ tự và mở một kết quả. Danh sách hỗ trợ tải tiếp khi có nhiều bộ.
- **Ngoại lệ:** Không có kết quả thì hiển thị trạng thái rỗng và cho xóa bộ lọc. Lỗi mạng thì giữ bộ lọc và cho thử lại. Bộ chưa xuất bản không xuất hiện dù truy cập bằng đường dẫn trực tiếp.
- **Kết quả:** Khách chọn được bộ để xem; không sinh tiến độ hoặc quan hệ thư viện.
- **Nghiệm thu:** Khách không thể đọc bộ riêng, bộ nháp hoặc bộ lưu trữ thông qua tìm kiếm, URL hay yêu cầu dữ liệu trực tiếp.

### G02 Xem chi tiết và xem trước bộ thẻ

- **Tác nhân và kênh:** Khách hoặc người học; app và web; P0.
- **Điều kiện và kích hoạt:** Bộ chính thức đang được xuất bản; người dùng mở trang chi tiết.
- **Luồng chính:** Hiển thị tên, mô tả, ảnh bìa, cấp độ, chủ đề, tác giả và số thẻ đang hoạt động. Cho xem trước số thẻ theo cấu hình, đề xuất 5 thẻ. Người dùng chọn Học thử hoặc Thêm vào thư viện.
- **Ngoại lệ:** Khách chọn thêm bộ thì được chuyển đến đăng nhập và giữ đích quay lại. Bộ bị lưu trữ trong lúc xem thì tải lại trạng thái và thông báo phù hợp.
- **Kết quả:** Người dùng hiểu nội dung bộ và có thể tiếp tục G03 hoặc ST01.
- **Nghiệm thu:** Số thẻ không tính thẻ bị lưu trữ; bộ không khả dụng hiển thị thông báo thay vì trang lỗi trắng.

### G03 Học thử không đăng nhập

- **Tác nhân và kênh:** Khách; app và web; P0.
- **Điều kiện và kích hoạt:** Có bộ công khai với thẻ hoạt động; khách chọn Học thử.
- **Luồng chính:** Tạo phiên tạm với tối đa 5 thẻ. Khách xem Kanji, hiện hoặc ẩn cách đọc, lật đáp án và chuyển thẻ. Cuối lượt, hệ thống giới thiệu đăng ký để lưu thư viện và tiến độ.
- **Ngoại lệ:** Tải lại trang có thể bắt đầu lại phiên tạm. Nếu đăng nhập giữa lượt, kết thúc chế độ thử và cho thêm bộ vào thư viện. Không tự chuyển các câu trả lời thử thành tiến độ chính thức.
- **Kết quả:** Khách trải nghiệm được cách học mà chưa có tài khoản.
- **Nghiệm thu:** Không ghi lịch ôn, streak hoặc thống kê người học cho phiên thử; giới hạn được kiểm tra ở backend khi cấp dữ liệu xem trước.

## 6 Use case tài khoản

### AC01 Đăng ký tài khoản

- **Tác nhân và kênh:** Khách; app và web; P0.
- **Điều kiện và kích hoạt:** Chưa đăng nhập; chọn Đăng ký.
- **Luồng chính:** Nhập tên, email, mật khẩu và xác nhận mật khẩu; xem điều khoản và chính sách dữ liệu. Hệ thống kiểm tra dữ liệu, tạo tài khoản ở trạng thái Hoạt động và chuyển đến Đăng nhập, giữ đích quay lại nếu có. Không gửi email xác minh và không mở màn hình chờ xác nhận.
- **Ngoại lệ:** Dữ liệu không hợp lệ được báo tại trường tương ứng. Yêu cầu lặp không tạo thêm tài khoản. Phản hồi email đã tồn tại không được tiết lộ quá mức thông tin tài khoản. Sự cố dịch vụ gửi email không chặn việc đăng ký.
- **Kết quả:** Có tài khoản hoạt động với quyền người học, có thể đăng nhập ngay mà không xác minh email.
- **Nghiệm thu:** Đăng ký xong có thể thực hiện AC03 và học ngay; không gọi SYS01 để xác minh đăng ký. Không thể tự truyền vai trò admin khi đăng ký; mật khẩu không xuất hiện trong log, hồ sơ hoặc email.

### AC02 Xác minh email và gửi lại liên kết trong giai đoạn mở rộng

- **Tác nhân và kênh:** Người có tài khoản; app, web và EXT01; P2, tạm hoãn.
- **Điều kiện và kích hoạt:** Chỉ triển khai khi có yêu cầu bật xác minh email ở giai đoạn sau. Không được kích hoạt từ AC01 hoặc dùng để chặn AC03 trong phạm vi hiện tại.
- **Luồng chính dự kiến:** Người dùng yêu cầu gửi thư và mở liên kết. Hệ thống kiểm tra chữ ký, mục đích và thời hạn; đánh dấu email đã xác minh. Có thể yêu cầu gửi lại theo giới hạn.
- **Ngoại lệ:** Liên kết hết hạn hoặc đã dùng hiển thị trạng thái tương ứng. Gửi lại quá nhanh bị giới hạn. Nếu triển khai sau này, phải chốt riêng chính sách cho tài khoản đã tồn tại trước khi bật tính năng.
- **Kết quả:** Khi được triển khai, email có trạng thái xác minh mà không tạo tài khoản hoặc thay đổi vai trò. Hiện tại tài khoản vẫn sử dụng bình thường khi chưa xác minh.
- **Nghiệm thu:** Trong phạm vi hiện tại không hiển thị màn hình chờ xác minh, không tự gửi thư xác minh và không chặn đăng nhập vì chưa xác minh email.

### AC03 Đăng nhập

- **Tác nhân và kênh:** Người có tài khoản hoặc admin; app, web người học và web admin; P0.
- **Điều kiện và kích hoạt:** Chọn Đăng nhập; tài khoản đã được tạo.
- **Luồng chính:** Nhập email và mật khẩu. Hệ thống kiểm tra thông tin và trạng thái tài khoản, tạo phiên rồi tải hồ sơ cùng quyền. Không yêu cầu trạng thái email đã xác minh. Người dùng được đưa về trang trước đó nếu có quyền truy cập, nếu không về trang chủ phù hợp.
- **Ngoại lệ:** Sai thông tin dùng thông báo chung. Tài khoản bị khóa không tạo phiên mới. Đăng nhập quá nhiều lần bị giới hạn. Người học đăng nhập web admin không được nhận dữ liệu quản trị. Không chuyển sang AC02 vì email chưa xác minh.
- **Kết quả:** Phiên xác thực hợp lệ có phạm vi quyền đúng.
- **Nghiệm thu:** Tài khoản vừa đăng ký có thể đăng nhập mà không mở email. Quyền lấy từ dữ liệu được tin cậy ở backend; không dựa vào vai trò do client tự gửi.

### AC04 Quên và đặt lại mật khẩu

- **Tác nhân và kênh:** Người có tài khoản; app, web và EXT01; P0.
- **Điều kiện và kích hoạt:** Chọn Quên mật khẩu.
- **Luồng chính:** Nhập email, nhận phản hồi chung, mở liên kết nếu đủ điều kiện, nhập và xác nhận mật khẩu mới. Hệ thống kiểm tra liên kết, cập nhật mật khẩu, thu hồi các phiên cũ theo chính sách và yêu cầu đăng nhập lại.
- **Ngoại lệ:** Email không tồn tại vẫn nhận phản hồi không làm lộ danh tính. Liên kết hết hạn hoặc đã dùng thì cho gửi lại. Mật khẩu không đạt chính sách thì giữ ở bước nhập mới.
- **Kết quả:** Mật khẩu mới có hiệu lực; liên kết cũ không dùng lại được.
- **Nghiệm thu:** Có thể mở email trên thiết bị khác để đặt lại; các phiên đã bị thu hồi không tiếp tục ghi dữ liệu bằng token cũ.

### AC05 Đăng xuất và quản lý phiên

- **Tác nhân và kênh:** Người học hoặc admin; mọi kênh; đăng xuất hiện tại P0, quản lý phiên khác P1.
- **Điều kiện và kích hoạt:** Có phiên đăng nhập; chọn Đăng xuất hoặc mục Phiên đăng nhập.
- **Luồng chính:** Hệ thống cho biết nếu còn thay đổi chưa được xác nhận. Khi người dùng tiếp tục, kết thúc phiên hiện tại, xóa token và dữ liệu riêng trên thiết bị. Với P1, người dùng có thể xem danh sách phiên và thu hồi một phiên hoặc tất cả phiên khác.
- **Ngoại lệ:** Mất mạng thì xóa phiên cục bộ ngay và thông báo chưa xác nhận thu hồi phía máy chủ; không khẳng định đã đăng xuất toàn bộ thiết bị. Các thay đổi chưa lưu không được báo là đã lưu.
- **Kết quả:** Không còn xem dữ liệu riêng qua phiên đã đăng xuất trên thiết bị hiện tại.
- **Nghiệm thu:** Đăng nhập tài khoản B sau tài khoản A không hiển thị thư viện, ghi chú hoặc cache riêng của A.

### AC06 Quản lý hồ sơ và thiết lập chung

- **Tác nhân và kênh:** Người học hoặc admin dưới tư cách cá nhân; app và web; P0.
- **Điều kiện và kích hoạt:** Đã đăng nhập; mở Hồ sơ hoặc Cài đặt.
- **Luồng chính:** Xem và sửa tên, ảnh đại diện, múi giờ và ngôn ngữ giao diện được hỗ trợ. Lưu thay đổi rồi tải lại hồ sơ đã xác nhận. Ảnh đi qua quy trình kiểm tra tệp.
- **Ngoại lệ:** Tên hoặc múi giờ không hợp lệ không được lưu. Upload lỗi thì giữ ảnh trước đó. Nếu hồ sơ thay đổi ở thiết bị khác, báo có bản mới trước khi ghi đè dữ liệu xung đột.
- **Kết quả:** Hồ sơ và thiết lập được đồng bộ; thay đổi múi giờ không làm dịch chuyển thời điểm ôn tuyệt đối đã lưu.
- **Nghiệm thu:** Người dùng không thể sửa vai trò hoặc trạng thái tài khoản qua chức năng sửa hồ sơ.

### AC07 Đổi mật khẩu khi đang đăng nhập

- **Tác nhân và kênh:** Người học hoặc admin; app và web; P0.
- **Điều kiện và kích hoạt:** Có phiên hợp lệ; chọn Đổi mật khẩu.
- **Luồng chính:** Xác thực lại bằng cơ chế danh tính phù hợp, nhập và xác nhận mật khẩu mới. Hệ thống kiểm tra chính sách, cập nhật, thu hồi các phiên cũ và yêu cầu đăng nhập lại.
- **Ngoại lệ:** Xác thực lại thất bại không đổi mật khẩu. Hai trường mật khẩu không khớp thì báo lỗi tại chỗ. Lỗi mạng không được coi là đổi thành công cho đến khi trạng thái đã được xác nhận.
- **Kết quả:** Mật khẩu mới hoạt động; các phiên bị thu hồi mất quyền truy cập.
- **Nghiệm thu:** Không thể đổi mật khẩu chỉ với định danh người dùng do client tự cung cấp; không ghi mật khẩu vào audit.

### AC09 Yêu cầu xóa tài khoản

- **Tác nhân và kênh:** Chủ tài khoản; app và web; P0.
- **Điều kiện và kích hoạt:** Đang đăng nhập và xác thực lại thành công; chọn Xóa tài khoản.
- **Luồng chính:** Hiển thị dữ liệu sẽ bị xóa và tính không thể hoàn tác sau khi xử lý. Người dùng xác nhận rõ ràng. Hệ thống ghi nhận yêu cầu, chặn ghi mới, thu hồi phiên và xóa dữ liệu riêng cùng tệp không còn tham chiếu. Tiến trình có trạng thái để theo dõi và chạy lại an toàn khi lỗi.
- **Ngoại lệ:** Admin cuối cùng phải chuyển quyền trước. Nội dung chính thức do admin từng tạo được chuyển quyền sở hữu vận hành, không xóa theo tài khoản cá nhân. Lỗi một bước không được báo hoàn tất toàn bộ.
- **Kết quả:** Tài khoản không còn sử dụng; dữ liệu riêng được xóa theo chính sách lưu giữ công bố.
- **Nghiệm thu:** Xóa cả ghi chú, tiến độ, bộ riêng và ảnh riêng không còn dùng; nhật ký bắt buộc giữ lại được tối thiểu hóa danh tính theo chính sách.

## 7 Use case của người học

### ST01 Thêm bộ chính thức vào thư viện

- **Tác nhân và kênh:** Người học; app và web; P0.
- **Điều kiện và kích hoạt:** Đã đăng nhập, bộ đang xuất bản; chọn Thêm vào thư viện.
- **Luồng chính:** Kiểm tra quyền xem bộ và quan hệ thư viện. Hệ thống tạo hoặc kích hoạt lại quan hệ theo học, thông báo kết quả và cho bắt đầu học.
- **Ngoại lệ:** Thêm bộ đã có trong thư viện thì trả về quan hệ hiện tại, không nhân bản. Nếu từng gỡ bộ, phục hồi tiến độ cũ. Bộ vừa bị lưu trữ không cho người chưa theo học thêm mới.
- **Kết quả:** Bộ xuất hiện trong thư viện; chưa có tiến độ cho thẻ chưa học.
- **Nghiệm thu:** Nhấn nhanh nhiều lần hoặc thêm đồng thời từ hai thiết bị chỉ tạo một quan hệ thư viện đang hoạt động.

### ST02 Xem tìm kiếm và lọc thư viện

- **Tác nhân và kênh:** Người học; app và web; P0.
- **Điều kiện và kích hoạt:** Đã đăng nhập; mở Thư viện.
- **Luồng chính:** Xem bộ đang theo học và bộ tự tạo, số thẻ mới, số thẻ đến hạn và lần học gần nhất. Tìm theo tên, lọc theo cấp độ, chủ đề hoặc loại bộ; mở chi tiết để học hay quản lý.
- **Ngoại lệ:** Thư viện trống có nút Khám phá và Tạo bộ. Lỗi thống kê không được làm mất bộ đã lưu. Bộ chính thức lưu trữ được gắn nhãn, giữ quyền học cho người đã theo học nếu không bị gỡ vì nội dung không hợp lệ.
- **Kết quả:** Người học biết cần học bộ nào và trạng thái đồng bộ của số liệu.
- **Nghiệm thu:** Không trả về bộ cá nhân hoặc số liệu học của người dùng khác.

### ST03 Gỡ bộ khỏi thư viện

- **Tác nhân và kênh:** Người học; app và web; P0.
- **Điều kiện và kích hoạt:** Đang theo học một bộ chính thức; chọn Gỡ khỏi thư viện.
- **Luồng chính:** Thông báo bộ sẽ ngừng tham gia danh sách ôn nhưng tiến độ, ghi chú và yêu thích còn giữ. Người dùng xác nhận; hệ thống ngừng quan hệ theo học và xử lý phiên liên quan đang mở.
- **Ngoại lệ:** Không dùng thao tác này để xóa bộ tự tạo; chuyển ST13. Nếu muốn xóa tiến độ, hướng dẫn ST16 riêng. Thao tác lặp vẫn trả trạng thái đã gỡ.
- **Kết quả:** Bộ không xuất hiện trong danh sách đang theo học và thẻ của bộ không được tính đến hạn.
- **Nghiệm thu:** Thêm lại bộ qua ST01 khôi phục tiến độ và ghi chú; gỡ bộ không tác động tới người học khác.

### ST04 Bắt đầu học thẻ mới

- **Tác nhân và kênh:** Người học; app và web; P0.
- **Điều kiện và kích hoạt:** Có bộ theo học hoặc bộ riêng còn hoạt động; chọn Học mới.
- **Luồng chính:** Chọn số thẻ, thứ tự và chế độ; hệ thống lấy các thẻ chưa có đánh giá, tạo phiên có định danh và tải thẻ đầu. Phiên ghi nhận thiết lập hiển thị để áp dụng nhất quán.
- **Ngoại lệ:** Không còn thẻ mới thì gợi ý ôn đến hạn hoặc luyện tự do. Bộ không có thẻ hoạt động thì không mở phiên rỗng. Nếu có phiên chưa xong, cho tiếp tục hoặc kết thúc phiên cũ trước khi tạo phiên mới.
- **Kết quả:** Có phiên học chính thức sẵn sàng thực hiện ST05.
- **Nghiệm thu:** Bắt đầu phiên chưa làm tăng số thẻ đã học; chỉ lượt đánh giá được xác nhận mới làm thay đổi tiến độ.

### ST05 Xem lật thẻ và đánh giá mức nhớ

- **Tác nhân và kênh:** Người học; app và web; P0.
- **Điều kiện và kích hoạt:** Có phiên đang học và thẻ chưa được đánh giá tại bước hiện tại.
- **Luồng chính:** Hiện mặt trước theo chế độ, cho bật gợi ý cách đọc rồi lật đáp án. Sau khi xem đáp án, chọn Chưa nhớ, Khó, Nhớ hoặc Dễ. Hệ thống gửi lượt đánh giá qua SYS02, tính lịch qua SYS03, xác nhận kết quả và chuyển thẻ.
- **Ngoại lệ:** Chưa mở đáp án thì không được đánh giá. Nhấn lặp không ghi nhiều lượt. Mất kết nối hoặc phản hồi không rõ trạng thái thì giữ mã sự kiện để truy vấn hoặc gửi lại an toàn; không âm thầm bỏ thẻ.
- **Kết quả:** Có một lượt đánh giá được chấp nhận, tiến độ và lịch ôn được cập nhật đồng bộ.
- **Nghiệm thu:** Một sự kiện chỉ cập nhật tiến độ một lần; tải lại sau lỗi không tạo lượt học trùng hoặc bỏ qua câu chưa lưu.

### ST06 Ôn các thẻ đến hạn

- **Tác nhân và kênh:** Người học; app và web; P0.
- **Điều kiện và kích hoạt:** Đã đăng nhập; chọn Ôn hôm nay hoặc ôn trong một bộ.
- **Luồng chính:** Hệ thống lấy thẻ đến hạn trong các bộ đang theo học, ưu tiên thời điểm đến hạn sớm và áp dụng giới hạn phiên. Người dùng học theo ST05. Cuối phiên, hiển thị số thẻ đã ôn và số thẻ còn đến hạn.
- **Ngoại lệ:** Không có thẻ đến hạn thì hiện thời điểm dự kiến gần nhất hoặc gợi ý học mới. Thẻ đã được đánh giá ở thiết bị khác được cập nhật hoặc bỏ khỏi danh sách trước khi tiếp tục. Thẻ tạm gỡ vì nội dung lỗi không được phát lại.
- **Kết quả:** Các thẻ được đánh giá có lịch ôn mới; thẻ còn lại giữ nguyên lịch.
- **Nghiệm thu:** Không lấy thẻ từ bộ đã gỡ; thời điểm đến hạn dựa trên thời gian máy chủ, không dựa riêng vào đồng hồ thiết bị.

### ST07 Tạm dừng và tiếp tục phiên học

- **Tác nhân và kênh:** Người học; app và web; P0.
- **Điều kiện và kích hoạt:** Có phiên chưa kết thúc; rời màn hình hoặc chọn Tiếp tục học.
- **Luồng chính:** Lưu vị trí đã xác nhận và danh sách thẻ còn lại. Khi mở lại, khôi phục phiên từ trạng thái máy chủ. Nếu tiếp tục trên thiết bị khác, hệ thống chuyển quyền ghi của phiên và cập nhật thiết bị cũ.
- **Ngoại lệ:** Phiên đã hoàn tất thì mở trang kết quả. Thẻ bị gỡ vì nội dung không hợp lệ thì bỏ qua có thông báo. Thay đổi chưa được xác nhận phải được xử lý trước khi đóng hoặc chuyển thiết bị, không được giả định đã lưu.
- **Kết quả:** Tiếp tục từ thẻ chưa hoàn thành gần nhất theo trạng thái đã xác nhận.
- **Nghiệm thu:** Không trả lời lại thẻ đã lưu chỉ vì đóng app; thiết bị cũ không ghi đè phiên đã chuyển sang thiết bị mới.

### ST08 Quản lý ghi chú cá nhân

- **Tác nhân và kênh:** Người học; app và web; P0.
- **Điều kiện và kích hoạt:** Có quyền học thẻ; mở mục Ghi chú của tôi.
- **Luồng chính:** Thêm hoặc sửa ghi chú, lưu rồi nhận xác nhận. Có thể xóa ghi chú sau khi xác nhận. Khi mở lại cùng thẻ trên thiết bị khác, nội dung cá nhân được tải riêng với nội dung gốc.
- **Ngoại lệ:** Quá giới hạn độ dài thì giữ bản đang nhập và báo lỗi. Hai thiết bị sửa cùng lúc thì trả xung đột và cho chọn giữ bản mới nhất hoặc lưu nội dung đã hợp nhất; không ghi đè âm thầm.
- **Kết quả:** Ghi chú gắn với người dùng và thẻ; không thay đổi nội dung do tác giả cung cấp.
- **Nghiệm thu:** Admin, tác giả bộ và người học khác không đọc được ghi chú bằng URL, API hoặc chức năng báo cáo.

### ST09 Đánh dấu và học thẻ yêu thích

- **Tác nhân và kênh:** Người học; app và web; P1.
- **Điều kiện và kích hoạt:** Có quyền xem thẻ; chọn biểu tượng yêu thích.
- **Luồng chính:** Bật hoặc tắt đánh dấu. Mục Yêu thích tổng hợp thẻ còn quyền truy cập và cho mở thẻ hoặc luyện tự do. Trạng thái đồng bộ giữa thiết bị.
- **Ngoại lệ:** Thẻ không còn khả dụng được ghi rõ hoặc ẩn khỏi phiên luyện, không làm cả danh sách lỗi. Thao tác lặp cùng trạng thái không sinh bản ghi trùng.
- **Kết quả:** Có danh sách cá nhân để xem lại, độc lập với lịch ôn.
- **Nghiệm thu:** Đánh dấu yêu thích không tự thay đổi mức nhớ; luyện tự do không cập nhật lịch ôn trừ khi người dùng chủ động vào luồng ôn chính thức.

### ST10 Thiết lập chế độ học và cách đọc

- **Tác nhân và kênh:** Người học; app và web; P0.
- **Điều kiện và kích hoạt:** Mở Cài đặt học hoặc cấu hình trước phiên.
- **Luồng chính:** Chọn hiện Hiragana mặc định, ẩn để tự nhớ hoặc hiện khi chạm; chọn mặt trước là từ tiếng Nhật, nghĩa tiếng Việt hoặc ảnh. Chọn số thẻ mới mỗi phiên và thứ tự. Lưu làm mặc định hoặc chỉ áp dụng cho phiên kế tiếp.
- **Ngoại lệ:** Chế độ ảnh chỉ lấy thẻ có ảnh mặt trước phù hợp. Thẻ không có cách đọc không hiện dòng rỗng. Thiết lập không hợp lệ được thay bằng giá trị hợp lệ có thông báo.
- **Kết quả:** Phiên học áp dụng đúng lựa chọn; thiết lập chung được đồng bộ.
- **Nghiệm thu:** Khi ẩn Hiragana, cách đọc không xuất hiện ngoài ý muốn trong phần gợi ý trên mặt trước. Đổi chế độ không làm mất tiến độ thẻ.

### ST11 Tạo và sửa bộ thẻ cá nhân

- **Tác nhân và kênh:** Người học; app và web; P0.
- **Điều kiện và kích hoạt:** Đã đăng nhập; chọn Tạo bộ hoặc sửa bộ do mình sở hữu.
- **Luồng chính:** Nhập tên, mô tả, cấp độ, chủ đề và ảnh bìa nếu có. Lưu bộ riêng, tự thêm vào thư viện của chủ sở hữu rồi chuyển đến quản lý thẻ. Có thể sửa thông tin bất kỳ lúc nào khi bộ còn hoạt động.
- **Ngoại lệ:** Bộ chưa có thẻ vẫn được lưu nhưng chưa thể bắt đầu học. Tên trống hoặc ảnh không hợp lệ không được chấp nhận. Truy cập bộ người khác trả lỗi quyền phù hợp.
- **Kết quả:** Có bộ cá nhân riêng tư với định danh ổn định.
- **Nghiệm thu:** Không tự xuất hiện ở Khám phá; sửa tên hoặc ảnh bìa không reset tiến độ của các thẻ.

### ST12 Tạo và sửa thẻ cá nhân

- **Tác nhân và kênh:** Chủ bộ cá nhân; app và web; P0.
- **Điều kiện và kích hoạt:** Bộ riêng đang hoạt động; chọn Thêm thẻ hoặc sửa thẻ thuộc bộ.
- **Luồng chính:** Chọn loại từ vựng hoặc thẻ chữ và ảnh. Nhập các trường tương ứng, upload ảnh, xem trước hai mặt với chế độ hiện hoặc ẩn Hiragana rồi lưu. Backend kiểm tra nội dung và quyền sở hữu, tạo phiên bản mới khi sửa.
- **Ngoại lệ:** Từ chứa Kanji thiếu cách đọc thì không lưu ở loại từ vựng. Lưu trùng nội dung có thể cảnh báo nhưng không tự gộp thẻ. Xung đột phiên bản được trả về để người dùng chọn cách hợp nhất.
- **Kết quả:** Thẻ mới có thể học hoặc thẻ cũ được cập nhật mà giữ định danh.
- **Nghiệm thu:** Sửa Kanji, nghĩa hoặc ảnh không tự reset tiến độ; không được sửa thẻ chính thức bằng quyền người học.

### ST13 Xóa hoặc lưu trữ nội dung cá nhân

- **Tác nhân và kênh:** Chủ bộ cá nhân; app và web; P0.
- **Điều kiện và kích hoạt:** Chọn xóa thẻ hoặc lưu trữ bộ do mình sở hữu.
- **Luồng chính:** Hiển thị ảnh hưởng tới phiên học và dữ liệu liên quan. Thẻ chưa từng có lượt học có thể xóa vĩnh viễn sau xác nhận. Thẻ đã có lượt học được lưu trữ. Bộ được lưu trữ, ngừng xuất hiện trong thư viện đang học và có thể khôi phục từ mục Đã lưu trữ.
- **Ngoại lệ:** Phiên đang mở phải cập nhật hoặc bỏ qua nội dung không còn hoạt động. Xóa tệp ảnh chỉ thực hiện khi không còn tham chiếu. Không có thao tác xóa vĩnh viễn hàng loạt bộ đã học trong MVP.
- **Kết quả:** Nội dung không còn được phát vào phiên mới; tiến độ nội dung lưu trữ vẫn còn để khôi phục.
- **Nghiệm thu:** Khôi phục bộ không tự khôi phục những thẻ đã được lưu trữ riêng trước đó; không xóa ảnh đang dùng ở thẻ khác.

### ST14 Xem tiến độ và kết quả học

- **Tác nhân và kênh:** Người học; app và web; P0.
- **Điều kiện và kích hoạt:** Mở Trang chủ, Thống kê hoặc kết quả phiên.
- **Luồng chính:** Xem số thẻ mới đã học, số lượt ôn, số thẻ đến hạn, chuỗi ngày học và kết quả theo bộ. Cuối phiên hiển thị số thẻ duy nhất đã hoàn thành, phân bố mức đánh giá và thẻ còn lại.
- **Ngoại lệ:** Chưa có dữ liệu thì hiển thị trạng thái bắt đầu học. Dữ liệu đang đồng bộ được gắn trạng thái. Đổi múi giờ ảnh hưởng nhóm ngày hiển thị, không tạo thêm lượt học hoặc phần thưởng.
- **Kết quả:** Người học hiểu tiến độ dựa trên các lượt đã được chấp nhận.
- **Nghiệm thu:** Phân biệt số lượt đánh giá và số thẻ duy nhất; không gọi tỷ lệ tự chọn Nhớ hoặc Dễ là độ chính xác kiểm tra khách quan.

### ST15 Báo lỗi nội dung chính thức

- **Tác nhân và kênh:** Người học; app và web; P1.
- **Điều kiện và kích hoạt:** Đang xem thẻ chính thức; chọn Báo lỗi.
- **Luồng chính:** Chọn loại lỗi như cách đọc, nghĩa, ảnh hoặc ví dụ; nhập mô tả và gửi. Hệ thống lưu định danh cùng phiên bản thẻ, cấp mã theo dõi. Người gửi xem trạng thái và kết quả xử lý trong mục phản hồi.
- **Ngoại lệ:** Báo trùng đang mở được liên kết hoặc cảnh báo. Nội dung quá ngắn, quá dài hoặc spam bị từ chối. Thẻ cá nhân hiển thị gợi ý sửa trực tiếp thay vì gửi admin.
- **Kết quả:** Có báo lỗi trạng thái Mới để admin xử lý qua AD08.
- **Nghiệm thu:** Không gửi kèm ghi chú cá nhân tự động; người gửi chỉ xem được báo lỗi của mình, không xem báo cáo của người khác.

### ST16 Đặt lại tiến độ học

- **Tác nhân và kênh:** Người học; app và web; P0.
- **Điều kiện và kích hoạt:** Có quyền với bộ và tiến độ của mình; chọn Học lại từ đầu.
- **Luồng chính:** Hiển thị số thẻ chịu tác động và giải thích lịch ôn sẽ được đặt lại. Người dùng xác nhận rõ ràng. Hệ thống kết thúc phiên liên quan, đặt các thẻ về trạng thái mới và tạo mốc chu kỳ học mới.
- **Ngoại lệ:** Lượt học từ phiên cũ đến muộn bị từ chối theo phiên bản chu kỳ. Lỗi giữa chừng phải được xử lý theo giao dịch hoặc tác vụ có thể chạy lại, không để nửa bộ bị reset mà báo thành công.
- **Kết quả:** Lịch và tiến độ hiện tại của bộ được đặt lại; ghi chú và yêu thích giữ nguyên. Lịch sử sự kiện được giữ để thống kê lịch sử.
- **Nghiệm thu:** Chỉ reset dữ liệu của người yêu cầu; thống kê tiến độ hiện tại không cộng dữ liệu chu kỳ cũ, thống kê lịch sử ghi rõ phạm vi.

## 8 Use case của quản trị viên

### AD01 Truy cập web admin và tổng quan

- **Tác nhân và kênh:** Admin; web admin; P0.
- **Điều kiện và kích hoạt:** AC03 thành công; mở khu vực quản trị.
- **Luồng chính:** Backend kiểm tra vai trò và trạng thái tài khoản. Giao diện hiển thị tổng quan số bộ nháp, bộ xuất bản, thẻ và báo lỗi đang chờ. Admin mở từng khu vực theo quyền.
- **Ngoại lệ:** Tài khoản thường bị từ chối. Vai trò bị thu hồi trong khi đang mở thì lần truy cập dữ liệu tiếp theo bị chặn và giao diện thoát vùng quản trị. Lỗi một chỉ số không làm mất điều hướng.
- **Kết quả:** Admin truy cập được chức năng vận hành với phiên được kiểm soát.
- **Nghiệm thu:** Không trả dữ liệu quản trị trước rồi mới kiểm tra quyền ở giao diện; đường dẫn trực tiếp cũng được bảo vệ.

### AD02 Tạo và chỉnh sửa bộ chính thức

- **Tác nhân và kênh:** Admin; web admin; P0.
- **Điều kiện và kích hoạt:** Có quyền quản trị; chọn Tạo bộ hoặc chỉnh sửa.
- **Luồng chính:** Nhập tên, mô tả, cấp độ, chủ đề và ảnh bìa; lưu nháp. Với bộ đã xuất bản, chỉnh sửa thông tin tạo phiên bản nội dung mới mà giữ định danh. Admin có thể xem trước cách hiển thị cho người học.
- **Ngoại lệ:** Dữ liệu thiếu không được lưu hoặc xuất bản theo quy tắc tương ứng. Hai admin sửa đồng thời phải xử lý xung đột phiên bản. Không cho thay bộ chính thức thành bộ riêng để né quyền kiểm soát.
- **Kết quả:** Có bộ nháp hoặc phiên bản thông tin mới, có dấu vết người sửa.
- **Nghiệm thu:** Lưu nháp không làm bộ mới xuất hiện công khai; sửa metadata không làm mất quan hệ thư viện hoặc tiến độ.

### AD03 Quản lý thẻ chính thức

- **Tác nhân và kênh:** Admin; web admin; P0.
- **Điều kiện và kích hoạt:** Bộ tồn tại và admin có quyền; mở quản lý thẻ.
- **Luồng chính:** Thêm, sửa, sắp xếp và xem trước thẻ. Kiểm tra Kanji, cách đọc, nghĩa, ảnh và ví dụ; lưu nội dung có phiên bản. Thẻ mới trong bộ đã xuất bản được lưu nháp, chỉ công khai sau thao tác duyệt xuất bản rõ ràng.
- **Ngoại lệ:** Thiếu trường bắt buộc thì không xuất bản. Thẻ đã có lượt học chỉ được lưu trữ, không xóa cứng. Nếu thay đổi làm thẻ thành một kiến thức khác, tạo thẻ mới rồi lưu trữ thẻ cũ thay vì tái sử dụng định danh.
- **Kết quả:** Nội dung chính thức được cập nhật có kiểm soát.
- **Nghiệm thu:** Sửa lỗi đọc hoặc nghĩa giữ nguyên tiến độ và ghi chú; nội dung nháp của thẻ mới không bị rò ra bộ công khai.

### AD04 Quản lý ảnh chính thức

- **Tác nhân và kênh:** Admin; web admin; P0.
- **Điều kiện và kích hoạt:** Đang chỉnh nội dung hoặc mở danh sách tệp; chọn Upload, Thay ảnh hoặc Gỡ ảnh.
- **Luồng chính:** Kiểm tra loại và kích thước tệp thực tế, lưu ảnh, liên kết vào thẻ hoặc bộ. Khi thay ảnh, giữ ảnh cũ đến khi thay đổi nội dung thành công. Khi xóa, kiểm tra tham chiếu còn tồn tại.
- **Ngoại lệ:** Tệp giả phần mở rộng, không hợp lệ hoặc quá lớn bị từ chối. Upload thành công nhưng lưu thẻ thất bại tạo tệp tạm để dọn sau. Ảnh đang được dùng không được xóa trực tiếp.
- **Kết quả:** Nội dung có ảnh hợp lệ và không xuất hiện tham chiếu bị hỏng do thay ảnh.
- **Nghiệm thu:** Admin chỉ truy cập kho nội dung chính thức qua chức năng này; không liệt kê ảnh riêng của người học.

### AD05 Import flashcard từ CSV

- **Tác nhân và kênh:** Admin; web admin; P1.
- **Điều kiện và kích hoạt:** Có bộ đích; chọn Nhập CSV.
- **Luồng chính:** Tải mẫu, chọn tệp UTF-8, ánh xạ cột và kiểm tra trước. Hệ thống liệt kê lỗi theo số dòng, cảnh báo nội dung trùng và cho sửa tệp. Khi dữ liệu hợp lệ, admin xác nhận nhập toàn bộ vào nháp rồi xem kết quả.
- **Ngoại lệ:** Có dòng lỗi thì không nhập một phần trong MVP. Gửi lại cùng tác vụ không tạo trùng. Tệp quá giới hạn, đề xuất 500 dòng hoặc 2 MB, bị từ chối. Không tự tải ảnh từ URL tùy ý trong CSV ở bản đầu.
- **Kết quả:** Có các thẻ nháp với số lượng được xác nhận, chưa tự xuất bản.
- **Nghiệm thu:** Kanji, Hiragana, dấu tiếng Việt, dấu phẩy trong ô có ngoặc kép và xuống dòng hợp lệ được đọc đúng; lỗi có số dòng để sửa.

### AD06 Xuất bản lưu trữ và gỡ nội dung khẩn cấp

- **Tác nhân và kênh:** Admin; web admin; P0.
- **Điều kiện và kích hoạt:** Có bộ hoặc thẻ cần thay đổi trạng thái.
- **Luồng chính:** Admin xem trước và kiểm tra nội dung. Bộ phải có ít nhất một thẻ đủ điều kiện để xuất bản. Lưu trữ thông thường ngừng khám phá và thêm mới, cho người đang theo học tiếp tục. Gỡ khẩn cấp yêu cầu lý do và ngừng cấp nội dung cho mọi người học.
- **Ngoại lệ:** Bộ rỗng hoặc còn lỗi bắt buộc không được xuất bản. Phiên đang mở gặp thẻ bị gỡ khẩn cấp phải bỏ qua hoặc dừng có thông báo; không phát lại từ cache sau khi đã nhận trạng thái gỡ.
- **Kết quả:** Trạng thái mới có hiệu lực và được ghi audit; dữ liệu học không bị xóa cứng.
- **Nghiệm thu:** Phân biệt rõ Lưu trữ và Gỡ khẩn cấp trong giao diện lẫn API; khôi phục không làm nội dung chưa duyệt tự công khai.

### AD07 Quản lý chủ đề và cấp độ

- **Tác nhân và kênh:** Admin; web admin; P1; P0 dùng danh mục khởi tạo sẵn.
- **Điều kiện và kích hoạt:** Mở Danh mục.
- **Luồng chính:** Tạo, sửa tên và thứ tự hiển thị của chủ đề hoặc cấp độ. Khi ngừng dùng một giá trị, chọn ẩn khỏi lựa chọn mới hoặc chuyển các bộ liên quan sang giá trị thay thế.
- **Ngoại lệ:** Không xóa giá trị đang được tham chiếu nếu chưa xử lý liên kết. Không tạo mã cấp độ trùng. Đổi tên không làm mất bộ đang gắn với mã đó.
- **Kết quả:** Bộ lọc và form nhập sử dụng danh mục thống nhất.
- **Nghiệm thu:** Thay tên chủ đề cập nhật cách hiển thị trên app, web và admin; cấp độ N5 hoặc N4 là nhãn nội dung, không được trình bày như chứng nhận chính thức.

### AD08 Tiếp nhận và xử lý báo lỗi

- **Tác nhân và kênh:** Admin; web admin; P1.
- **Điều kiện và kích hoạt:** Có báo lỗi từ ST15; admin mở danh sách cần xử lý.
- **Luồng chính:** Lọc theo trạng thái, loại lỗi hoặc bộ; xem nội dung và phiên bản được báo. Chuyển sang Đang xử lý, sửa thẻ qua AD03 hoặc ghi lý do không sửa. Kết thúc với trạng thái Đã sửa hoặc Không điều chỉnh, kèm kết quả cho người gửi.
- **Ngoại lệ:** Thẻ đã thay đổi thì hiển thị cả phiên bản được báo và hiện tại. Báo trùng được liên kết; không đóng tự động chỉ vì đã có người khác báo.
- **Kết quả:** Có kết quả xử lý được truy vết; người gửi xem được trong ứng dụng.
- **Nghiệm thu:** Không đánh dấu Đã sửa trước khi thay đổi thẻ được lưu thành công; không tiết lộ ghi chú riêng hoặc báo lỗi của người dùng khác.

### AD09 Quản lý trạng thái tài khoản

- **Tác nhân và kênh:** Admin; web admin; P0.
- **Điều kiện và kích hoạt:** Có quyền quản trị; mở danh sách người dùng.
- **Luồng chính:** Tìm tài khoản, xem thông tin quản lý tối thiểu như định danh, email, ngày tạo, vai trò và trạng thái. Khi khóa hoặc mở khóa, nhập lý do và xác nhận. Khóa làm backend chặn yêu cầu có xác thực, thu hồi phiên theo khả năng dịch vụ.
- **Ngoại lệ:** Không khóa admin hoạt động cuối cùng. Không được truy cập thẻ hoặc ghi chú riêng thông qua trang quản lý người dùng. Tác vụ lỗi phải thể hiện trạng thái thực tế.
- **Kết quả:** Trạng thái tài khoản thay đổi có audit; mở khóa cho phép đăng nhập mới, không tự khôi phục phiên cũ.
- **Nghiệm thu:** Tài khoản bị khóa không tiếp tục ghi dữ liệu chỉ vì access token chưa hết hạn.

### AD10 Cấp và thu hồi vai trò quản trị

- **Tác nhân và kênh:** Admin; web admin; P0.
- **Điều kiện và kích hoạt:** Tài khoản thực hiện đang có quyền admin, xác thực lại; chọn đổi vai trò của tài khoản hoạt động. Không yêu cầu xác minh email của tài khoản nhận quyền trong phạm vi hiện tại.
- **Luồng chính:** Chọn người nhận, xem cảnh báo phạm vi quyền, nhập lý do và xác nhận. Backend kiểm tra quyền lại tại thời điểm lưu, cập nhật vai trò và ghi audit. Các phiên của người được đổi quyền được làm mới hoặc buộc đăng nhập lại.
- **Ngoại lệ:** Không được thu hồi, xóa hoặc khóa admin hoạt động cuối cùng. Hai thao tác đồng thời không được vượt qua ràng buộc này. Admin đầu tiên được khởi tạo qua quy trình vận hành tin cậy, không qua form đăng ký công khai.
- **Kết quả:** Vai trò mới có hiệu lực theo chính sách phiên.
- **Nghiệm thu:** Client không thể tự nâng quyền bằng sửa hồ sơ, token giả hoặc gọi trực tiếp endpoint quản trị.

### AD11 Xem nhật ký quản trị

- **Tác nhân và kênh:** Admin; web admin; P0.
- **Điều kiện và kích hoạt:** Có quyền admin; mở Nhật ký.
- **Luồng chính:** Lọc theo người thực hiện, loại hành động, đối tượng và thời gian. Xem thay đổi liên quan tới xuất bản, gỡ nội dung, khóa tài khoản và đổi vai trò. Nhật ký liên kết được với tác vụ nguồn.
- **Ngoại lệ:** Kết quả lớn phải phân trang. Nếu hạ tầng audit không thể ghi một hành động nhạy cảm, hành động đó không được báo hoàn tất im lặng; phải thất bại hoặc được ghi nhận qua cơ chế bảo đảm tương đương.
- **Kết quả:** Có khả năng xác định ai đã thay đổi nội dung hoặc quyền và khi nào.
- **Nghiệm thu:** Không có quyền sửa hoặc xóa audit từ giao diện admin; nhật ký không chứa mật khẩu, token hoặc nội dung ghi chú cá nhân.

### AD12 Xem thống kê vận hành

- **Tác nhân và kênh:** Admin; web admin; P1.
- **Điều kiện và kích hoạt:** Có quyền admin; chọn khoảng ngày trên trang thống kê.
- **Luồng chính:** Xem số tài khoản hoạt động, số phiên và lượt học đã xác nhận, số bộ theo trạng thái, lượng báo lỗi và tình trạng tác vụ import hoặc xóa tài khoản. Mỗi chỉ số có định nghĩa và mốc cập nhật.
- **Ngoại lệ:** Tác vụ thống kê chậm phải hiển thị thời điểm dữ liệu gần nhất. Không có dữ liệu trả số không, không phải lỗi. Khoảng ngày không hợp lệ bị từ chối.
- **Kết quả:** Admin đánh giá được mức sử dụng và các hàng đợi cần xử lý.
- **Nghiệm thu:** Dữ liệu tổng hợp không mở đường đọc bộ riêng hoặc ghi chú cá nhân; lượt gửi lại trùng không tăng số lượt học.

## 9 Các tiến trình hỗ trợ

### SYS01 Gửi email và xử lý liên kết xác thực

**Tác nhân liên quan:** EXT01; hiện được kích hoạt từ AC04. Không kích hoạt từ AC01; AC02 chỉ sử dụng tiến trình này nếu được triển khai ở P2.

1. Nhận yêu cầu gửi theo đúng mục đích, địa chỉ hợp lệ và định danh tác vụ.
2. Kiểm tra giới hạn gửi, tạo hoặc yêu cầu dịch vụ danh tính tạo liên kết có thời hạn và mục đích rõ ràng.
3. Gửi qua dịch vụ email, ghi trạng thái và cho gửi lại có kiểm soát nếu lỗi tạm thời.
4. Khi mở liên kết, xác minh mục đích và trạng thái sử dụng; chỉ chuyển đến các địa chỉ app hoặc web đã cho phép.

**Ràng buộc:** Gửi được email không đồng nghĩa người nhận đã mở hoặc hoàn tất thao tác. Không ghi toàn bộ token vào log, không tạo đường chuyển hướng tùy ý. Sự cố email không ảnh hưởng khả năng đăng ký và đăng nhập bằng mật khẩu hợp lệ của tài khoản hoạt động.

**Nghiệm thu:** Liên kết đặt lại mật khẩu chỉ được dùng đúng mục đích; yêu cầu lặp không phát sinh thay đổi danh tính lặp. Không gửi liên kết xác minh đăng ký trong phạm vi hiện tại.

### SYS02 Lưu và đồng bộ thay đổi giữa thiết bị

**Kích hoạt:** Lưu nội dung, ghi chú, đánh giá, thay đổi thư viện hoặc tiếp tục phiên.

1. Kiểm tra phiên, trạng thái tài khoản và quyền đối tượng ở backend.
2. Với lượt đánh giá, dùng mã sự kiện duy nhất và phiên bản tiến độ hoặc quyền ghi phiên để kiểm tra lặp và xung đột.
3. Ghi sự kiện, tiến độ và vị trí phiên theo một giao dịch hoặc cơ chế có tính nhất quán tương đương; gửi phản hồi chứa phiên bản mới.
4. Thiết bị khác lấy trạng thái mới khi mở lại, chuyển về foreground hoặc thực hiện thao tác liên quan. Khi hai thiết bị cùng mở một phiên, chỉ một bên có quyền ghi; bên kia được thông báo và có thể chủ động chuyển quyền.
5. Nội dung và ghi chú dùng kiểm tra phiên bản. Nếu đã có bản mới, trả xung đột để người dùng xem hoặc hợp nhất; không ghi đè âm thầm.

**Mất kết nối:** Hiển thị Đang lưu hoặc Chưa lưu; giữ thay đổi tạm trong phạm vi tài khoản hiện tại khi phù hợp. Không cam kết học offline. Nếu phản hồi bị mất sau khi máy chủ đã lưu, gửi lại cùng mã sự kiện để lấy cùng kết quả.

**Nghiệm thu:** Hai sự kiện khác mã cùng dựa trên một phiên bản tiến độ không được cùng ghi đè lẫn nhau; cùng một sự kiện gửi lại không thay đổi số liệu lần thứ hai. Thu hồi quyền được kiểm tra lại khi ghi.

### SYS03 Tính lịch ôn và tổng hợp tiến độ

**Kích hoạt:** Một lượt đánh giá trong phiên học chính thức được chấp nhận.

1. Đọc tiến độ hiện tại, đánh giá mới và phiên bản thuật toán đang áp dụng.
2. Tính lần xuất hiện tiếp theo: Chưa nhớ quay lại sớm; Khó có khoảng cách ngắn hơn Nhớ và Dễ trong cùng trạng thái xuất phát. Khoảng thời gian cụ thể do cấu hình hoặc thuật toán xác định.
3. Lưu lịch ôn mới cùng sự kiện; cập nhật danh sách phiên nếu có bước học lại trong buổi.
4. Tổng hợp số lượt học, số thẻ duy nhất và ngày học theo múi giờ đã lưu của hồ sơ.

**Ràng buộc:** Không tính lịch từ thao tác xem thẻ, lật thẻ, yêu thích hoặc luyện tự do. Không dựa vào đồng hồ thiết bị để quyết định đến hạn. Mốc thời gian lưu theo UTC, hiển thị theo múi giờ người dùng.

**Nghiệm thu:** Mỗi lượt chấp nhận tạo đúng một lần chuyển tiến độ; có phiên bản thuật toán để giải thích lịch sử. Bộ kiểm thử phải dùng các trạng thái và thời điểm cố định. Việc chọn thuật toán cụ thể là bước thiết kế kỹ thuật tiếp theo, không được thay bằng các khoảng ngày tùy tiện trong mỗi client.

## 10 Quy tắc nghiệp vụ xuyên suốt

| Mã | Quy tắc |
|---|---|
| BR01 | Mọi thao tác riêng tư yêu cầu phiên hợp lệ và kiểm tra quyền ở backend theo người dùng và đối tượng |
| BR02 | Bộ cá nhân và ghi chú cá nhân là riêng tư; quyền admin vận hành không tự mở quyền đọc nội dung này |
| BR03 | Kanji và cách đọc lưu riêng. Có thể ẩn Hiragana mà vẫn hiển thị từ và đáp án đúng chế độ |
| BR04 | Không bắt buộc mọi thẻ có Kanji. Thẻ từ vựng chứa Kanji cần cách đọc trước khi được lưu hoặc xuất bản theo loại tương ứng |
| BR05 | Tiến độ thuộc cặp người dùng và thẻ; ghi chú không dùng chung với tiến độ hoặc nội dung gốc |
| BR06 | Sửa nội dung không tự reset tiến độ; thay đổi sang kiến thức khác cần tạo thẻ mới |
| BR07 | Thẻ đã có lượt học không xóa cứng qua thao tác quản lý thông thường; lưu trữ và giữ tham chiếu |
| BR08 | Kiểm tra ảnh theo nội dung tệp, loại cho phép, kích thước và quyền. Không đưa ảnh riêng vào đường dẫn công khai không kiểm soát |
| BR09 | Gỡ bộ khỏi thư viện ngừng ôn nhưng giữ tiến độ và ghi chú. Reset tiến độ là hành động riêng có xác nhận |
| BR10 | Mỗi lượt đánh giá có định danh chống ghi lặp và kiểm tra phiên bản để tránh ghi đè khi nhiều thiết bị cùng học |
| BR11 | Tài khoản bị khóa hoặc đang xử lý xóa không được tiếp tục ghi dữ liệu, kể cả còn token chưa hết hạn |
| BR12 | Không được làm hệ thống mất admin hoạt động cuối cùng; ràng buộc áp dụng cả khi thao tác đồng thời |
| BR13 | Một tài khoản có tối đa một phiên học chính thức đang hoạt động trong MVP; có thể chuyển thiết bị nhưng không ghi đồng thời |
| BR14 | Tài liệu không coi kết quả tự đánh giá là kết quả thi; các chỉ số phải ghi đúng ý nghĩa |
| BR15 | Bộ chính thức lưu trữ vẫn phục vụ người đã theo học; bộ hoặc thẻ bị gỡ khẩn cấp ngừng phục vụ mọi người |
| BR16 | Thời điểm hệ thống lưu theo UTC; ngày học và giao diện dùng múi giờ hồ sơ. Không tạo lượt học mới do đổi múi giờ |
| BR17 | Xóa tài khoản khác với đăng xuất, gỡ bộ và reset. Phải công bố phạm vi xóa, dữ liệu giữ lại cần thiết và thời gian xử lý trước phát hành |
| BR18 | Dữ liệu nhập tay và CSV đi qua cùng quy tắc kiểm tra; client không được bỏ qua kiểm tra của backend |
| BR19 | Đổi vai trò, khóa tài khoản, xuất bản, gỡ khẩn cấp và reset là thao tác nhạy cảm, cần xác nhận và dấu vết phù hợp |
| BR20 | Dữ liệu nháp chỉ cho chủ nội dung hoặc người có quyền tương ứng. Danh sách công khai không dựa riêng vào việc ẩn nút |
| BR21 | Đăng ký thành công tạo tài khoản Hoạt động; không yêu cầu xác minh email để đăng nhập, học hoặc nhận vai trò được admin cấp. Khôi phục mật khẩu là luồng riêng |

## 11 Trạng thái và vòng đời

### 11.1 Tài khoản

| Trạng thái | Khả năng sử dụng | Chuyển trạng thái chính |
|---|---|---|
| Hoạt động | Có ngay sau đăng ký thành công, sử dụng theo vai trò được cấp, không yêu cầu xác minh email | Admin khóa hoặc chủ tài khoản yêu cầu xóa |
| Bị khóa | Không tạo phiên mới, không ghi dữ liệu riêng | Admin mở khóa sang Hoạt động |
| Đang xóa | Thu hồi phiên, chặn ghi mới | Tiến trình hoàn tất sang Đã xóa |
| Đã xóa | Không sử dụng tài khoản cũ | Không khôi phục bằng thao tác đăng nhập |

Không có trạng thái Chờ xác minh trong vòng đời tài khoản hiện tại. Nếu triển khai AC02 ở P2, cần bổ sung chính sách chuyển đổi riêng thay vì tự chặn các tài khoản đang hoạt động.

### 11.2 Nội dung và tiến độ

| Đối tượng | Trạng thái đề xuất | Ý nghĩa |
|---|---|---|
| Bộ chính thức | Nháp, Xuất bản, Lưu trữ, Gỡ khẩn cấp | Kiểm soát khám phá, quyền thêm mới và quyền tiếp tục học |
| Thẻ chính thức | Nháp, Hoạt động, Lưu trữ, Gỡ khẩn cấp | Trạng thái bộ đặt giới hạn bên ngoài; thẻ chỉ công khai khi cả bộ và thẻ đủ điều kiện |
| Bộ cá nhân | Hoạt động, Lưu trữ | Chỉ chủ sở hữu truy cập; bộ rỗng được lưu nhưng chưa học được |
| Thẻ cá nhân | Hoạt động, Lưu trữ | Chưa từng có lượt học có thể xóa sau xác nhận |
| Quan hệ thư viện | Đang theo học, Đã gỡ | Quyết định bộ có đóng góp vào danh sách ôn hay không |
| Tiến độ | Mới, Đang học, Đang ôn, Cần học lại | Đến hạn là điều kiện theo thời gian, không phải trạng thái riêng |
| Phiên học | Đang học, Tạm dừng, Hoàn tất, Kết thúc sớm | Chỉ các lượt đã xác nhận ảnh hưởng tiến độ |
| Báo lỗi | Mới, Đang xử lý, Đã sửa, Không điều chỉnh, Trùng | Kết quả cuối có lý do và liên kết tới thay đổi nếu có |

Lưu trữ bộ không tự đổi trạng thái riêng của từng thẻ. Khôi phục bộ vì vậy không làm những thẻ đã lưu trữ trước đó tự hoạt động trở lại. Các ảnh hoặc câu hỏi bị gỡ vì nội dung không hợp lệ phải tuân thủ trạng thái gỡ khẩn cấp, kể cả trong phiên đang mở.

## 12 Hành trình và tiêu chí nghiệm thu tổng thể

### 12.1 Hành trình học với Kanji và Hiragana

1. Khách mở web, tìm bộ N4 về công việc và học thử 5 thẻ.
2. Đăng ký rồi đăng nhập ngay, không cần xác minh email; thêm bộ vào thư viện.
3. Chọn học 10 thẻ, mặt trước là Kanji và ẩn Hiragana.
4. Thẻ hiển thị 会議; người học tự nhớ, có thể mở gợi ý かいぎ.
5. Lật thẻ để xem nghĩa cuộc họp, câu ví dụ và ghi chú nội dung.
6. Chọn Khó, hệ thống xác nhận lưu và lên lịch ôn; người học thêm ghi chú cá nhân.
7. Tạm dừng trên web, tiếp tục trên điện thoại từ trạng thái đã được xác nhận.
8. Khi đến hạn, thẻ xuất hiện trong Ôn hôm nay.
9. Admin sửa lỗi câu ví dụ; buổi học sau nhận nội dung mới, ghi chú và tiến độ cá nhân còn nguyên.

### 12.2 Hành trình tạo nội dung riêng

1. Người học tạo bộ N4 bài đang học và nhập mô tả.
2. Thêm thẻ 学校, cách đọc がっこう, nghĩa trường học và ảnh minh họa.
3. Thêm một thẻ ảnh và chữ không có Kanji; xem trước cả hai mặt.
4. Lưu, mở trên thiết bị khác và bắt đầu học.
5. Sửa cách giải thích hoặc ảnh mà vẫn giữ tiến độ của thẻ.
6. Lưu trữ một thẻ đã học; thẻ ngừng tham gia phiên mới, lịch sử còn nguyên.

### 12.3 Hành trình quản trị nội dung

1. Admin đăng nhập, tạo bộ nháp và nhập hoặc import thẻ.
2. Xem trước Kanji, dòng Hiragana và hai mặt thẻ; sửa dữ liệu thiếu.
3. Xuất bản; người học khám phá và thêm bộ.
4. Người học báo sai cách đọc; admin kiểm tra phiên bản được báo và sửa.
5. Admin cập nhật kết quả báo lỗi; người gửi xem được phản hồi trong app.
6. Nếu cần ngừng giới thiệu bộ, dùng Lưu trữ; nếu nội dung không hợp lệ cần ngừng phát ngay, dùng Gỡ khẩn cấp.

### 12.4 Các tình huống kiểm thử chấp nhận

| Mã | Tình huống | Kết quả phải đạt | Tham chiếu |
|---|---|---|---|
| AT01 | Đăng ký rồi đăng nhập ngay, không mở email | Tài khoản hoạt động, học được ngay, không gửi thư xác minh và không tự cấp admin | AC01, AC03, BR21 |
| AT02 | Mở liên kết đặt lại mật khẩu hết hạn hoặc dùng lại | Có đường yêu cầu liên kết mới; không thay đổi danh tính sai | AC04 |
| AT03 | Người học gọi API admin | Bị từ chối trước khi trả dữ liệu | AC03, AD01 |
| AT04 | Đăng xuất A, đăng nhập B trên cùng thiết bị | Không thấy dữ liệu riêng của A | AC05 |
| AT05 | Tạo từ vựng có Kanji thiếu cách đọc | Báo lỗi trường, không lưu thẻ hợp lệ giả | ST12, AD03 |
| AT06 | Tạo thẻ chỉ có Kana hoặc thẻ ảnh | Được chấp nhận khi đáp ứng quy tắc đúng loại | ST12 |
| AT07 | Ẩn Hiragana và lật thẻ | Mặt trước không lộ dòng cách đọc, mặt sau hiển thị đúng | ST05, ST10 |
| AT08 | Nhấn đánh giá nhiều lần hoặc gửi lại sau timeout | Một sự kiện chỉ tính một lần | ST05, SYS02 |
| AT09 | Hai thiết bị cùng ghi một phiên | Bên mất quyền ghi phải tải lại, không ghi đè | ST07, SYS02 |
| AT10 | Đóng app giữa buổi rồi mở lại | Khôi phục từ trạng thái đã xác nhận | ST07 |
| AT11 | Admin sửa nghĩa của thẻ đã học | Nội dung mới xuất hiện, ghi chú và tiến độ giữ nguyên | AD03, BR06 |
| AT12 | Người khác đoán URL ghi chú hoặc ảnh riêng | Không đọc được nội dung riêng | ST08, BR02, BR08 |
| AT13 | Gỡ bộ rồi thêm lại | Ngừng ôn khi gỡ; khôi phục tiến độ khi thêm lại | ST01, ST03 |
| AT14 | Reset trong khi thiết bị khác còn phiên cũ | Phiên cũ không làm sống lại tiến độ trước reset | ST16 |
| AT15 | Ảnh quá lớn hoặc giả phần mở rộng | Bị từ chối, nội dung trước đó còn nguyên | ST12, AD04 |
| AT16 | Import CSV có lỗi ở một dòng | Không nhập một phần, báo đúng số dòng | AD05 |
| AT17 | Import tệp hợp lệ rồi gửi lại cùng tác vụ | Không tạo thêm bộ thẻ trùng | AD05 |
| AT18 | Người dùng thường mở bộ nháp qua URL | Không nhận được nội dung nháp | G01, AD02 |
| AT19 | Lưu trữ bộ chính thức đang có người học | Không cho thêm mới; người đã theo học tiếp tục theo chính sách | AD06 |
| AT20 | Gỡ khẩn cấp thẻ đang nằm trong phiên | Bỏ qua hoặc dừng có thông báo; không cấp lại nội dung | AD06 |
| AT21 | Khóa tài khoản còn access token hợp lệ | Chặn ghi và truy cập có xác thực theo trạng thái mới | AD09 |
| AT22 | Hai admin đồng thời thu hồi quyền của nhau | Luôn còn ít nhất một admin hoạt động | AD10 |
| AT23 | Xóa tài khoản có ảnh và bộ riêng | Xóa dữ liệu riêng, không xóa nội dung chính thức hay tệp còn dùng | AC09 |
| AT24 | Đổi múi giờ gần nửa đêm | Không tạo thêm lượt học, ngày hiển thị được tính nhất quán | ST14, SYS03 |
| AT25 | Luyện tự do từ mục yêu thích | Không thay lịch ôn chính thức ngoài ý muốn | ST09 |
| AT26 | Thống kê sau nhiều lần đánh giá lại cùng thẻ | Phân biệt lượt đánh giá với số thẻ duy nhất | ST14, AD12 |
| AT27 | Chuyển trạng thái nhạy cảm nhưng ghi audit thất bại | Không báo hoàn tất nếu chưa có bảo đảm ghi nhận | AD11 |

## 13 Các use case mở rộng

Ngoài AC02 đã được giữ làm đặc tả dự kiến P2, các mục dưới đây chưa thuộc 39 use case đã đặc tả. Chỉ triển khai sau khi có yêu cầu và phân tích chi tiết tương ứng.

| Mã | Tác nhân | Mở rộng | Điều cần xác định trước khi triển khai |
|---|---|---|---|
| EX01 | Người học | Nghe phát âm | Nguồn âm thanh, cách đọc nhiều nghĩa, quyền sử dụng và cache |
| EX02 | Người học và admin | Furigana theo cụm Kanji | Lưu ánh xạ từng đoạn; không suy ra đúng từ một chuỗi Hiragana toàn câu |
| EX03 | Người học và admin | Thẻ Kanji chuyên biệt | Nhiều âm On và Kun, nghĩa, ví dụ theo cách đọc và thứ tự nét nếu có |
| EX04 | Người học và admin | Chia sẻ bộ công khai | Chủ sở hữu, quyền sao chép, báo cáo, kiểm duyệt và cập nhật bản sao |
| EX05 | Người học | Học offline | Dữ liệu tải trước, hàng đợi, xung đột tiến độ và thu hồi quyền nội dung |
| EX06 | Người học | AI hỗ trợ tạo thẻ | Người dùng duyệt nội dung; không tự tin cậy cách đọc hoặc nghĩa do AI tạo |
| EX07 | Người học | Xuất dữ liệu cá nhân | Định dạng, phạm vi dữ liệu, xác thực lại và bảo vệ tệp xuất |
| EX08 | Người học | Import bộ cá nhân | Kiểm tra định dạng, trùng dữ liệu, quyền ảnh và xử lý lỗi theo dòng |
| EX09 | Người học | Nhắc học theo lịch | Quyền thông báo, múi giờ, giờ yên lặng và tắt đăng ký |
| EX10 | Admin | Phân quyền biên tập viên | Tách quyền soạn thảo, duyệt xuất bản và quản lý người dùng |

## 14 Yêu cầu chất lượng và danh sách màn hình

### 14.1 Yêu cầu chất lượng

- **Hiển thị tiếng Nhật:** Kanji, Hiragana, Katakana và dấu tiếng Việt phải được lưu và hiển thị đúng Unicode. Không cắt mất dấu hoặc cách đọc dài; chữ trên thẻ có thể xuống dòng.
- **Khả năng sử dụng:** Nút lật, hiện cách đọc và đánh giá dễ phân biệt. Web hỗ trợ bàn phím, trạng thái focus và tên điều khiển rõ ràng. Không chỉ dùng màu để phân biệt mức nhớ.
- **Nhất quán:** App và web áp dụng cùng quy tắc kiểm tra nội dung, quyền và lịch ôn. Không để mỗi client tự tính một lịch khác nhau.
- **Phản hồi lưu:** Phân biệt đang tải, đang lưu, đã lưu, chưa lưu, không có dữ liệu và không có quyền. Chỉ thông báo thành công khi thao tác đã được xác nhận.
- **Hiệu năng:** Danh sách phải phân trang hoặc tải dần; ảnh có kích thước hiển thị phù hợp. Mục tiêu thời gian phản hồi cụ thể cần được chốt theo hạ tầng và kiểm thử trước phát hành.
- **Bảo mật:** Client chỉ sử dụng cấu hình công khai phù hợp; không đưa khóa đặc quyền vào app hoặc web. Tệp riêng cần kiểm tra quyền. Không lưu mật khẩu hoặc token trong log nghiệp vụ.
- **Vận hành:** Theo dõi lỗi gửi email, đồng bộ, import và xóa tài khoản; có thể truy vết tác vụ và chạy lại mà không tạo thay đổi trùng.
- **Dữ liệu cá nhân:** Trước phát hành phải chốt nội dung chính sách dữ liệu, phạm vi và thời gian xử lý xóa, thời gian lưu nhật ký cần thiết và cơ chế hỗ trợ người dùng.

### 14.2 Màn hình người học

| Nhóm | Màn hình | Use case |
|---|---|---|
| Tài khoản | Đăng nhập, đăng ký, quên hoặc đổi mật khẩu; không có màn hình chờ xác minh hiện tại | AC01, AC03, AC04, AC07 |
| Khám phá | Danh sách, tìm kiếm, chi tiết bộ, học thử | G01 đến G03 |
| Trang chủ | Thẻ đến hạn, tiếp tục phiên, kết quả gần đây | ST06, ST07, ST14 |
| Thư viện | Bộ đang học, bộ tự tạo, bộ đã lưu trữ | ST01 đến ST03, ST11, ST13 |
| Học | Cấu hình phiên, thẻ hai mặt, ghi chú, kết quả phiên | ST04 đến ST10, ST14 |
| Nội dung riêng | Tạo hoặc sửa bộ, danh sách thẻ, form thẻ, xem trước | ST11 đến ST13 |
| Cá nhân | Hồ sơ, cài đặt, phiên đăng nhập, xóa tài khoản | AC05 đến AC07, AC09 |
| Phản hồi | Gửi và theo dõi báo lỗi | ST15 |
| Tiến độ | Thống kê, yêu thích, đặt lại tiến độ | ST09, ST14, ST16 |

### 14.3 Màn hình quản trị

| Nhóm | Màn hình | Use case |
|---|---|---|
| Truy cập | Đăng nhập và kiểm tra quyền | AC03, AD01 |
| Nội dung | Danh sách bộ, form bộ, danh sách thẻ, form thẻ, xem trước, xuất bản | AD02, AD03, AD06 |
| Tài nguyên | Ảnh chính thức và nhập CSV | AD04, AD05 |
| Danh mục | Cấp độ và chủ đề | AD07 |
| Phản hồi | Danh sách và chi tiết báo lỗi | AD08 |
| Người dùng | Danh sách, trạng thái tài khoản và phân vai trò | AD09, AD10 |
| Vận hành | Nhật ký quản trị và thống kê | AD11, AD12 |

## 15 Những quyết định cần chốt trước khi xây dựng

Tài liệu đã đề xuất hành vi mặc định để tránh bỏ trống luồng triển khai. Các quyết định dưới đây cần được duyệt ở bước thiết kế sản phẩm hoặc kỹ thuật; không ngăn việc bắt đầu các phần đã rõ.

| Quyết định | Đề xuất hiện tại | Hệ quả nếu thay đổi |
|---|---|---|
| Loại nội dung MVP | Từ vựng Nhật và thẻ chữ hoặc ảnh; Kanji chuyên biệt làm sau | Thêm Kanji chuyên biệt sớm cần form nhiều cách đọc và thêm chế độ học |
| Hiragana | Dòng cách đọc riêng, có bật hoặc tắt | Furigana theo cụm cần cấu trúc dữ liệu bổ sung |
| Thuật toán ôn | Một thuật toán có phiên bản, chạy thống nhất ở backend | Cần chốt quy tắc và dữ liệu kiểm thử trước khi xây lịch ôn |
| Nội dung cá nhân | Riêng tư, một thẻ thuộc một bộ | Chia sẻ và dùng chung thẻ làm thay đổi quyền và mô hình tiến độ |
| Nhiều thiết bị | Một phiên học chính thức hoạt động, cho chuyển quyền ghi | Cho học song song cần quy tắc hợp nhất lịch ôn phức tạp hơn |
| Chính sách ảnh | JPEG, PNG, WebP tối đa 5 MB | Cần điều chỉnh chi phí lưu trữ và xử lý ảnh nếu tăng giới hạn |
| Tài khoản | Email và mật khẩu, không yêu cầu xác minh email khi đăng ký hoặc đăng nhập | Nếu bật xác minh sau này cần chốt chính sách cho tài khoản đang hoạt động; Google hoặc Apple cần thêm liên kết danh tính và xử lý tài khoản trùng |
| Xóa tài khoản | Xác thực lại, chặn ghi mới và xóa bằng tác vụ theo dõi được | Phải chốt thời hạn xử lý và lưu giữ trước phát hành |
| Import | Admin nhập CSV vào nháp, tối đa đề xuất 500 dòng | Nhập lớn hoặc cập nhật theo mã ngoài cần cơ chế tác vụ và chống trùng bổ sung |
| Nội dung khởi tạo | Bộ nhỏ theo chủ đề N5 và N4, có người kiểm tra trước xuất bản | Cần phân công người biên soạn và kiểm tra cách đọc, nghĩa, ảnh |

Tài liệu này là cơ sở để thiết kế màn hình, mô hình dữ liệu, hợp đồng API, backlog và kế hoạch kiểm thử. Khi đổi một quy tắc, cần cập nhật đồng thời use case, ma trận quyền và tình huống nghiệm thu liên quan.
