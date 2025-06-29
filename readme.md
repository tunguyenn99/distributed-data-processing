

sudo apt install make-y

Some `Make` commands

 1. makeup: Spin upthe docker containers.
 2. maketrino: Open trino cli; Use exit to quit the cli. This is where
 you will type your SQL queries.
 3. makedown: Stop the docker containers.



Các phép biến đổi rộng (Wide transformations) tốn kém hơn về mặt thời gian so với narrow transformations, vì việc di chuyển dữ liệu giữa các node mất nhiều thời gian hơn so với chỉ đọc từ hệ thống file.

Do đó, việc giảm lượng dữ liệu được shuffle giữa các node trong cluster là rất quan trọng.

⚙️ Thứ tự chi phí (từ cao đến thấp) về tốc độ xử lý:
Di chuyển dữ liệu giữa các node trong cluster (tốn kém nhất)

Đọc dữ liệu từ hệ thống file

Xử lý dữ liệu trong bộ nhớ (RAM) (nhanh nhất)

👉 Chúng ta có thể giảm lượng dữ liệu cần di chuyển (data shuffle) bằng cách:

Áp dụng bộ lọc (WHERE) trước khi thực hiện JOIN, để loại bỏ các dòng không cần thiết.

Chỉ đọc những cột cần thiết thay vì SELECT *, nhằm giảm khối lượng dữ liệu được xử lý và truyền đi.

