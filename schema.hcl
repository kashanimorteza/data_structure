schema "public" {}

table "users" {
  schema = schema.public
  column "id"        { type = uuid;  null = false; default = sql("gen_random_uuid()") }
  column "email"     { type = varchar(255); null = false }
  column "full_name" { type = varchar(200) }
  column "is_active" { type = bool; null = false; default = true }
  column "created_at"{ type = timestamp; null = false; default = sql("CURRENT_TIMESTAMP") }
  primary_key { columns = [column.id] }
  index "idx_users_email" { unique = true, columns = [column.email] }
}

table "posts" {
  schema = schema.public
  column "id"         { type = bigint; null = false }
  column "user_id"    { type = uuid;   null = false }
  column "title"      { type = varchar(300); null = false }
  column "body"       { type = text }
  column "created_at" { type = timestamp; null = false; default = sql("CURRENT_TIMESTAMP") }
  primary_key { columns = [column.id] }
  foreign_key "fk_posts_user" {
    columns     = [column.user_id]
    ref_columns = [table.users.column.id]
    on_delete   = CASCADE
  }
}
