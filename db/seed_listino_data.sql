-- Seed massivo listino (generato) da public/data/listino.json
-- Uso: importa DOPO db/schema.sql
SET NAMES utf8mb4;

-- Reset opzionale (ATTENZIONE: cancella i dati del listino).
-- Non tocca `admin_users`.
SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM prices;
DELETE FROM devices;
DELETE FROM repair_types;
DELETE FROM site_content;
DELETE FROM device_families;
ALTER TABLE prices AUTO_INCREMENT = 1;
ALTER TABLE devices AUTO_INCREMENT = 1;
ALTER TABLE repair_types AUTO_INCREMENT = 1;
ALTER TABLE site_content AUTO_INCREMENT = 1;
ALTER TABLE device_families AUTO_INCREMENT = 1;
SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO device_families (slug, label) VALUES
  ('iphone', 'iPhone'),
  ('ipad', 'iPad'),
  ('other', 'Altro')
ON DUPLICATE KEY UPDATE label=VALUES(label);
SET @fam_iphone = (SELECT id FROM device_families WHERE slug='iphone' LIMIT 1);
SET @fam_ipad  = (SELECT id FROM device_families WHERE slug='ipad'   LIMIT 1);
SET @fam_other = (SELECT id FROM device_families WHERE slug='other'  LIMIT 1);

INSERT INTO site_content (`key`, json_value) VALUES
  ('listinoMeta',   CAST(0x7b227469746f6c6f223a224c697374696e6f20417072696c652032303236222c22646973636c61696d6572223a22496d706f72746920747261736372697474692064616c206c697374696e6f20696e7465726e6f3b206c6120636f6e6665726d612061767669656e652073656d70726520696e206e65676f7a696f20646f706f206c6120646961676e6f73692067726174756974612e227d   AS JSON)),
  ('ipadListino',  CAST(0x7b226964223a2269706164222c227469746c65223a2269506164222c22626c6f636b73223a5b7b227469746f6c6f223a224169722028323031332920c2b720416972203220c2b720416972203320c2b7206d696e692034222c226e6f7461223a22436f646963692065732e2041313437342c2041313437352f37362c2041313536362c2041313536372c2041323135322c2041323132332c2041313533382c204131353530222c227269676865223a5b7b22766f6365223a22536f73746974757a696f6e6520646973706c617920284c4344202b20766574726f29222c227072657a7a6f223a2264612031343920e282ac227d2c7b22766f6365223a22536f6c6f20766574726f222c227072657a7a6f223a22646120373920e282ac227d5d7d2c7b227469746f6c6f223a2250726f20392c375c222028323031362920c2b72050726f2031302c355c2220283230313729222c226e6f7461223a2241313637332c2041313637342f37352c2041313730312c204131373039222c227269676865223a5b7b22766f6365223a22446973706c6179202f20766574726f20286c697374696e6f20417072696c65203230323629222c227072657a7a6f223a2264612031343920e282ac202f20646120373920e282ac227d5d7d2c7b227469746f6c6f223a2269506164203761e2809339612067656e20c2b7203661e2809335612067656e20c2b7203461e2809331612067656e222c226e6f7461223a2246617363652063756d756c61746976652028e282ac20313439202f20e282ac20313439202f20e282ac203939202f20e282ac203839202f20e282ac20343929222c227269676865223a5b7b22766f6365223a22466173636961207072657a7a6f20696e646963617469766120286f7264696e652064616c207069c3b920726563656e746520616c207069c3b92064617461746f206e656c20666f676c696f29222c227072657a7a6f223a2231343920e282ac20c2b72031343920e282ac20c2b720393920e282ac20c2b720383920e282ac20c2b720343920e282ac227d5d7d2c7b227469746f6c6f223a223130612067656e202832303232292057694669202f204c5445202f2043494e41222c226e6f7461223a2241323639362c2041323735372c204132373737e280934133313632222c227269676865223a5b7b22766f6365223a22566574726f202f20696e74657276656e7469202876656469206c697374696e6f20636f6d706c65746f29222c227072657a7a6f223a2264612031343920e282ac227d5d7d2c7b227469746f6c6f223a223130612067656e2028323032352920c2b7206950616420416972202f2069506164206d696e69222c226e6f7461223a2241333335342c2041333335352c20413333353620e28094207269676120c2ab69506164204169722069506164204d696e692069506164c2bb222c227269676865223a5b7b22766f6365223a224c697374696e6f20417072696c652032303236222c227072657a7a6f223a2264612031363920e282ac227d5d7d2c7b227469746f6c6f223a226d696e69203320283230313429222c226e6f7461223a2241313539392c204131363030222c227269676865223a5b7b22766f6365223a22446973706c6179222c227072657a7a6f223a2264612031313920e282ac227d2c7b22766f6365223a22536f6c6f20766574726f222c227072657a7a6f223a22646120373920e282ac227d5d7d5d7d  AS JSON))
