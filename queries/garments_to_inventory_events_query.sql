INSERT INTO `INVENTORY_EVENTS_TABLE`

With create_events as (
  SELECT *
  FROM
    `rental-dev.test_garment_to_inventory_events.garment_events`
  WHERE
    event_subtype IN ("garment_event","garment_create")
    AND locationId IS NOT NULL and locationDesc IS NOT NULL
)

(
  SELECT
    create_event.poId AS po_id,
    delete_event.id AS garment_id,
    create_event.skuId AS sku_id,
    delete_event.event_type,
    delete_event.event_subtype,
    delete_event.event_datetime,
    -create_event.cost AS unit_cost,
    create_event.locationid AS location_id,
    create_event.locationdesc AS location_desc,
    8 AS expected_rentals,
    -1 AS quantity_received
  FROM
    (
      SELECT *
      FROM
        `rental-dev.test_garment_to_inventory_events.garment_events`
      WHERE
        event_subtype =("garment_delete") 
        AND locationId IS NOT NULL and locationDesc IS NOT NULL
    ) as delete_event
  LEFT JOIN 
    create_events as create_event
  ON delete_event.id = create_event.id
)
UNION ALL
(
  SELECT
    create_event.poId AS po_id,
    create_event.id AS garment_id,
    create_event.skuId AS sku_id,
    create_event.event_type,
    create_event.event_subtype,
    create_event.event_datetime,
    create_event.cost AS unit_cost,
    create_event.locationid AS location_id,
    create_event.locationdesc AS location_desc,
    8 AS expected_rentals,
    1 AS quantity_received
  FROM 
      create_events as create_event 
)