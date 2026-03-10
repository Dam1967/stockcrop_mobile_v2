TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`localhost` TRIGGER `after_order_status_update`\nAFTER UPDATE ON `orders`\nFOR EACH ROW\nBEGIN\n  IF OLD.status != NEW.status THEN\n    INSERT INTO `notifications` (`user_id`, `user_type`, `title`, `message`, `type`, `reference_id`)\n    VALUES (\n      NEW.customerId,\n      \'customer\',\n      \'Order Update\',\n      CONCAT(\'Your order #\', NEW.id, \' status has been updated to \'\'\', NEW.status, \'\'\'.\'),\n      \'order_update\',\n      NEW.id\n    );\n  END IF;\nEND'
sql_modes=1098907648
definers='root@localhost'
client_cs_names='utf8mb4'
connection_cl_names='utf8mb4_unicode_ci'
db_cl_names='utf8mb4_general_ci'
created=1772217543354022
