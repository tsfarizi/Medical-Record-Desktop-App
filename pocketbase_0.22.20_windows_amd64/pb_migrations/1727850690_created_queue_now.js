/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const collection = new Collection({
    "id": "r66o1ecrdpsi1nz",
    "created": "2024-10-02 06:31:30.041Z",
    "updated": "2024-10-02 06:31:30.041Z",
    "name": "queue_now",
    "type": "base",
    "system": false,
    "schema": [
      {
        "system": false,
        "id": "ia1gkifz",
        "name": "patient_id",
        "type": "relation",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "collectionId": "qldps8x8cio0k1a",
          "cascadeDelete": false,
          "minSelect": null,
          "maxSelect": null,
          "displayFields": null
        }
      },
      {
        "system": false,
        "id": "lqxlvqvq",
        "name": "date",
        "type": "date",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "min": "",
          "max": ""
        }
      }
    ],
    "indexes": [],
    "listRule": null,
    "viewRule": null,
    "createRule": null,
    "updateRule": null,
    "deleteRule": null,
    "options": {}
  });

  return Dao(db).saveCollection(collection);
}, (db) => {
  const dao = new Dao(db);
  const collection = dao.findCollectionByNameOrId("r66o1ecrdpsi1nz");

  return dao.deleteCollection(collection);
})
