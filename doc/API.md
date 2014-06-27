The API of collisterator (V1)
=============================

### Rest Commands

#### GET /api/v1/list/<id>[?depth=<depth>]

Retrieves subtree starting with node <id>

#### PUT /api/v1/list/<id>

Updates node <id>

#### DELETE /api/v1/list/<id>

Deletes node <id>

#### POST /api/v1/list/<id>/children

Creates a new childnode of node <id> and validates content against list_type

### Special Commands

#### POST /api/v1/list/<id>/<field_name>/upvote
#### POST /api/v1/list/<id>/<field_name>/downvote

Up- or Downvotes an item





