import { Knex } from 'knex';

const lowercaseNameFunction = `
CREATE OR REPLACE FUNCTION nameToLowerCase()
RETURNS trigger AS $$
BEGIN
	NEW.Name = lower(NEW.Name);
	RETURN NEW;
END;
$$ LANGUAGE plpgsql
`


const lowercaseNameTagTrigger = `
CREATE TRIGGER lowercaseNameTagTrigger
BEFORE INSERT OR UPDATE ON tags
FOR EACH ROW
EXECUTE PROCEDURE nameToLowerCase()
`

const fixExistingTags = `
UPDATE tags SET name = lower(name)
`


module.exports = {
	async up(k : Knex) {
		await k.raw(lowercaseNameFunction)
		await k.raw(lowercaseNameTagTrigger)
		await k.raw(fixExistingTags)
	},

	async down(k : Knex) {
		await k.raw(`DROP TRIGGER IF EXISTS lowercaseNameTagTrigger ON tags`)
		await k.raw(`DROP FUNCTION IF EXISTS nameToLowerCase`)
	}
}
