CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" varchar NOT NULL PRIMARY KEY);
CREATE TABLE IF NOT EXISTS "ar_internal_metadata" ("key" varchar NOT NULL PRIMARY KEY, "value" varchar, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "consumables" (
	"id"	INTEGER NOT NULL,
	"name"	TEXT,
	"description"	TEXT,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "elements" (
	"id"	INTEGER,
	"name"	TEXT,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "moves" (
	"id"	INTEGER,
	"name"	TEXT,
	"power"	INTEGER,
	"element_id"	INTEGER,
	"description"	TEXT,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "equipables" (
	"id"	INTEGER,
	"name"	TEXT,
	"element_id"	INTEGER,
	"move_id"	INTEGER,
	"description"	TEXT,
	PRIMARY KEY("id"),
	FOREIGN KEY("element_id") REFERENCES "elements"("id"),
	FOREIGN KEY("move_id") REFERENCES "moves"("id")
);
CREATE TABLE IF NOT EXISTS "monsters" (
	"id"	INTEGER,
	"name"	TEXT,
	"healthpoints"	INTEGER,
	"element_id"	INTEGER,
	"move_id"	INTEGER, "cooldown" integer,
	FOREIGN KEY("element_id") REFERENCES "elements"("id"),
	FOREIGN KEY("move_id") REFERENCES "moves"("id"),
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "cards" (
	"id"	INTEGER,
	"cardtype"	INTEGER,
	"foreign_id"	INTEGER,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "users" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "email" varchar NOT NULL, "username" varchar NOT NULL, "password_digest" varchar NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE sqlite_sequence(name,seq);
CREATE UNIQUE INDEX "index_users_on_email" ON "users" ("email");
CREATE UNIQUE INDEX "index_users_on_username" ON "users" ("username");
CREATE TABLE IF NOT EXISTS "database_structures" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL);
CREATE TABLE IF NOT EXISTS "player_decks" ("id" integer PRIMARY KEY AUTOINCREMENT NOT NULL, "user_id" integer NOT NULL, "deck_data" text, "created_at" datetime(6) NOT NULL, "updated_at" datetime(6) NOT NULL, CONSTRAINT "fk_rails_54ae89d469"
FOREIGN KEY ("user_id")
  REFERENCES "users" ("id")
);
CREATE INDEX "index_player_decks_on_user_id" ON "player_decks" ("user_id");
INSERT INTO "schema_migrations" (version) VALUES
('20240816164623'),
('20240816163333'),
('20240813193458'),
('20240802185549'),
('20240731224025'),
('20240731223826');

