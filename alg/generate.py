import json
import qrcode
import barcode
from barcode.writer import ImageWriter
from PIL import Image

# 1. 加载 JSON 文件
with open('data.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

# 2. 转为字符串
json_str = json.dumps(data)

# 3. 生成二维码
qr = qrcode.make(json_str)
qr_path = "qrcode.png"
qr.save(qr_path)
print("二维码已保存为 qrcode.png")

import os

# 4. 生成 EAN-13 条形码
ean = barcode.get_barcode_class('ean13')
ean_code = ean('123456789012', writer=ImageWriter())  # EAN-13 编号，这里用示例的12位数字
barcode_path = "ean13.png"
ean_code.save(barcode_path)
print("EAN-13 条形码已保存为 ean13.png")

# Add a debug print to check if the file exists
if os.path.exists(barcode_path):
    print(f"条形码文件存在: {barcode_path}")
else:
    print(f"条形码文件不存在: {barcode_path}")

# 5. 将二维码和条形码合并到同一图像中
qr_img = Image.open(qr_path)
barcode_img = Image.open(barcode_path)


# 调整条形码图像大小，以便它们适应同一个图像
barcode_img = barcode_img.resize((qr_img.width, int(qr_img.height / 3)))

# 创建一个新的图像，大小为二维码和条形码高度之和
combined_img = Image.new('RGB', (qr_img.width, qr_img.height + barcode_img.height), (255, 255, 255))

# 将二维码和条形码粘贴到合成图像中
combined_img.paste(qr_img, (0, 0))
combined_img.paste(barcode_img, (0, qr_img.height))

# 保存合成图像
combined_img_path = "combined_qr_and_barcode.png"
combined_img.save(combined_img_path)
print(f"二维码和条形码已合并并保存为 {combined_img_path}")
