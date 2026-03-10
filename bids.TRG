TYPE=TRIGGERS
triggers='CREATE DEFINER=`root`@`localhost` TRIGGER `after_bid_status_update`\nAFTER UPDATE ON `bids`\nFOR EACH ROW\nBEGIN\n  IF OLD.status != NEW.status AND NEW.status IN (\'Accepted\', \'Rejected\') THEN\n    INSERT INTO `notifications` (`user_id`, `user_type`, `title`, `message`, `type`, `reference_id`)\n    VALUES (\n      NEW.customerId,\n      \'customer\',\n      CONCAT(\'Bid \', NEW.status),\n      CONCAT(\'Your bid of $\', FORMAT(NEW.bidAmount, 2), \' on product #\', NEW.productId, \' has been \', LOWER(NEW.status), \'.\'),\n      \'bid_update\',\n      NEW.id\n    );\n  END IF;\nEND'
sql_modes=1098907648
definers='root@localhost'
client_cs_names='utf8mb4'
connection_cl_names='utf8mb4_unicode_ci'
db_cl_names='utf8mb4_general_ci'
created=1772235011523135
