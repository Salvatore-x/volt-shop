-- Fictional assignment catalog. Photos are illustrative.
INSERT INTO public.products (id,name,category,price,old_price,tag,description,specs,image,stock) VALUES
('pulse-headphones','Pulse Wireless','Audio',68500,80000,'Bestseller','Find your focus. Over-ear wireless headphones with soft cushions, active noise cancellation, and up to 40 hours of listening.','["40-hour battery","Active noise cancellation","USB-C charging"]','/products/headphones.jpg',24),
('air-earbuds','Air Buds Pro','Audio',42500,0,'New arrival','Big sound, small footprint. Lightweight wireless earbuds made for your commute, calls, and everything in between.','["24 hours with case","Touch controls","Splash resistant"]','/products/earbuds.jpg',35),
('key-keyboard','Key Mechanical','Workspace',55000,65000,'','Make every keystroke count. A compact mechanical keyboard with a satisfying feel and a clean desktop footprint.','["Compact layout","Tactile switches","Wired USB-C"]','/products/keyboard.jpg',18),
('roam-speaker','Roam Speaker','Audio',38000,0,'','Your soundtrack, wherever you go. A compact Bluetooth speaker with rich sound and a rugged, travel-ready design.','["12-hour battery","Bluetooth 5.3","Portable design"]','/products/speaker.jpg',20),
('link-hub','Link USB-C Hub','Accessories',28500,0,'','One connection. More possibilities. Expand your laptop with the ports you need for a productive day.','["6-in-1 connectivity","HDMI output","USB-C power delivery"]','/products/hub.jpg',40),
('glide-mouse','Glide Wireless','Workspace',24000,30000,'Everyday essential','A smoother way to work. A comfortable wireless mouse with precise tracking and quiet clicks.','["Quiet clicks","Adjustable sensitivity","Wireless connection"]','/products/mouse.jpg',30)
ON CONFLICT (id) DO NOTHING;
