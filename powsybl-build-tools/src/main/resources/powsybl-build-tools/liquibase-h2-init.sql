/* Liquibase H2 database init script
 * Due to some differences between H2 and PostgreSQL dialects, even with H2 compatibility mode,
 * we need to add some little "hacks" to not have errors like "unknown type".
 */;

/** There is some datatypes H2 in compatibility mode don"t take into account, so we create a domain/alias of equivalent type **/;
CREATE DOMAIN IF NOT EXISTS JSONB AS JSON;
/*CREATE DOMAIN IF NOT EXISTS OID AS BINARY LARGE OBJECT;*/
/*create domain if not exist timestampstz as timestamp;*/
