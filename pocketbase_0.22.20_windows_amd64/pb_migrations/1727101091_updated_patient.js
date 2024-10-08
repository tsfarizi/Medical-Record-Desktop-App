/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db)
  const collection = dao.findCollectionByNameOrId("qldps8x8cio0k1a")

  // add
  collection.schema.addField(new SchemaField({
    "system": false,
    "id": "rbldgdpx",
    "name": "blood_pressure",
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
  const collection = dao.findCollectionByNameOrId("qldps8x8cio0k1a")

  // remove
  collection.schema.removeField("rbldgdpx")

  return dao.saveCollection(collection)
})
