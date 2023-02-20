
DELETE FROM `templates` WHERE id='telegram_bot';
INSERT INTO `templates` VALUES ('telegram_bot','<% SWITCH cmd %>\n<% CASE \'USER_NOT_FOUND\' %>\n{\n    \"sendMessage\": {\n        \"text\": \"Для работы с Telegram ботом укажите _Telegram логин_ в профиле личного кабинета.\\n\\n*Telegram логин*: {{ message.chat.username }}\\n\\n*Кабинет пользователя*: {{ config.cli.url }}\"\n    }\n}\n<% CASE [\'/start\', \'/menu\'] %>\n{{ IF cmd == \'/menu\' }}\n{\n    \"deleteMessage\": { \"message_id\": {{ message.message_id }} }\n},\n{{ END }}\n{\n    \"sendMessage\": {\n        \"text\": \"Создавайте и управляйте своими VPN ключами\",\n        \"reply_markup\": {\n            \"inline_keyboard\": [\n                [\n                    {\n                        \"text\": \"💰 Баланс\",\n                        \"callback_data\": \"/balance\"\n                    }\n                ],\n                [\n                    {\n                        \"text\": \"🗝  Ключи\",\n                        \"callback_data\": \"/list\"\n                    }\n                ]\n            ]\n        }\n    }\n}\n<% CASE \'/balance\' %>\n{\n    \"deleteMessage\": { \"message_id\": {{ message.message_id }} }\n},\n{\n    \"sendMessage\": {\n        \"text\": \"💰 *Баланс*: {{ user.balance }}\\n\\nНеобходимо оплатить: * {{ user.pays.forecast.total }}*\",\n        \"reply_markup\" : {\n            \"inline_keyboard\": [\n                [\n                    {\n                        \"text\": \"⇦ Назад\",\n                        \"callback_data\": \"/menu\"\n                    }\n                ]\n            ]\n        }\n    }\n}\n<% CASE \'/list\' %>\n{\n    \"deleteMessage\": { \"message_id\": {{ message.message_id }} }\n},\n{\n    \"sendMessage\": {\n        \"text\": \"🗝  Ключи\",\n        \"reply_markup\" : {\n            \"inline_keyboard\": [\n                {{ FOR item IN user.services.list_for_api( \'category\', \'%\' ) }}\n                {{ SWITCH item.status }}\n                  {{ CASE \'ACTIVE\' }}\n                  {{ status = \'✅\' }}\n                  {{ CASE \'BLOCK\' }}\n                  {{ status = \'❌\' }}\n                  {{ CASE \'NOT PAID\' }}\n                  {{ status = \'💰\' }}\n                  {{ CASE }}\n                  {{ status = \'⏳\' }}\n                {{ END }}\n                [\n                    {\n                        \"text\": \"{{ status }} - {{ item.name }}\",\n                        \"callback_data\": \"/service {{ item.user_service_id }}\"\n                    }\n                ],\n                {{ END }}\n                [\n                    {\n                        \"text\": \"⇦ Назад\",\n                        \"callback_data\": \"/menu\"\n                    }\n                ]\n            ]\n        }\n    }\n}\n<% CASE \'/service\' %>\n{{ us = user.services.list_for_api( \'usi\', args.0 ) }}\n{\n    \"deleteMessage\": { \"message_id\": {{ message.message_id }} }\n},\n{\n    \"sendMessage\": {\n        \"text\": \"*Ключ*: {{ us.name }}\\n\\n*Оплачен до*: {{ us.expire }}\\n\\n*Статус*: {{ us.status }}\",\n        \"reply_markup\" : {\n            \"inline_keyboard\": [\n                {{ IF us.status == \'ACTIVE\' }}\n                [\n                    {\n                        \"text\": \"🗝  Скачать ключ\",\n                        \"callback_data\": \"/download_qr {{ args.0 }}\"\n                    },\n                    {\n                        \"text\": \"👀 Показать QR код\",\n                        \"callback_data\": \"/show_qr {{ args.0 }}\"\n                    }\n                ],\n                {{ END }}\n                [\n                    {\n                        \"text\": \"⇦ Назад\",\n                        \"callback_data\": \"/list\"\n                    }\n                ]\n            ]\n        }\n    }\n}\n<% CASE \'/download_qr\' %>\n{\n    \"uploadDocumentFromStorage\": {\n        \"name\": \"vpn{{ args.0 }}\",\n        \"filename\": \"vpn{{ args.0 }}.txt\"\n    }\n}\n<% CASE \'/show_qr\' %>\n{\n    \"uploadPhotoFromStorage\": {\n        \"name\": \"vpn{{ args.0 }}\",\n        \"format\": \"qr_code_png\"\n    }\n}\n<% END %>\n\n',NULL);
