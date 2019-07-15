import { withRootDb } from "../../../../test-helpers/for-db";
import { expect } from "chai"
const logger = require('pino')()

test.skip("can query all orgs", () =>
  withRootDb(async pgClient => {
    const orgs = await pgClient.query('select * from org.organization')
    logger.info('How many orgs are there:', orgs.rows.length)
    expect(orgs.rows.length > 0).to.equal(true)
  })
);
