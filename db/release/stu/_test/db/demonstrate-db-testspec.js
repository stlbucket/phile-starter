import { withRootDb, findUser } from "../../../../test-helpers/for-db";
import { expect } from "chai"
const logger = require('pino')()

test("consume mme", () =>
  withRootDb(async pgClient => {
    // capture an mme event
    await pgClient.query("insert into stu.class_processing_result(id) values('tacos')");

    const blah =  await pgClient.query("select * from stu.class_processing_result");
    logger.info('blah:', blah.rows)


    // consumme mme event


    // logger.info('user:', user.rows[0])
  })
);
