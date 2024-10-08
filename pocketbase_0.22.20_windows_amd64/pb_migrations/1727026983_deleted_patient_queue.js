/// <reference path="../pb_data/types.d.ts" />
migrate((db) => {
  const dao = new Dao(db);
  const collection = dao.findCollectionByNameOrId("n4t0zvsut6r96ky");

  return dao.deleteCollection(collection);
}, (db) => {
  const collection = new Collection({
    "id": "n4t0zvsut6r96ky",
    "created": "2024-09-22 17:42:02.845Z",
    "updated": "2024-09-22 17:42:02.845Z",
    "name": "patient_queue",
    "type": "view",
    "system": false,
    "schema": [
      {
        "system": false,
        "id": "g6qmurwq",
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
      },
      {
        "system": false,
        "id": "dmbdztvu",
        "name": "full_name",
        "type": "text",
        "required": true,
        "presentable": false,
        "unique": false,
        "options": {
          "min": null,
          "max": null,
          "pattern": ""
        }
      },
      {
        "system": false,
        "id": "vrvcnac1",
        "name": "phone",
        "type": "text",
        "required": false,
        "presentable": false,
        "unique": false,
        "options": {
          "min": null,
          "max": null,
          "pattern": ""
        }
      }
    ],
    "indexes": [],
    "listRule": null,
    "viewRule": null,
    "createRule": null,
    "updateRule": null,
    "deleteRule": null,
    "options": {
      "query": "SELECT registration_number,full_name,phone,id FROM patient;"
    }
  });

  return Dao(db).saveCollection(collection);
})
