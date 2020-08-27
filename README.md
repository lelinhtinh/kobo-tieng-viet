# Hướng dẫn sửa lỗi font Tiếng Việt cho máy đọc sách Kobo

Sách Tiếng Việt trên Kobo vẫn có thể đọc được khi chọn font `Kobo Nickel`, tuy nhiên tên sách, mục lục, ... sẽ bị lỗi do font hệ thống không hỗ trợ. Cách sửa lỗi này là ghi đè font `Avenir Next` và `Georgia` bằng font có hỗ trợ Tiếng Việt nhờ công cụ [KoboPatch](https://github.com/pgaskin/kobopatch).

## Các bước thực hiện

1. Xem thông tin **version** hiện tại trên máy Kobo: **Settings > Device informantion > Software version**.
1. Tải **KoboPatch** [tại đây](https://pgaskin.net/kobopatch-patches/). Lưu ý chọn đúng version trên máy, file tải xuống sẽ có dạng **kobopatch_1.2.3456.zip**.
1. Tải **Kobo Firmware** [tại đây](https://pgaskin.net/KoboStuff/kobofirmware.html), hoặc tìm link tải trực tiếp trên [MobileRead Wiki](https://wiki.mobileread.com/wiki/Kobo_Firmware_Releases). Lưu ý chọn đúng version và dòng máy, file tải xuống sẽ có dạng **kobo-update-1.2.3456.zip**.
1. Giải nén **KoboPatch**, chép **Kobo Firmware** vào thư mục **src** _(không giải nén firmware)_.
1. Tải [kobo-tieng-viet](https://github.com/lelinhtinh/kobo-tieng-viet/archive/master.zip) và giải nén. Chép thư mục **overwrite-fonts** vào **src**.
1. Sửa file **kobopatch.yaml**, thêm vào cuối:

    ```yaml
    files:
      src/overwrite-fonts/AvenirNext-Bold.ttf: usr/local/Trolltech/QtEmbedded-4.6.2-arm/lib/fonts/Avenir-Bold.ttf
      src/overwrite-fonts/AvenirNext-BoldItalic.ttf: usr/local/Trolltech/QtEmbedded-4.6.2-arm/lib/fonts/Avenir-BoldItalic.ttf
      src/overwrite-fonts/AvenirNext-Italic.ttf: usr/local/Trolltech/QtEmbedded-4.6.2-arm/lib/fonts/Avenir-Italic.ttf
      src/overwrite-fonts/AvenirNext-Regular.ttf: usr/local/Trolltech/QtEmbedded-4.6.2-arm/lib/fonts/Avenir.ttf
      src/overwrite-fonts/Georgia-Regular.ttf: usr/local/Trolltech/QtEmbedded-4.6.2-arm/lib/fonts/georgia.ttf
      src/overwrite-fonts/Georgia-Bold.ttf: usr/local/Trolltech/QtEmbedded-4.6.2-arm/lib/fonts/georgiab.ttf
      src/overwrite-fonts/Georgia-Italic.ttf: usr/local/Trolltech/QtEmbedded-4.6.2-arm/lib/fonts/georgiai.ttf
      src/overwrite-fonts/Georgia-BoldItalic.ttf: usr/local/Trolltech/QtEmbedded-4.6.2-arm/lib/fonts/georgiaz.ttf
    ```

1. Chạy **kobopatch.bat** trên Windows, hoặc **kobopatch.sh** nếu dùng Linux.
1. Khi tiến trình hoàn tất sẽ tạo ra file **KoboRoot.tgz** trong thư mục **out**.
1. Kết nốt Kobo với máy tính, chép **KoboRoot.tgz** vào thư mục **.kobo**.
1. Thực hiện **eject ổ USB** để ngắt kết nối Kobo an toàn, tránh lỗi dữ liệu. Chờ một lúc để máy khởi động lại.

## Cài từ điển Anh-Việt

1. Tải **DictUtil** bản mới nhất [tại đây](https://github.com/pgaskin/dictutil/releases/latest). Lưu ý chỉ tải file DictUtil, nếu dùng Windows thì chọn **dictutil-windows.exe**.
1. Chép **DictUtil** vào thư mục chứa từ điển **dicthtml-en-vi.zip** và **dicthtml-vi-en.zip**. Nếu bạn đã tải kobo-tieng-viet khi sửa font ở trên, thì chúng nằm trong thư mục **dict** _(không phải trong máy Kobo)_.
1. Kết nối Kobo với máy tính. Tại thư mục chứa từ điển và DictUtil, chạy lệnh:

    ```bash
    chmod +x dictutil-linux-64bit
    ./dictutil-linux-64bit install dicthtml-en-vi.zip
    ./dictutil-linux-64bit install dicthtml-vi-en.zip
    ```

    hoặc:

    ```bash
    dictutil-windows.exe install dicthtml-en-vi.zip
    dictutil-windows.exe install dicthtml-vi-en.zip
    ```

    ... nếu dùng Windows.
1. Thực hiện **eject ổ USB** để ngắt kết nối Kobo an toàn, tránh lỗi dữ liệu.

## Các công cụ & nguồn tham khảo

- [Google Font](https://fonts.google.com/?category=Serif,Sans+Serif&subset=vietnamese&stylecount=4): Tìm font hỗ trợ Tiếng Việt.
- [FontForge](http://fontforge.github.io/): Công cụ đổi thông tin Font sang `Avenir Next` và `Georgia`.
- [KoboPatch - An improved patching system](https://www.mobileread.com/forums/showthread.php?t=297338): Hướng dẫn và hỗ trợ của chính tác giả KoboPatch.
- [KoboPatch users & non-Kobo-supported languages](https://www.mobileread.com/forums/showthread.php?t=323350): Chủ đề thảo luận về các phương pháp dùng KoboPatch để hỗ trợ ngôn ngữ không chính thức.
- [Stardict VI](https://github.com/dynamotn/stardict-vi): Nguồn từ điển Tiếng Việt.
- [Index of Custom Dictionaries for Kobo eReader](https://www.mobileread.com/forums/showthread.php?t=232883): Danh sách các từ điển làm sẵn bao gồm Anh-Việt.
- [Penelope](https://github.com/BOOKEEN/penelope): Công cụ chuyển đổi từ điển sang định dạng Kobo hỗ trợ.
- [Installing custom dictionaries](https://pgaskin.net/dictutil/dicthtml/install.html): Các bước cài từ điển thủ công nếu không thích dùng DictUtil.

## Giải pháp khác

<details><summary>Sửa <code>font-family</code> trong Nickel CSS</summary>

Xem hướng dẫn [KoboPatch users & non-Kobo-supported languages](https://www.mobileread.com/forums/showpost.php?p=3896513&postcount=10).

#### Ưu điểm

- Không cần sửa đổi font.

#### Nhược điểm

- Lỗi font ở một số vị trí Nickel CSS không hỗ trợ như Book Details.

</details>

<details><summary>Xóa phông chữ hệ thống</summary>

Xem hướng dẫn [Vietnamese full fixed 99% read for Kobo](https://www.mobileread.com/forums/showthread.php?t=287123).

#### Ưu điểm

- Dễ thực hiện.

#### Nhược điểm

- Lỗi font ở một số vị trí không quan trọng.

</details>

<details><summary>Dùng trình đọc sách thay thế: <strong>KOReader & Plato</strong></summary>

Xem hướng dẫn [One-Click Install Packages for KOReader & Plato](https://www.mobileread.com/forums/showthread.php?t=314220).

### [Plato](https://github.com/baskerville/plato)

#### Ưu điểm

- Mở và đọc sách khá nhanh.
- Giao diện đơn giản, gọn gàng.
- Khả năng xoay lật mọi hướng.
- Có các ứng dụng hữu ích: Máy tính, bảng vẽ, ...

#### Nhược điểm

- Không hỗ trợ tra từ điển.
- Đèn màn hình không tự động thiết lập theo môi trường, tuy nhiên có cài đặt thay đổi theo khung giờ.

### [KOReader](https://github.com/koreader/koreader)

#### Ưu điểm

- Cho phép đồng bộ vị trí đọc với cả những sách ngoài cửa hàng.
- Có phiên bản Android, Linux và nhiều eReader khác như Kindle.
- Khả năng xoay lật mọi hướng.
- Hỗ trợ tra từ điển.
- ...và nhiều tính năng, tuỳ chỉnh phức tạp khác.

#### Nhược điểm

- Tính năng đồng bộ thường bị chậm, đôi lúc bị mất vị trí đọc sách hiện tại.
- Đèn màn hình không tự động thiết lập theo môi trường.
- Kết nối USB với máy tính khá rắc rối.
- Cực chậm với sách lớn khoảng 5MB trở lên, chậm ngay cả khi đổi kích thước chữ, font chữ, ...

</details>
