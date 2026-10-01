-- Add eight fictional demo products. Prices, stock and specifications are samples.
-- Safe to rerun: existing rows, stock, orders and customers are not changed.
BEGIN;
INSERT INTO public.products (id,name,category,price,old_price,tag,description,specs,image,stock) VALUES
('orbit-watch','Orbit Smartwatch','Wearables',48500,0,'New arrival','A little more movement, a little more connection. A lightweight everyday smartwatch for activity tracking and notifications.','["Activity tracking", "Phone notifications", "Adjustable silicone strap"]','/products/orbit-watch.svg',18),
('charge-powerbank','Charge Power Bank','Accessories',32000,0,'New arrival','Keep your essentials powered while you are out. A compact portable battery for commutes and busy days.','["10,000 mAh capacity", "USB-C charging", "Battery level display"]','/products/charge-powerbank.svg',30),
('arc-controller','Arc Gamepad','Gaming',39500,0,'New arrival','Settle into your next session with a comfortable controller built for responsive everyday play.','["Wireless connectivity", "Dual analogue sticks", "USB-C charging"]','/products/arc-controller.svg',16),
('focus-webcam','Focus Webcam','Workspace',36500,0,'New arrival','Show up clearly for meetings, lessons, and catch-ups with a compact webcam that sits neatly above your screen.','["1080p video", "Built-in microphone", "Adjustable monitor clip"]','/products/focus-webcam.svg',20),
('lift-laptop-stand','Lift Laptop Stand','Workspace',22500,0,'New arrival','Give your screen a comfortable lift and your desk a little breathing room with a foldable laptop stand.','["Adjustable angle", "Foldable aluminium frame", "Non-slip contact pads"]','/products/lift-laptop-stand.svg',28),
('spark-wall-charger','Spark USB-C Charger','Accessories',19500,0,'New arrival','A compact charging companion for your desk or travel bag, with a convenient USB-C connection.','["30W USB-C output", "Compact design", "UK-style three-pin plug"]','/products/spark-wall-charger.svg',40),
('vault-portable-ssd','Vault Portable SSD','Accessories',89000,0,'New arrival','Keep projects, photos, and everyday files close with a pocket-sized portable drive.','["512 GB storage", "USB-C connection", "Compact metal enclosure"]','/products/vault-portable-ssd.svg',14),
('beam-desk-light','Beam Desk Light','Workspace',27500,0,'New arrival','Set the mood for focused work or a quiet evening with a slim, adjustable desk light.','["Three light modes", "Adjustable arm", "USB powered"]','/products/beam-desk-light.svg',22)
ON CONFLICT (id) DO NOTHING;
COMMIT;