ON DUPLICATE KEY UPDATE json_value=VALUES(json_value), text_value=NULL;
INSERT INTO site_content (`key`, text_value) VALUES
  ('altriDispositiviBody', 'Tablet Android, smartphone non Apple, Mac e PC: diagnosi gratuita in negozio e preventivo dedicato.')
ON DUPLICATE KEY UPDATE text_value=VALUES(text_value), json_value=NULL;

INSERT INTO devices (family_id, category, label, short_label, sort_order, is_active) VALUES
  (@fam_iphone, 'iphone-legacy', 'iPhone 11 Pro Max', '11 Pro Max', 0, 1),
  (@fam_iphone, 'iphone-legacy', 'iPhone 11 Pro', '11 Pro', 1, 1),
  (@fam_iphone, 'iphone-legacy', 'iPhone 11', '11', 2, 1),
  (@fam_iphone, 'iphone-legacy', 'iPhone SE (2020–2022)', 'SE (2020–2022)', 3, 1),
  (@fam_iphone, 'iphone-legacy', 'iPhone XS Max', 'XS Max', 4, 1),
  (@fam_iphone, 'iphone-legacy', 'iPhone XS', 'XS', 5, 1),
  (@fam_iphone, 'iphone-legacy', 'iPhone XR', 'XR', 6, 1),
  (@fam_iphone, 'iphone-legacy', 'iPhone X', 'X', 7, 1),
  (@fam_iphone, 'iphone-legacy', 'iPhone 8 Plus', '8 Plus', 8, 1),
  (@fam_iphone, 'iphone-legacy', 'iPhone 8', '8', 9, 1),
  (@fam_iphone, 'iphone-legacy', 'iPhone 7 Plus', '7 Plus', 10, 1),
  (@fam_iphone, 'iphone-legacy', 'iPhone 7', '7', 11, 1),
  (@fam_iphone, 'iphone-legacy', 'iPhone 6s Plus', '6s Plus', 12, 1),
  (@fam_iphone, 'iphone-legacy', 'iPhone 6s', '6s', 13, 1),
  (@fam_iphone, 'iphone-legacy', 'iPhone 6 Plus', '6 Plus', 14, 1),
  (@fam_iphone, 'iphone-legacy', 'iPhone 6', '6', 15, 1),
  (@fam_iphone, 'iphone-legacy', 'iPhone SE (1ª gen.)', 'SE (1ª gen.)', 16, 1),
  (@fam_iphone, 'iphone-legacy', 'iPhone 5s', '5s', 17, 1),
  (@fam_iphone, 'iphone-legacy', 'iPhone 5c', '5c', 18, 1),
  (@fam_iphone, 'iphone-recent', 'iPhone 16e', '16e', 0, 1),
  (@fam_iphone, 'iphone-recent', 'iPhone 16 Pro Max', '16 Pro Max', 1, 1),
  (@fam_iphone, 'iphone-recent', 'iPhone 16 Pro', '16 Pro', 2, 1),
  (@fam_iphone, 'iphone-recent', 'iPhone 16', '16', 3, 1),
  (@fam_iphone, 'iphone-recent', 'iPhone 16 Plus', '16 Plus', 4, 1),
  (@fam_iphone, 'iphone-recent', 'iPhone 15 Pro Max', '15 Pro Max', 5, 1),
  (@fam_iphone, 'iphone-recent', 'iPhone 15 Pro', '15 Pro', 6, 1),
  (@fam_iphone, 'iphone-recent', 'iPhone 15', '15', 7, 1),
  (@fam_iphone, 'iphone-recent', 'iPhone 15 Plus', '15 Plus', 8, 1),
  (@fam_iphone, 'iphone-recent', 'iPhone 14 Pro Max', '14 Pro Max', 9, 1),
  (@fam_iphone, 'iphone-recent', 'iPhone 14 Pro', '14 Pro', 10, 1),
  (@fam_iphone, 'iphone-recent', 'iPhone 14', '14', 11, 1),
  (@fam_iphone, 'iphone-recent', 'iPhone 14 Plus', '14 Plus', 12, 1),
  (@fam_iphone, 'iphone-recent', 'iPhone 13 Pro Max', '13 Pro Max', 13, 1),
  (@fam_iphone, 'iphone-recent', 'iPhone 13 Pro', '13 Pro', 14, 1),
  (@fam_iphone, 'iphone-recent', 'iPhone 13', '13', 15, 1),
  (@fam_iphone, 'iphone-recent', 'iPhone 13 mini', '13 mini', 16, 1),
  (@fam_iphone, 'iphone-recent', 'iPhone 12 Pro Max', '12 Pro Max', 17, 1),
  (@fam_iphone, 'iphone-recent', 'iPhone 12 / iPhone 12 Pro', '12 / 12 Pro', 18, 1),
  (@fam_iphone, 'iphone-recent', 'iPhone 12 mini', '12 mini', 19, 1)
