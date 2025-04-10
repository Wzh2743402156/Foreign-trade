from datetime import datetime, timedelta
import random

tags = ['标签1', '标签2', '标签3']

start_date = datetime(2024, 4, 1)
end_date = datetime(2025, 4, 8)
delta = timedelta(days=1)

date_list = []
while start_date <= end_date:
    date_list.append(start_date.strftime('%Y-%m-%d'))
    start_date += delta

with open('2.create_and_insert.sql', 'w', encoding='utf-8') as f:
    tag_id = 1
    for tag in tags:
        factory_id = 1
        shop_id = 1
        f.write(f"INSERT INTO Tags (name, factory_id, shop_id, date) VALUES ('{tag}', {factory_id}, {shop_id}, '2024-04-01');\n")
        
        stock = random.randint(100, 200)
        for date in date_list:
            inbound = random.randint(5, 20)
            outbound = random.randint(0, inbound)
            stock += (inbound - outbound)
            f.write(f"INSERT IGNORE INTO TagLogs (tag_id, date, inbound, outbound, stock) VALUES ({tag_id}, '{date}', {inbound}, {outbound}, {stock});\n")
        
        tag_id += 1

print("SQL file '2.create_and_insert.sql' has been generated successfully!")
