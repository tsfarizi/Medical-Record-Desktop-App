/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("qldps8x8cio0k1a")

  // update
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "a4rjwwmv",
    "name": "registration_number",
    "type": "number",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "min": null,
      "max": null,
      "noDecimal": true
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("qldps8x8cio0k1a")

  // update
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "a4rjwwmv",
    "name": "register_number",
    "type": "number",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "min": null,
      "max": null,
      "noDecimal": true
    }
  }))

  return dao.saveCollection(collection)
})
