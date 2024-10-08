/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("qldps8x8cio0k1a")

  // remove
  collection.schema.removeField("syrnd7tz")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "amamoktq",
    "name": "gender",
    "type": "text",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "min": null,
      "max": null,
      "pattern": ""
    }
  }))

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
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("qldps8x8cio0k1a")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "syrnd7tz",
    "name": "gender",
    "type": "bool",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {}
  }))

  // remove
  collection.schema.removeField("amamoktq")

  // update
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "a4rjwwmv",
    "name": "register_number",
    "type": "number",
    "required": true,
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
