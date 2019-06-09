INSERT INTO `INVENTORY_EVENTS_TABLE`

With create_events as (
  SELECT skuId, receivedDate, poId, cost, id, fingerprint, 
      CASE 
        WHEN locationId IS NULL THEN "NOT_FOUND"
        ELSE  locationId
      END as locationId,
      CASE 
        WHEN locationDesc IS NULL THEN "NOT_FOUND"
        ELSE locationDesc
      END as locationDesc ,
      event_type, event_subtype, event_datetime
  FROM
    `GARMENT_EVENTS_TABLE`
  WHERE
    event_subtype IN ("garment_event","garment_create")
)

(
  SELECT
    create_event.poId AS po_id,
    delete_event.id AS garment_id,
    create_event.skuId AS sku_id,
    "GARMENT_DELETE" as event_type,
    "GARMENT_DELETE" as event_subtype,
    delete_event.event_datetime,
    -create_event.cost AS unit_cost,
    create_event.locationid AS location_id,
    create_event.locationdesc AS location_desc,
    8 AS expected_rentals,
    -1 AS quantity_received
  FROM
    (
      SELECT skuId, receivedDate, poId, cost, id, fingerprint, 
      CASE 
        WHEN locationId IS NULL THEN "NOT_FOUND"
        ELSE  locationId
      END as locationId,
      CASE 
        WHEN locationDesc IS NULL THEN "NOT_FOUND"
        ELSE locationDesc
      END as locationDesc ,
      event_type, event_subtype, event_datetime
      FROM
        `GARMENT_EVENTS_TABLE`
      WHERE
        event_subtype =("garment_delete") 
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
    "INITIAL_RECEIPT" as event_type,
    "GARMENT_CREATE" as event_subtype,
    create_event.event_datetime,
    create_event.cost AS unit_cost,
    create_event.locationid AS location_id,
    create_event.locationdesc AS location_desc,
    8 AS expected_rentals,
    1 AS quantity_received
  FROM 
      create_events as create_event 
)