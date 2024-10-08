/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("7fl8xsur2uintke")

  // remove
  collection.schema.removeField("rhxhul6d")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "gomxh86j",
    "name": "queue_id",
    "type": "relation",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "collectionId": "r66o1ecrdpsi1nz",
      "cascadeDelete": false,
      "minSelect": null,
      "maxSelect": 1,
      "displayFields": null
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
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

  // remove
  collection.schema.removeField("gomxh86j")

  return dao.saveCollection(collection)
})
