/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("qldps8x8cio0k1a")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "srjq2tmn",
    "name": "record",
    "type": "relation",
    "required": false,
    "presentable": false,
    "unique": false,
    "options": {
      "collectionId": "7fl8xsur2uintke",
      "cascadeDelete": false,
      "minSelect": null,
      "maxSelect": null,
      "displayFields": null
    }
  }))

  return dao.saveCollection(collection)
}, (db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("qldps8x8cio0k1a")

  // remove
  collection.schema.removeField("srjq2tmn")

  return dao.saveCollection(collection)
})
