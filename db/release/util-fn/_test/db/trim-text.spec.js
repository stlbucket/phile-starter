import { withRootDb, findUser } from "../../../../test-helpers/for-db";
import { expect } from "chai"
const logger = require('pino')()

describe('trim_text', ()=> {
  test("trim leading whitespace", (done) =>
    withRootDb(async pgClient => {
      const input = '        leading whitespace'
      const expected = 'leading whitespace'
  
      try {
        const result = (await pgClient.query(`select util_fn.trim_text('${input}')`)).rows[0].trim_text
        expect(result).to.equal(expected)
        done()
      } catch (e) {
        done(e)
      }
    })
  )

  test("trim trailing whitespace", (done) =>
    withRootDb(async pgClient => {
      const input = 'trailing whitespace           '
      const expected = 'trailing whitespace'
  
      try {
        const result = (await pgClient.query(`select util_fn.trim_text('${input}')`)).rows[0].trim_text
        expect(result).to.equal(expected)
        done()
      } catch (e) {
        done(e)
      }
    })
  )

  test("trim trailing and leading whitespace", (done) =>
    withRootDb(async pgClient => {
      const input = '        trailing and leading whitespace           '
      const expected = 'trailing and leading whitespace'
  
      try {
        const result = (await pgClient.query(`select util_fn.trim_text('${input}')`)).rows[0].trim_text
        expect(result).to.equal(expected)
        done()
      } catch (e) {
        done(e)
      }
    })
  )

  test("trim no whitespace", (done) =>
    withRootDb(async pgClient => {
      const input = 'no whitespace'
      const expected = 'no whitespace'
  
      try {
        const result = (await pgClient.query(`select util_fn.trim_text('${input}')`)).rows[0].trim_text
        expect(result).to.equal(expected)
        done()
      } catch (e) {
        done(e)
      }
    })
  )

})

