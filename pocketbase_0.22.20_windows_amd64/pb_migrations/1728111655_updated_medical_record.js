/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("7fl8xsur2uintke")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "rhxhul6d",
    "name": "queue_id",
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

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("7fl8xsur2uintke")

  // remove
  collection.schema.removeField("rhxhul6d")

  return dao.saveCollection(collection)
})
