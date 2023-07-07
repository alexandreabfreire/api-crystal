
CREATE DATABASE IF NOT EXISTS travel_plan;

use travel_plan;

drop table if exists location_temp;

drop table if exists plan_stop;

drop table if exists plan;

create table plan (id INT NOT NULL AUTO_INCREMENT, PRIMARY KEY (id));

create table plan_stop (id INT NOT NULL AUTO_INCREMENT, plan_id INT NOT NULL, location_id INT NOT NULL, PRIMARY KEY (id), FOREIGN KEY (plan_id) REFERENCES plan(id) on delete cascade);

create table location_temp (id INT NOT NULL, nome VARCHAR(200), type VARCHAR(100), dimension VARCHAR(100), popularidade INT, media DECIMAL, PRIMARY KEY (id));

