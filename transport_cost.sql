CREATE TABLE transport_cost(
	region CHAR(50),
	country CHAR(50),
	port CHAR(50),
	sea_freight_cost INTEGER,
	road_transport_cost_per_km NUMERIC(10,2),
	currency VARCHAR(5),
	distance_unit CHAR(5));

ALTER TABLE public."transport_cost"
DROP COLUMN "currency", "distance_unit";

ALTER TABLE public."transport_cost"
ADD total_sea_freight_costs BIGINT;

UPDATE public."transport_cost"
SET "total_sea_freight_costs" = "sea_freight_cost"*2*4;

ALTER TABLE public."transport_cost"
ADD total_road_transport_cost BIGINT;

UPDATE public."transport_cost"
SET "total_road_transport_cost" = "road_transport_cost_per_km"*10000;

ALTER TABLE public."transport_cost"
ADD total_export_costs BIGINT;

UPDATE public."transport_cost"
SET "total_export_costs" = "total_road_transport_cost"+"total_sea_freight_costs";

CREATE TABLE transport_cost_new_order AS

SELECT "region",
		"country",
		"port",
		"sea_freight_cost",
		"total_sea_freight_costs",
		"road_transport_cost_per_km",
		"total_road_transport_cost",
		"total_export_costs"
FROM public."transport_cost";

CREATE TABLE transport_cost_per_region AS

SELECT "region",
		SUM(total_road_transport_cost) AS "total_road_transport_cost", 
		SUM(total_sea_freight_costs) AS "total_sea_freight_costs", 
		SUM(total_export_costs) AS "total_export_costs"
FROM public."transport_cost"
GROUP BY "region";



