*** 放一些SQL ***
2010-6-17 删除在建活动里面没用的字段,然后新增2个字段

ALTER TABLE deco_registers DROP COLUMN receive_sms;
ALTER TABLE deco_registers DROP COLUMN interest_in_material;
ALTER TABLE deco_registers DROP COLUMN interest_in_design;
ALTER TABLE deco_registers DROP COLUMN interest_in_furniture;

ALTER TABLE deco_registers ADD COLUMN remark VARCHAR(255) COMMENT '备注';
ALTER TABLE deco_registers ADD COLUMN the_time_to_visit TINYINT COMMENT '希望参观的时间';
ALTER TABLE deco_registers ADD COLUMN sex VARCHAR(10);
--------------------------------------------------------------------------------------------

ALTER TABLE decoration_diaries ADD COLUMN ip VARCHAR(20);



ALTER TABLE decoration_diaries ADD COLUMN finished TINYINT(1) DEFAULT 0;