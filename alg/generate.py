import json
import qrcode

# 1. 加载 JSON 文件
with open('data.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

# 2. 转为字符串
json_str = json.dumps(data)

# 3. 生成二维码
qr = qrcode.make(json_str)
qr.save("qrcode.png")
print("二维码已保存为 qrcode.png")
