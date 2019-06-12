INSERT INTO
  `INVENTORY_EVENTS_TABLE`
WITH
  create_events AS (
  SELECT
    skuId,
    receivedDate,
    poId,
    cost,
    id,
    fingerprint,
    CASE
      WHEN locationId IS NULL THEN "NOT_FOUND"
    ELSE
    locationId
  END
    AS locationId,
    CASE
      WHEN locationDesc IS NULL THEN "NOT_FOUND"
    ELSE
    locationDesc
  END
    AS locationDesc,
    event_type,
    event_subtype,
    event_datetime
  FROM
    `GARMENT_EVENTS_TABLE`
  WHERE
    event_subtype IN ("garment_event",
      "garment_create") ) (
  SELECT
    create_event.poId AS po_id,
    delete_event.id AS garment_id,
    create_event.skuId AS sku_id,
    "GARMENT_DELETE" AS event_type,
    "GARMENT_DELETE" AS event_subtype,
    delete_event.event_datetime,
    -create_event.cost AS unit_cost,
    create_event.locationid AS location_id,
    create_event.locationdesc AS location_desc,
    8 AS expected_rentals,
    -1 AS quantity_received
  FROM (
    SELECT
      skuId,
      receivedDate,
      poId,
      cost,
      id,
      fingerprint,
      CASE
        WHEN locationId IS NULL THEN "NOT_FOUND"
      ELSE
      locationId
    END
      AS locationId,
      CASE
        WHEN locationDesc IS NULL THEN "NOT_FOUND"
      ELSE
      locationDesc
    END
      AS locationDesc,
      event_type,
      event_subtype,
      event_datetime
    FROM
      `GARMENT_EVENTS_TABLE`
    WHERE
      event_subtype =("garment_delete") ) AS delete_event
  LEFT JOIN
    create_events AS create_event
  ON
    delete_event.id = create_event.id )
UNION ALL (
  SELECT
    create_event.poId AS po_id,
    create_event.id AS garment_id,
    create_event.skuId AS sku_id,
    "INITIAL_RECEIPT" AS event_type,
    "GARMENT_CREATE" AS event_subtype,
    create_event.event_datetime,
    create_event.cost AS unit_cost,
    create_event.locationid AS location_id,
    create_event.locationdesc AS location_desc,
    8 AS expected_rentals,
    1 AS quantity_received
  FROM
    create_events AS create_event )