ON DUPLICATE KEY UPDATE
  family_id=VALUES(family_id),
  short_label=VALUES(short_label),
  sort_order=VALUES(sort_order),
  is_active=VALUES(is_active);

INSERT INTO repair_types (`key`, label, scope, sort_order, is_active) VALUES
  ('lcd', 'LCD + vetro', 'iphone', 0, 1),
  ('vetroPost', 'Vetro posteriore', 'iphone', 1, 1),
  ('batteria', 'Batteria', 'iphone', 2, 1),
  ('dock', 'Dock di ricarica', 'iphone', 3, 1),
  ('speaker', 'Cassa speaker / altoparlante', 'iphone', 4, 1),
  ('earpiece', 'Cassa vivavoce / suoneria', 'iphone', 5, 1)
ON DUPLICATE KEY UPDATE
  label=VALUES(label),
  sort_order=VALUES(sort_order),
  is_active=VALUES(is_active);

INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 119, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-legacy' AND d.label='iPhone 11 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 99, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-legacy' AND d.label='iPhone 11 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-legacy' AND d.label='iPhone 11'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-legacy' AND d.label='iPhone SE (2020–2022)'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 99, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-legacy' AND d.label='iPhone XS Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 79, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-legacy' AND d.label='iPhone XS'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-legacy' AND d.label='iPhone XR'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 79, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-legacy' AND d.label='iPhone X'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 79, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-legacy' AND d.label='iPhone 8 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 79, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-legacy' AND d.label='iPhone 8'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 79, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-legacy' AND d.label='iPhone 7 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 69, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-legacy' AND d.label='iPhone 7'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 49, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-legacy' AND d.label='iPhone 6s Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 49, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-legacy' AND d.label='iPhone 6s'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 49, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-legacy' AND d.label='iPhone 6 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 49, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-legacy' AND d.label='iPhone 6'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 49, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-legacy' AND d.label='iPhone SE (1ª gen.)'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 49, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-legacy' AND d.label='iPhone 5s'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 49, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-legacy' AND d.label='iPhone 5c'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-legacy' AND d.label='iPhone 11 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-legacy' AND d.label='iPhone 11 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-legacy' AND d.label='iPhone 11'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 79, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-legacy' AND d.label='iPhone SE (2020–2022)'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 79, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-legacy' AND d.label='iPhone XS Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 79, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-legacy' AND d.label='iPhone XS'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 79, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-legacy' AND d.label='iPhone XR'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 79, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-legacy' AND d.label='iPhone X'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 79, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-legacy' AND d.label='iPhone 8 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 79, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-legacy' AND d.label='iPhone 8'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 29, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-legacy' AND d.label='iPhone 7 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 29, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-legacy' AND d.label='iPhone 7'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-legacy' AND d.label='iPhone 6s Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-legacy' AND d.label='iPhone 6s'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-legacy' AND d.label='iPhone 6 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-legacy' AND d.label='iPhone 6'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-legacy' AND d.label='iPhone SE (1ª gen.)'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-legacy' AND d.label='iPhone 5s'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-legacy' AND d.label='iPhone 5c'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 59, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-legacy' AND d.label='iPhone 11 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 59, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-legacy' AND d.label='iPhone 11 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 59, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-legacy' AND d.label='iPhone 11'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 59, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-legacy' AND d.label='iPhone SE (2020–2022)'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 59, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-legacy' AND d.label='iPhone XS Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 49, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-legacy' AND d.label='iPhone XS'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 59, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-legacy' AND d.label='iPhone XR'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 49, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-legacy' AND d.label='iPhone X'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 49, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-legacy' AND d.label='iPhone 8 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 49, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-legacy' AND d.label='iPhone 8'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 49, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-legacy' AND d.label='iPhone 7 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 49, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-legacy' AND d.label='iPhone 7'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 49, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-legacy' AND d.label='iPhone 6s Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 39, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-legacy' AND d.label='iPhone 6s'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 39, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-legacy' AND d.label='iPhone 6 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 39, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-legacy' AND d.label='iPhone 6'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 49, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-legacy' AND d.label='iPhone SE (1ª gen.)'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 39, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-legacy' AND d.label='iPhone 5s'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 29, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-legacy' AND d.label='iPhone 5c'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 69, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-legacy' AND d.label='iPhone 11 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 69, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-legacy' AND d.label='iPhone 11 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 69, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-legacy' AND d.label='iPhone 11'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 69, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-legacy' AND d.label='iPhone SE (2020–2022)'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 69, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-legacy' AND d.label='iPhone XS Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 69, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-legacy' AND d.label='iPhone XS'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 69, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-legacy' AND d.label='iPhone XR'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 69, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-legacy' AND d.label='iPhone X'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 69, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-legacy' AND d.label='iPhone 8 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 69, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-legacy' AND d.label='iPhone 8'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 69, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-legacy' AND d.label='iPhone 7 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 69, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-legacy' AND d.label='iPhone 7'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 39, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-legacy' AND d.label='iPhone 6s Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 39, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-legacy' AND d.label='iPhone 6s'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 39, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-legacy' AND d.label='iPhone 6 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 39, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-legacy' AND d.label='iPhone 6'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 39, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-legacy' AND d.label='iPhone SE (1ª gen.)'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 39, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-legacy' AND d.label='iPhone 5s'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 39, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-legacy' AND d.label='iPhone 5c'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 59, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-legacy' AND d.label='iPhone 11 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 59, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-legacy' AND d.label='iPhone 11 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 59, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-legacy' AND d.label='iPhone 11'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 49, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-legacy' AND d.label='iPhone SE (2020–2022)'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 59, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-legacy' AND d.label='iPhone XS Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 59, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-legacy' AND d.label='iPhone XS'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 59, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-legacy' AND d.label='iPhone XR'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 59, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-legacy' AND d.label='iPhone X'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 49, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-legacy' AND d.label='iPhone 8 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 49, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-legacy' AND d.label='iPhone 8'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 49, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-legacy' AND d.label='iPhone 7 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 49, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-legacy' AND d.label='iPhone 7'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 39, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-legacy' AND d.label='iPhone 6s Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 39, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-legacy' AND d.label='iPhone 6s'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 39, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-legacy' AND d.label='iPhone 6 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 39, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-legacy' AND d.label='iPhone 6'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 39, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-legacy' AND d.label='iPhone SE (1ª gen.)'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 39, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-legacy' AND d.label='iPhone 5s'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 39, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-legacy' AND d.label='iPhone 5c'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 59, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-legacy' AND d.label='iPhone 11 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 59, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-legacy' AND d.label='iPhone 11 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 59, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-legacy' AND d.label='iPhone 11'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 49, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-legacy' AND d.label='iPhone SE (2020–2022)'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 59, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-legacy' AND d.label='iPhone XS Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 59, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-legacy' AND d.label='iPhone XS'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 59, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-legacy' AND d.label='iPhone XR'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 59, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-legacy' AND d.label='iPhone X'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 49, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-legacy' AND d.label='iPhone 8 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 49, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-legacy' AND d.label='iPhone 8'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 49, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-legacy' AND d.label='iPhone 7 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 49, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-legacy' AND d.label='iPhone 7'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 39, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-legacy' AND d.label='iPhone 6s Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 39, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-legacy' AND d.label='iPhone 6s'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 39, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-legacy' AND d.label='iPhone 6 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 39, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-legacy' AND d.label='iPhone 6'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 39, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-legacy' AND d.label='iPhone SE (1ª gen.)'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 39, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-legacy' AND d.label='iPhone 5s'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 39, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-legacy' AND d.label='iPhone 5c'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 199, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-recent' AND d.label='iPhone 16e'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 329, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-recent' AND d.label='iPhone 16 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 249, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-recent' AND d.label='iPhone 16 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 199, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-recent' AND d.label='iPhone 16'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 219, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-recent' AND d.label='iPhone 16 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 329, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-recent' AND d.label='iPhone 15 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 249, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-recent' AND d.label='iPhone 15 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 199, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-recent' AND d.label='iPhone 15'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 219, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-recent' AND d.label='iPhone 15 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 229, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-recent' AND d.label='iPhone 14 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 199, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-recent' AND d.label='iPhone 14 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 149, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-recent' AND d.label='iPhone 14'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 139, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-recent' AND d.label='iPhone 14 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 149, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-recent' AND d.label='iPhone 13 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 129, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-recent' AND d.label='iPhone 13 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 119, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-recent' AND d.label='iPhone 13'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-recent' AND d.label='iPhone 13 mini'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-recent' AND d.label='iPhone 12 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-recent' AND d.label='iPhone 12 / iPhone 12 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='lcd'
WHERE d.category='iphone-recent' AND d.label='iPhone 12 mini'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-recent' AND d.label='iPhone 16e'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-recent' AND d.label='iPhone 16 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-recent' AND d.label='iPhone 16 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-recent' AND d.label='iPhone 16'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-recent' AND d.label='iPhone 16 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-recent' AND d.label='iPhone 15 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-recent' AND d.label='iPhone 15 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-recent' AND d.label='iPhone 15'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-recent' AND d.label='iPhone 15 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 139, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-recent' AND d.label='iPhone 14 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 139, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-recent' AND d.label='iPhone 14 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-recent' AND d.label='iPhone 14'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-recent' AND d.label='iPhone 14 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 129, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-recent' AND d.label='iPhone 13 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 129, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-recent' AND d.label='iPhone 13 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 129, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-recent' AND d.label='iPhone 13'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 129, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-recent' AND d.label='iPhone 13 mini'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 119, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-recent' AND d.label='iPhone 12 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 119, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-recent' AND d.label='iPhone 12 / iPhone 12 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 119, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='vetroPost'
WHERE d.category='iphone-recent' AND d.label='iPhone 12 mini'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-recent' AND d.label='iPhone 16e'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-recent' AND d.label='iPhone 16 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-recent' AND d.label='iPhone 16 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-recent' AND d.label='iPhone 16'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-recent' AND d.label='iPhone 16 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-recent' AND d.label='iPhone 15 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-recent' AND d.label='iPhone 15 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-recent' AND d.label='iPhone 15'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 79, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-recent' AND d.label='iPhone 15 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 79, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-recent' AND d.label='iPhone 14 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 79, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-recent' AND d.label='iPhone 14 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 79, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-recent' AND d.label='iPhone 14'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 69, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-recent' AND d.label='iPhone 14 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 69, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-recent' AND d.label='iPhone 13 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 69, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-recent' AND d.label='iPhone 13 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-recent' AND d.label='iPhone 13'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-recent' AND d.label='iPhone 13 mini'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-recent' AND d.label='iPhone 12 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-recent' AND d.label='iPhone 12 / iPhone 12 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='batteria'
WHERE d.category='iphone-recent' AND d.label='iPhone 12 mini'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 129, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-recent' AND d.label='iPhone 16e'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 129, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-recent' AND d.label='iPhone 16 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 129, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-recent' AND d.label='iPhone 16 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 129, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-recent' AND d.label='iPhone 16'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 129, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-recent' AND d.label='iPhone 16 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 99, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-recent' AND d.label='iPhone 15 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 99, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-recent' AND d.label='iPhone 15 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 99, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-recent' AND d.label='iPhone 15'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 99, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-recent' AND d.label='iPhone 15 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-recent' AND d.label='iPhone 14 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-recent' AND d.label='iPhone 14 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-recent' AND d.label='iPhone 14'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-recent' AND d.label='iPhone 14 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-recent' AND d.label='iPhone 13 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-recent' AND d.label='iPhone 13 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-recent' AND d.label='iPhone 13'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-recent' AND d.label='iPhone 13 mini'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-recent' AND d.label='iPhone 12 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-recent' AND d.label='iPhone 12 / iPhone 12 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='dock'
WHERE d.category='iphone-recent' AND d.label='iPhone 12 mini'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 99, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-recent' AND d.label='iPhone 16e'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-recent' AND d.label='iPhone 16 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-recent' AND d.label='iPhone 16 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-recent' AND d.label='iPhone 16'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-recent' AND d.label='iPhone 16 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-recent' AND d.label='iPhone 15 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-recent' AND d.label='iPhone 15 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-recent' AND d.label='iPhone 15'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-recent' AND d.label='iPhone 15 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-recent' AND d.label='iPhone 14 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-recent' AND d.label='iPhone 14 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-recent' AND d.label='iPhone 14'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-recent' AND d.label='iPhone 14 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-recent' AND d.label='iPhone 13 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-recent' AND d.label='iPhone 13 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-recent' AND d.label='iPhone 13'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-recent' AND d.label='iPhone 13 mini'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-recent' AND d.label='iPhone 12 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-recent' AND d.label='iPhone 12 / iPhone 12 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='speaker'
WHERE d.category='iphone-recent' AND d.label='iPhone 12 mini'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 99, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-recent' AND d.label='iPhone 16e'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-recent' AND d.label='iPhone 16 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-recent' AND d.label='iPhone 16 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-recent' AND d.label='iPhone 16'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 89, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-recent' AND d.label='iPhone 16 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 79, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-recent' AND d.label='iPhone 15 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 79, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-recent' AND d.label='iPhone 15 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 79, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-recent' AND d.label='iPhone 15'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 79, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-recent' AND d.label='iPhone 15 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 79, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-recent' AND d.label='iPhone 14 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 79, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-recent' AND d.label='iPhone 14 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 79, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-recent' AND d.label='iPhone 14'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 79, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-recent' AND d.label='iPhone 14 Plus'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 69, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-recent' AND d.label='iPhone 13 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 69, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-recent' AND d.label='iPhone 13 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, 69, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-recent' AND d.label='iPhone 13'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-recent' AND d.label='iPhone 13 mini'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-recent' AND d.label='iPhone 12 Pro Max'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-recent' AND d.label='iPhone 12 / iPhone 12 Pro'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);
INSERT INTO prices (device_id, repair_type_id, price_eur, is_active)
SELECT d.id, r.id, NULL, 1
FROM devices d
JOIN repair_types r ON r.scope='iphone' AND r.`key`='earpiece'
WHERE d.category='iphone-recent' AND d.label='iPhone 12 mini'
ON DUPLICATE KEY UPDATE price_eur=VALUES(price_eur), is_active=VALUES(is_active);

